//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var businesses = [Business]()
    
    var isDownloadingMoreData = false

    var refreshControl: UIRefreshControl!
    
    var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        navigationItem.titleView = searchBar
        
        performSearch()
        
        self.refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshSearch), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        // Footer view for activity indicator (infinite scrolling)
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50))
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicatorView.center = footerView.center
        activityIndicatorView.startAnimating()
        footerView.addSubview(activityIndicatorView)
        tableView.tableFooterView = footerView
        
//        Business.searchWithTerm(term: "Restaurants", sort: .distance, categories: ["asianfusion", "burgers"], deals: true) {
//            (businesses, error) in
//            guard let businesses = businesses else { return }
//            self.businesses = businesses
//        }
    }
    
    
    // FIXME: Need to fetch more data from same keyword
    func performMoreSearch() {
        isDownloadingMoreData = true
        Business.searchWithTerm(term: searchBar.text ?? "") {
            (businesses, error) in
            guard let businesses = businesses else { return }
            for business in businesses {
                self.businesses.append(business)
            }
            self.tableView.reloadData()
            self.isDownloadingMoreData = false
        }
    }
    
    
    func refreshSearch(sender: UIRefreshControl) {
        var term = ""
        if let searchTerm = searchBar.text {
            term = searchTerm
        }
        performSearch(with: term)
    }
    
    func performSearch(with term: String = "") {
        Business.searchWithTerm(term: term) {
            (businesses, error) in
            guard let businesses = businesses else { return }
            self.businesses = businesses
            self.tableView.reloadData()
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
        }
    }
}


// MARK: - Infinite scrolling

extension BusinessesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isDownloadingMoreData else { return }
        
        if scrollView.contentOffset.y > scrollView.contentSize.height - tableView.bounds.height && tableView.isDragging {
                performMoreSearch()
        }
    }
}

// MARK: - UISearchBar delegate

extension BusinessesViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        performSearch(with: searchBar.text ?? "")
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resignFirstResponder()
        searchBar.resignFirstResponder()
    }
    
}

// MARK: - UITableView dataSource and delegate

extension BusinessesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "businessCell") as! BusinessCell
        cell.business = businesses[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        searchBar.resignFirstResponder()
    }
}

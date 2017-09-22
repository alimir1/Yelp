//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MBProgressHUD

class BusinessesViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var businesses = [Business]()
    var isDownloadingMoreData = false
    var refreshControl: UIRefreshControl!
    var searchBar: UISearchBar!
    var searchTerm = SearchTerm()

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.delegate = self
        searchBar.placeholder = "Restaurants"
        navigationItem.titleView = searchBar
        
        performSearch(with: searchTerm)
        
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
    }
    
    
    // FIXME: Need to fetch more data from same keyword
    func performMoreSearch(with searchTerm: SearchTerm) {
        isDownloadingMoreData = true
        Business.searchWithTerm(term: searchTerm.term) {
            (businesses, error) in
            self.isDownloadingMoreData = false
            guard let businesses = businesses else { return }
            for business in businesses {
                self.businesses.append(business)
            }
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Helpers
    
    func refreshSearch(sender: UIRefreshControl) {
        performSearch(with: searchTerm)
    }
    
    func performSearch(with term: SearchTerm) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Business.searchWithTerm(term: term.term, sort: term.sort, categories: term.categories, deals: term.deals, distanceLimit: term.distanceLimit) {
            (businesses, error) in
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            MBProgressHUD.hide(for: self.view, animated: true)
            guard let businesses = businesses else {
                print("no results!")
                self.businesses = []
                self.tableView.reloadData()
                return
            }
            self.businesses = businesses
            self.tableView.reloadData()
        }
    }
}


// MARK: - Infinite scrolling

extension BusinessesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isDownloadingMoreData else { return }
        
        if scrollView.contentOffset.y > scrollView.contentSize.height - tableView.bounds.height && tableView.isDragging {
                performMoreSearch(with: self.searchTerm)
        }
    }
}

// MARK: - UISearchBar delegate

extension BusinessesViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = false
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchTerm.term = searchBar.text ?? ""
        performSearch(with: searchTerm)
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resignFirstResponder()
        searchBar.resignFirstResponder()
    }
}

// MARK: - Navigation

extension BusinessesViewController {
    
    @IBAction func unwindToBusinessVC(segue: UIStoryboardSegue) {
        if segue.identifier == "filtersVC" {
            let filtersVC = segue.source as! FilterViewController
            if let searchTerm = filtersVC.searchTerm {
                self.searchTerm = searchTerm
            }
            performSearch(with: searchTerm)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "filtersVC" {
            let navCtrl = segue.destination as! UINavigationController
            let filtersVC = navCtrl.topViewController as! FilterViewController
            filtersVC.searchTerm = searchTerm
        }
    }
}

// MARK: - UITableView dataSource and delegate

extension BusinessesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.tableFooterView?.isHidden = !(businesses.count > 0)
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

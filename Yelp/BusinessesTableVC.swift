//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesTableVC: UIViewController, BusinessesContainerVCDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var isDownloadingMoreData = false
    var refreshControl: UIRefreshControl!
    var searchBar: UISearchBar!
    var businesses = [Business]()
    var footerActivityIndicatorView: UIView!
    var businessesContainerVC: BusinessesContainerVC!
    
    var searchTerm = SearchTerm() {
        didSet {
            businessesContainerVC.searchTerm = searchTerm
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVCViews()
        setupDelegates()
        refreshControl.addTarget(self, action: #selector(refreshSearch), for: .valueChanged)
        performSearch(with: searchTerm)
    }
    
    func setupDelegates() {
        businessesContainerVC.delegate = self
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func performSearch(with term: SearchTerm) {
        businessesContainerVC.performSearch(with: searchTerm)
    }
    
    func performMoreSearch(with term: SearchTerm) {
        businessesContainerVC.performMoreSearch(with: searchTerm)
    }
    
    // MARK: Target-Action
    
    func refreshSearch(sender: UIRefreshControl) {
        performSearch(with: searchTerm)
    }
    
}

// MARK: - Views Setup

extension BusinessesTableVC {
    
    func setupVCViews() {
        searchBarSetup()
        tableViewSetup()
        refreshControlSetup()
        addFooterView()
        footerViewSetup()
    }
    
    func searchBarSetup() {
        searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.placeholder = "Restaurants"
        self.navigationController?.navigationItem.titleView = searchBar
//        navigationItem.titleView = searchBar
    }
    
    func tableViewSetup() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    func refreshControlSetup() {
        self.refreshControl = UIRefreshControl()
        tableView.insertSubview(refreshControl, at: 0)
    }
    
    /// Footer view for activity indicator (infinite scrolling)
    func addFooterView() {
        footerActivityIndicatorView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50))
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicatorView.center = footerActivityIndicatorView.center
        activityIndicatorView.startAnimating()
        footerActivityIndicatorView.addSubview(activityIndicatorView)
        tableView.tableFooterView = footerActivityIndicatorView
    }
}

// MARK: - Infinite scrolling

extension BusinessesTableVC: UIScrollViewDelegate {
    
    func footerViewSetup() {
        if tableView.contentOffset.y > tableView.contentSize.height - tableView.bounds.height - 55 && tableView.isDragging {
            footerActivityIndicatorView.isHidden = false
        } else {
            footerActivityIndicatorView.isHidden = true
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        footerViewSetup()
        guard !isDownloadingMoreData else { return }
        if scrollView.contentOffset.y > scrollView.contentSize.height - tableView.bounds.height && tableView.isDragging {
                isDownloadingMoreData = true
                performMoreSearch(with: self.searchTerm)
        }
    }
}

// MARK: - BusinessesContainerVCDelegate

extension BusinessesTableVC {
    func businessesContainerVC(_ viewController: BusinessesContainerVC, didPerformSearch businesses: [Business]?, error: Error?) {
        if self.refreshControl.isRefreshing { self.refreshControl.endRefreshing() }
        guard let businesses = businesses else {
            print("no results!")
            self.businesses = []
            self.tableView.reloadData()
            return
        }
        self.businesses = businesses
        self.tableView.reloadData()
    }
    
    func businessesContainerVC(_ viewController: BusinessesContainerVC, didPerformMoreSearch businesses: [Business]?, error: Error?) {
        self.isDownloadingMoreData = false
        self.footerViewSetup()
        guard let businesses = businesses else { return }
        for business in businesses {
            self.businesses.append(business)
        }
        self.tableView.reloadData()
    }
}

// MARK: - UISearchBar delegate

extension BusinessesTableVC: UISearchBarDelegate {
    
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

extension BusinessesTableVC {
    
    @IBAction func unwindToBusinessVC(segue: UIStoryboardSegue) {
        if segue.identifier == "filtersVC" {
            let filtersVC = segue.source as! FilterViewController
            if let searchTerm = filtersVC.searchTerm {
                self.searchTerm = searchTerm
            }
            performSearch(with: searchTerm)
        }
    }
}

// MARK: - UITableView dataSource and delegate

extension BusinessesTableVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.tableFooterView?.isHidden = !(businesses.count > 0)
        footerViewSetup()
        return businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "businessCell") as! BusinessCell
        cell.business = businesses[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

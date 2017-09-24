//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesTableVC: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var isDownloadingMoreData = false
    var refreshControl: UIRefreshControl!
    var footerActivityIndicatorView: UIView!
    var businesses = [Business]()
    var businessContainerVC: BusinessesContainerVC?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVCViews()
        setupDelegates()
        refreshControl.addTarget(self, action: #selector(refreshSearch), for: .valueChanged)
    }
    
    func setupDelegates() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: Target-Action
    
    func refreshSearch(sender: UIRefreshControl) {
        businessContainerVC?.performSearch()
    }
    
}

// MARK: - Views Setup

extension BusinessesTableVC {
    
    func setupVCViews() {
        tableViewSetup()
        refreshControlSetup()
        addFooterView()
        footerViewSetup()
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
            self.businessContainerVC?.performMoreSearch()
        }
    }
}

// MARK: - BusinessContainerVCDelegate

extension BusinessesTableVC: BusinessesContainerVCDelegate {
    func businessesContainerVC(_ controller: BusinessesContainerVC, didPerformSearch error: Error?) {
        if self.refreshControl.isRefreshing { self.refreshControl.endRefreshing() }
    }
    
    func businessesContainerVC(_ controller: BusinessesContainerVC, didPerformMoreSearch error: Error?) {
        self.isDownloadingMoreData = false
        self.footerViewSetup()
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

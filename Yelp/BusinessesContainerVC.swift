//
//  BusinessContainerVC.swift
//  Yelp
//
//  Created by Ali Mir on 9/23/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import MBProgressHUD

@objc protocol BusinessesContainerVCDelegate: class {
    @objc optional func businessesContainerVC(_ controller: BusinessesContainerVC, didPerformSearch error: Error?)
    @objc optional func businessesContainerVC(_ controller: BusinessesContainerVC, didPerformMoreSearch error: Error?)
}

class BusinessesContainerVC: UIViewController {
    
    // MARK: Outlets
    @IBOutlet fileprivate var changeLayoutButton: UIButton!
    
    // MARK: Stored Properties
    
    var mapViewController: BusinessesMapVC!
    var tableViewController: BusinessesTableVC!
    fileprivate var searchBar: UISearchBar!
    fileprivate var searchTerm = SearchTerm()
    weak var delegate: BusinessesContainerVCDelegate?
    
    
    fileprivate var businesses = [Business]() {
        didSet {
            if isListView {
                tableViewController.businesses = businesses
                tableViewController.businessContainerVC = self
                self.delegate = tableViewController
                self.tableViewController?.tableView.reloadData()
            } else {
                mapViewController.businesses = businesses
            }
        }
    }
    
    fileprivate func refreshVCs() {
        if isListView {
            removeVC(vc: mapViewController)
            addVC(vc: tableViewController)
            tableViewController.businesses = businesses
            tableViewController.businessContainerVC = self
            self.delegate = tableViewController
            self.tableViewController?.tableView.reloadData()
            changeLayoutButton.setTitle("Map", for: .normal)
        } else {
            removeVC(vc: tableViewController)
            addVC(vc: mapViewController)
            mapViewController.businesses = businesses
            changeLayoutButton.setTitle("List", for: .normal)
        }
    }
    
    // MARK: Property Observers
    
    fileprivate var isListView = true {
        didSet {
            refreshVCs()
        }
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBarSetup()
        searchBar.delegate = self
        
        addVC(vc: tableViewController)
        performSearch()
    }
    
    fileprivate func addVC(vc: UIViewController) {
        addChildViewController(vc)
        vc.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
    }
    
    fileprivate func removeVC(vc: UIViewController) {
        vc.willMove(toParentViewController: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParentViewController()
    }
    
    fileprivate func searchBarSetup() {
        searchBar = UISearchBar()
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
    }
}

// MARK: - Target-action

extension BusinessesContainerVC {
    @IBAction fileprivate func onChangeLayout(sender: AnyObject?) {
        isListView = !isListView
    }
}

// MARK: - Navigation

extension BusinessesContainerVC {
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     }*/
}

// MARK: - Networking

extension BusinessesContainerVC {
    func performMoreSearch() {
        Business.searchWithTerm(term: searchTerm.term, sort: searchTerm.sort, categories: searchTerm.categories, deals: searchTerm.deals, distanceLimit: searchTerm.distanceLimit, shouldLoadMore: true) {
            (businesses, error) in
            self.delegate?.businessesContainerVC?(self, didPerformMoreSearch: error)
            guard let businesses = businesses else { return }
            for business in businesses {
                self.businesses.append(business)
            }
        }
    }
    
    func performSearch() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Business.searchWithTerm(term: searchTerm.term, sort: searchTerm.sort, categories: searchTerm.categories, deals: searchTerm.deals, distanceLimit: searchTerm.distanceLimit) {
            (businesses, error) in
            self.delegate?.businessesContainerVC?(self, didPerformSearch: error)
            MBProgressHUD.hide(for: self.view, animated: true)
            guard let businesses = businesses else {
                print("no results!")
                self.businesses = []
                return
            }
            self.businesses = businesses
        }
    }
}

// MARK: - Navigation
extension BusinessesContainerVC {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "filtersVC" {
            let navCtrl = segue.destination as! UINavigationController
            let filterVC = navCtrl.topViewController as! FilterViewController
            filterVC.searchTerm = searchTerm
        }
    }
    
    @IBAction func unwindToBusinessVC(segue: UIStoryboardSegue) {
        if segue.identifier == "filtersVC" {
            let filtersVC = segue.source as! FilterViewController
            if let searchTerm = filtersVC.searchTerm {
                self.searchTerm = searchTerm
            }
            performSearch()
        }
    }
}

// MARK: - UISearchBar delegate

extension BusinessesContainerVC: UISearchBarDelegate {
    
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
        performSearch()
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resignFirstResponder()
        searchBar.resignFirstResponder()
    }
}

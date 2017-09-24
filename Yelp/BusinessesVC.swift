//
//  BusinessContainerVC.swift
//  Yelp
//
//  Created by Ali Mir on 9/23/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import MBProgressHUD

class BusinessesContainerVC: UIViewController {
    
    // MARK: Outlets
    @IBOutlet var changeLayoutButton: UIButton!
    
    // MARK: Stored Properties
    
    var mapViewController: BusinessesMapVC!
    var tableViewControlelr: BusinessesTableVC!
    var searchTerm = SearchTerm()
    weak var delegate: BusinessesContainerVCDelegate?
    
    // MARK: Property Observers
    
    var isListView = true {
        didSet {
            if isListView {
                removeVC(vc: mapViewController)
                addVC(vc: tableViewControlelr)
            } else {
                removeVC(vc: tableViewControlelr)
                addVC(vc: mapViewController)
                mapViewController.businesses = tableViewControlelr.businesses
            }
        }
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addVC(vc: tableViewControlelr)
    }
    
    func addVC(vc: UIViewController) {
        addChildViewController(vc)
        vc.view.frame = view.frame
        vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
    }
    
    func removeVC(vc: UIViewController) {
        vc.willMove(toParentViewController: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParentViewController()
    }
}

// MARK: - Target-action

extension BusinessesContainerVC {
    @IBAction func onChangeLayout(sender: AnyObject?) {
        isListView = !isListView
    }
}

// MARK: - Navigation

extension BusinessesContainerVC {

}

// MARK: - Networking

extension BusinessesContainerVC {
    func performMoreSearch(with searchTerm: SearchTerm) {
        Business.searchWithTerm(term: searchTerm.term, sort: searchTerm.sort, categories: searchTerm.categories, deals: searchTerm.deals, distanceLimit: searchTerm.distanceLimit, shouldLoadMore: true) {
            (businesses, error) in
            self.delegate?.businessesContainerVC?(self, didPerformMoreSearch: businesses, error: error)
        }
    }
    
    func performSearch(with term: SearchTerm) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Business.searchWithTerm(term: term.term, sort: term.sort, categories: term.categories, deals: term.deals, distanceLimit: term.distanceLimit) {
            (businesses, error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.delegate?.businessesContainerVC?(self, didPerformSearch: businesses, error: error)
        }
    }
}

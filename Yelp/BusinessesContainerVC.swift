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
    @objc optional func businessesContainerVC(_ viewController: BusinessesContainerVC, didPerformSearch businesses: [Business]?, error: Error?)
    @objc optional func businessesContainerVC(_ viewController: BusinessesContainerVC, didPerformMoreSearch businesses: [Business]?, error: Error?)
}

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
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "businessesTBVC" {
            let businessesTBVC = segue.destination as! BusinessesTableVC
            businessesTBVC.businessesContainerVC = self
        }
        
        if segue.identifier == "mapVC" {
            let mapVC = segue.destination as! BusinessesMapVC
            mapVC.businessContainerVC = self
        }
        
        if segue.identifier == "filtersVC" {
            let navCtrl = segue.destination as! UINavigationController
            let filtersVC = navCtrl.topViewController as! FilterViewController
            filtersVC.searchTerm = searchTerm
        }
    }*/
    
    /*func lfksdjfk(from oldVC: UIViewController, to newVC: UIViewController) {
        // Prepare the two view controllers for the change.
        oldVC.willMove(toParentViewController: nil)
        addChildViewController(newVC)
        // Get the start frame of the new view controller and the end frame
        // for the old view controller. Both rectangles are offscreen.
        newVC.view.frame = view.frame
        transition(from: oldVC, to: newVC, duration: 0.25, options: [], animations: nil)
        oldVC.removeFromParentViewController()
        newVC.didMove(toParentViewController: self)
    }*/
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

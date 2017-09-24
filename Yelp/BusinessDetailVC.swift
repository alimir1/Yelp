//
//  BusinessDetailVC.swift
//  Yelp
//
//  Created by Ali Mir on 9/24/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class BusinessDetailVC: UITableViewController {
    
    @IBOutlet fileprivate var nameLabel: UILabel!
    @IBOutlet fileprivate var ratingImageView: UIImageView!
    @IBOutlet fileprivate var categoriesLabel: UILabel!
    @IBOutlet fileprivate var numReviewsLabel: UILabel!
    @IBOutlet fileprivate var isClosedLabel: UILabel!
    @IBOutlet fileprivate var businessImageView: UIImageView!
    @IBOutlet fileprivate var mapView: MKMapView!
    @IBOutlet fileprivate var displayAddressLabel: UILabel!
    @IBOutlet fileprivate var displayPhoneLabel: UILabel!
    
    var business: Business!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = business.name
        setupViews()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50
        
    }
    
    fileprivate func setupViews() {
        setupLabels()
        setupImageViews()
        setupAnnotation()
    }
    
    fileprivate func setupLabels() {
        self.nameLabel.text = business.name
        self.numReviewsLabel.text = "\(business.reviewCount ?? 0) Reviews"
        self.categoriesLabel.text = business.categories
        
        if let isClosed = business.isClosed, isClosed {
            isClosedLabel.text = "Closed"
            isClosedLabel.textColor = .red
        } else {
            isClosedLabel.text = "Open"
            isClosedLabel.textColor = .green
        }
        displayAddressLabel.text = business.address
        displayPhoneLabel.text = business.displayPhone
    }
    
    fileprivate func setupImageViews() {
        if let ratingImageURL = business.ratingImageURL {
            self.ratingImageView.setImageWith(ratingImageURL)
        }
        
        if let imageURL = business.imageURL {
            businessImageView.setImageWith(imageURL)
        }
    }
    
    fileprivate func setupAnnotation() {
        if let coordinate = business.coordinate, let latitude = coordinate.latitude, let longitude = coordinate.longitude {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            mapView.addAnnotation(annotation)
            mapView.showAnnotations([annotation], animated: true)
        }
    }
}

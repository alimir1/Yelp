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
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var ratingImageView: UIImageView!
    @IBOutlet var categoriesLabel: UILabel!
    @IBOutlet var numReviewsLabel: UILabel!
    @IBOutlet var isClosedLabel: UILabel!
    @IBOutlet var businessImageView: UIImageView!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var displayAddressLabel: UILabel!
    @IBOutlet var displayPhoneLabel: UILabel!
    
    var business: Business!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = business.name
        
        if let coordinate = business.coordinate, let latitude = coordinate.latitude, let longitude = coordinate.longitude {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            mapView.addAnnotation(annotation)
            mapView.showAnnotations([annotation], animated: true)
        }
        
        self.nameLabel.text = business.name
        self.ratingImageView.setImageWith(business.ratingImageURL!)
        self.numReviewsLabel.text = "\(business.reviewCount ?? 0) Reviews"
        self.categoriesLabel.text = business.categories
        
        if let isClosed = business.isClosed, isClosed {
            isClosedLabel.text = "Closed"
            isClosedLabel.textColor = .red
        } else {
            isClosedLabel.text = "Open"
            isClosedLabel.textColor = .green
        }
        
        if let imageURL = business.imageURL {
                businessImageView.setImageWith(imageURL)
        }
        
        displayAddressLabel.text = business.address
        displayPhoneLabel.text = business.displayPhone
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50
        
    }
}

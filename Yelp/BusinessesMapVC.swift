//
//  BusinessesMapVC.swift
//  Yelp
//
//  Created by Ali Mir on 9/23/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class BusinessesMapVC: UIViewController, BusinessesContainerVCDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    var businessContainerVC: BusinessesContainerVC!
    
    var businesses = [Business]() {
        didSet {
            addAnnotationsToMap()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        businessContainerVC.delegate = self
        
    }
    
    func addAnnotationsToMap() {
        var annotations = [MKAnnotation]()
        
        annotations = businesses.map { business in
            let annotation = MKPointAnnotation()
            annotation.title = business.name!
            annotation.subtitle = business.categories!
            annotation.coordinate =  CLLocationCoordinate2D(latitude: business.coordinate!.latitude!, longitude: business.coordinate!.longitude!)
            return annotation
        }
        
        mapView.addAnnotations(annotations)
    }
    
    func businessesContainerVC(_ viewController: BusinessesContainerVC, didPerformSearch businesses: [Business]?, error: Error?) {
        if let businesses = businesses {
            self.businesses = businesses
        }
    }
    
    func businessesContainerVC(_ viewController: BusinessesContainerVC, didPerformMoreSearch businesses: [Business]?, error: Error?) {
        if let businesses = businesses {
            for business in businesses {
                self.businesses.append(business)
            }
        }
    }
    
}

//
//  BusinessesMapVC.swift
//  Yelp
//
//  Created by Ali Mir on 9/23/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class BusinessesMapVC: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    var annotations = [MKAnnotation]()
    
    var businesses = [Business]() {
        didSet {
            print("there are \(businesses.count) in mapViewVC")
            addAnnotationsToMap()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    func addAnnotationsToMap() {
        if annotations.count > 0 { mapView.removeAnnotations(annotations) }
        annotations.removeAll()
        for business in businesses {
            guard let latitude = business.coordinate?.latitude else { continue }
            guard let longitude = business.coordinate?.longitude else { continue }
            let annotation = MKPointAnnotation()
            annotation.title = business.name ?? ""
            annotation.subtitle = business.categories ?? ""
            annotation.coordinate =  CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            annotations.append(annotation)
        }
        mapView.addAnnotations(annotations)
        mapView.showAnnotations(annotations, animated: true)
    }
    
}


extension BusinessesMapVC: MKMapViewDelegate {
    /*func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "pin"
        print("debug: annotation coordinate: \(annotation.coordinate)")
        var view: MKPinAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
        }
        return view
    }*/
}

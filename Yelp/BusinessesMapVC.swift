//
//  BusinessesMapVC.swift
//  Yelp
//
//  Created by Ali Mir on 9/23/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class YelpAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var atIndex: Int?
    init(coordinate: CLLocationCoordinate2D, at index: Int) {
        self.coordinate = coordinate
        self.atIndex = index
        title = nil
        subtitle = nil
    }
}

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
        for (index, business) in businesses.enumerated() {
            guard let latitude = business.coordinate?.latitude else { continue }
            guard let longitude = business.coordinate?.longitude else { continue }
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let annotation = YelpAnnotation(coordinate: coordinate, at: index)
            annotation.title = business.name ?? ""
            annotation.subtitle = business.categories ?? ""
            annotations.append(annotation)
        }
        mapView.addAnnotations(annotations)
        mapView.showAnnotations(annotations, animated: true)
    }
    
}

extension BusinessesMapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "pin"
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
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? YelpAnnotation else { return }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let businessDetailVC = storyboard.instantiateViewController(withIdentifier: "businessDetailVC") as! BusinessDetailVC
        businessDetailVC.business = businesses[annotation.atIndex!]
        self.navigationController?.pushViewController(businessDetailVC, animated: true)
    }
    
}

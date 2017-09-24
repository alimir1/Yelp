//
//  YelpAnnotation.swift
//  Yelp
//
//  Created by Ali Mir on 9/24/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

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

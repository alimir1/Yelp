//
//  Filter.swift
//  Yelp
//
//  Created by Ali Mir on 9/21/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import Foundation

enum Filter: Int, CustomStringConvertible {
    case offeringDeal = 0
    case distance
    case sortBy
    case category
    
    var description: String {
        switch self {
        case .offeringDeal:
            return "Offering a Deal"
        case .distance:
            return "Distance"
        case .sortBy:
            return "Sort By"
        case .category:
            return "Category"
        }
    }
}

//
//  Pagination.swift
//  Yelp
//
//  Created by Ali Mir on 9/21/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

// offset, limit

import Foundation

struct Pagination {
    static var limit = 20
    static var offSet = 0
    
    static var nextPage: (offSet: Int, limit: Int) {
        offSet += limit
        return (offSet: offSet, limit: limit)
    }
    
    static var newPage: (offSet: Int, limit: Int) {
        offSet = 0
        return (offSet: offSet, limit: limit)
    }
    
}

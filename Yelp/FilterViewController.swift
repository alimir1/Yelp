//
//  FilterViewController.swift
//  Yelp
//
//  Created by Ali Mir on 9/20/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

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

class FilterViewController: UIViewController {
    
    var filters: [Filter : [Any]] = [
        .offeringDeal : [true],
        .distance : [5, 10, 15],
        .sortBy : ["Best Match", "Distance", "Highest Rated"],
        .category : ["Afghan", "African", "Indian"]
    ]
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        
        filters[.offeringDeal] = [true]
        
        super.viewDidLoad()
    }
    
    @IBAction func onCancel(sender: AnyObject?) {
        self.dismiss(animated: true, completion: nil)
    }
    
}


extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let filter = Filter(rawValue: section)!
        return filter == .offeringDeal ? nil : filter.description
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filters.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let filter = Filter(rawValue: section)!
        return filters[filter]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

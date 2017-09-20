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
    @IBOutlet var tableView: UITableView!
    var filters = [Filter : [Any]]()
    
    var searchTerm: SearchTerm?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filters[.offeringDeal] = [true]
        filters[.distance] = (5...YelpMaxRadiusFilter).filter { $0 % 5 == 0 }
        filters[.sortBy] = [YelpSortMode.bestMatched, YelpSortMode.distance, YelpSortMode.highestRated]
        filters[.category] = YelpCategories
        
        if searchTerm == nil { searchTerm = SearchTerm() }
    }
    
    @IBAction func onCancel(sender: AnyObject?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSave(sender: AnyObject?) {
        performSegue(withIdentifier: "filtersVC", sender: self)
    }
    
}


extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
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
        let filter = Filter(rawValue: indexPath.section)!
        let cell = cellForFilter(filter: filter, withIndexPath: indexPath)
        return cell
    }
    
    func cellForFilter(filter: Filter, withIndexPath indexPath: IndexPath) -> UITableViewCell {
        switch filter {
        case .offeringDeal:
            let retCell = tableView.dequeueReusableCell(withIdentifier: "switchCell") as! SwitchCell
            retCell.filterNameLabel.text = filter.description
            return retCell
        case .distance:
            let retCell = tableView.dequeueReusableCell(withIdentifier: "selectionCell") as! SelectionCell
            let distances = filters[filter] as! [Int]
            retCell.filterNameLabel.text = "\(distances[indexPath.row]) miles"
            retCell.checkMark = true
            return retCell
        case .sortBy:
            let retCell = tableView.dequeueReusableCell(withIdentifier: "selectionCell") as! SelectionCell
            let sortModes = filters[filter] as! [YelpSortMode]
            retCell.filterNameLabel.text = sortModes[indexPath.row].description
            retCell.checkMark = true
            return retCell
        case .category:
            let retCell = tableView.dequeueReusableCell(withIdentifier: "switchCell") as! SwitchCell
            let categories = filters[filter] as! [String]
            retCell.filterNameLabel.text = categories[indexPath.row]
            return retCell
        }
    }
    
}

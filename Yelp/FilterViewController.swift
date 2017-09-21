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
    
    var offeringDeal = false {
        didSet {
            searchTerm?.deals = offeringDeal
        }
    }
    
    var categoryFilters = [String : Bool]() {
        didSet {
            guard let searchTerm = searchTerm else { return }
            let categoriesToAdd = categoryFilters.filter {$0.value != false}.map {$0.key}
            searchTerm.categories = categoriesToAdd.count > 0 ? categoriesToAdd : nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var catFilters = [String : Bool]()
        if let searchTerm = searchTerm, let categories = searchTerm.categories {
            for category in categories {
                catFilters[category] = true
            }
        }
        categoryFilters = catFilters
        
        for (yelpCategory, _)  in YelpCategories {
            if categoryFilters[yelpCategory] == nil {
                categoryFilters[yelpCategory] = false
            }
        }
        
        offeringDeal = searchTerm?.deals ?? false
        
        filters[.offeringDeal] = [true]
        filters[.distance] = (5...YelpMaxRadiusFilter).filter { $0 % 5 == 0 }
        filters[.sortBy] = [YelpSortMode.bestMatched, YelpSortMode.distance, YelpSortMode.highestRated]
        filters[.category] = YelpCategories.map {$0.key}.sorted {$0 < $1}
        
        
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
        
        
        let switchCell = tableView.dequeueReusableCell(withIdentifier: "switchCell") as! SwitchCell
        let selectionCell = tableView.dequeueReusableCell(withIdentifier: "selectionCell") as! SelectionCell
        
        switch filter {
        case .offeringDeal:
            switchCell.filterNameLabel.text = filter.description
            switchCell.filterSwitch.isOn = self.offeringDeal
            switchCell.switchAction = {
                isOn in
                self.offeringDeal = isOn
            }
            return switchCell
        case .distance:
            let distances = filters[filter] as! [Int]
            selectionCell.filterNameLabel.text = "\(distances[indexPath.row]) miles"
            selectionCell.checkMark = true
            return selectionCell
        case .sortBy:
            let sortModes = filters[filter] as! [YelpSortMode]
            selectionCell.filterNameLabel.text = sortModes[indexPath.row].description
            selectionCell.checkMark = true
            return selectionCell
        case .category:
            let categories = filters[filter] as! [String]
            switchCell.filterNameLabel.text = YelpCategories[categories[indexPath.row]] ?? ""
            switchCell.filterSwitch.isOn = categoryFilters[categories[indexPath.row]] ?? false
            switchCell.switchAction = {
                isOn in
                self.categoryFilters[categories[indexPath.row]] = isOn
            }
            return switchCell
        }
    }
    
}

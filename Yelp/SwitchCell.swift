//
//  SwitchCell.swift
//  Yelp
//
//  Created by Ali Mir on 9/20/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class SwitchCell: UITableViewCell {

    @IBOutlet var filterNameLabel: UILabel!
    @IBOutlet var filterSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}

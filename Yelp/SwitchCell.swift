//
//  SwitchCell.swift
//  Yelp
//
//  Created by Ali Mir on 9/20/17.
//  Copyright © 2017 Ali Mir. All rights reserved.
//

import UIKit

class SwitchCell: UITableViewCell {

    @IBOutlet var filterNameLabel: UILabel!
    @IBOutlet var filterSwitch: UISwitch!
    
    var switchAction: (Bool) -> Void = { (isOn: Bool) in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    @IBAction func onSwitchChanged(_ sender: UISwitch) {
        switchAction(sender.isOn)
    }
}

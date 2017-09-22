//
//  BusinessCellDelegates.swift
//  Yelp
//
//  Created by Ali Mir on 9/21/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FilterCellDelegate: class {
    @objc optional func filterCell(_ cell: SwitchCell, didChangeSwitchValue isSwitchOn: Bool)
    @objc optional func filterCell(_ cell: SelectionCell, didSelectCell isCellCheckMarked: Bool)
}

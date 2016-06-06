//
//  ActionButton.swift
//  SDCAlertView
//
//  Created by David Barker on 06/06/2016.
//  Copyright © 2016 Scotty Doesn't Code. All rights reserved.
//

import UIKit

class ActionButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)

        self.titleLabel!.adjustsFontSizeToFitWidth = true
        
        self.layer.shadowRadius = 1.0
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
    }
    
    override var highlighted: Bool {
        didSet {
            self.alpha = (self.highlighted ? 0.7 : 1.0)
        }
    }

}

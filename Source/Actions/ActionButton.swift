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
        self.titleLabel!.font = UIFont(name:"HelveticaNeue-Bold", size: 16)
        
        self.layer.shadowRadius = 1.0
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
    }
    
    override var highlighted: Bool {
        didSet {
            var red : CGFloat = 0
            var green : CGFloat = 0
            var blue : CGFloat = 0
            var alpha : CGFloat = 0
            
            self.backgroundColor?.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            
            self.backgroundColor = UIColor(red:red, green:green, blue:blue, alpha:(self.highlighted ? 0.7 : 1.0))
        }
    }

}

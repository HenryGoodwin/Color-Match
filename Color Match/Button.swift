//
//  Button.swift
//  Reflexes
//
//  Created by Henry Goodwin on 2/05/2016.
//  Copyright © 2016 Henry Goodwin. All rights reserved.
//

import UIKit

class Button: UIButton {

    var color: String!
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        
    }
    
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if self.titleLabel?.text == color {
            
            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "CorrectPressed", object: nil))
            
        } else if self.titleLabel?.text != color {
            
            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "WrongPressed", object: nil))

        }
        
        super.touchesEnded(touches, withEvent: event)
        
}
    
}
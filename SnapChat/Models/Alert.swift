//
//  Alert.swift
//  SnapChat
//
//  Created by Bárbara Ferreira on 31/03/2018.
//  Copyright © 2018 Barbara Ferreira. All rights reserved.
//

import UIKit

class Alert {
    var title: String
    var msg: String
    
    init(title: String, msg: String) {
        self.title = title
        self.msg = msg
    }
    
    func getAlert() -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction( actionCancel )
        return alert
        
    }
    
}

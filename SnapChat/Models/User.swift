//
//  User.swift
//  SnapChat
//
//  Created by Bárbara Ferreira on 31/03/2018.
//  Copyright © 2018 Barbara Ferreira. All rights reserved.
//

import Foundation

class User {
    var email: String
    var name: String
    var uid: String
    
    init(email: String, name: String, uid: String){
        self.email = email
        self.name = name
        self.uid = uid
    }
}

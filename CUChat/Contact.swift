//
//  Contact.swift
//  CUChat
//
//  Created by Navee Sratthatad on 5/7/2560 BE.
//  Copyright © 2560 Navee Sratthatad. All rights reserved.
//

import Foundation

class Contact {
    let id: Int64?
    var session: String
    var username: String
    
    init(id: Int64) {
        self.id = id
        session = ""
        username = ""
    }
    
    init(id: Int64, session: String, username: String) {
        self.id = id
        self.session = session
        self.username = username
    }
    
}

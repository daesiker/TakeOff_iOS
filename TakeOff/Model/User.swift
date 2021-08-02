//
//  User.swift
//  TakeOff
//
//  Created by Jun on 2021/08/02.
//

import Foundation

struct User {
    
    var uid: String
    var email: String
    var name: String
    var type: Bool
    var profileImage: String
    var hashTag:[String]
    var follower:[String]
    var following:[String]
    
    init() {
        self.uid = ""
        self.email = ""
        self.name = ""
        self.type = false
        self.profileImage = ""
        self.hashTag = []
        self.follower = []
        self.following = []
    }
    
    
    
}

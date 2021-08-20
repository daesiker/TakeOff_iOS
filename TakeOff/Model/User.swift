//
//  User.swift
//  TakeOff
//
//  Created by Jun on 2021/08/02.
//

import Foundation

struct User: Codable {
    
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
    
    func toDic() -> [String: Any] {
        let dic:[String: Any] = ["email": self.email,
                                 "name": self.name,
                                 "type": self.type,
                                 "follower": self.follower,
                                 "following": self.following,
                                 "hashTag": self.hashTag,
                                 "profileImage": self.profileImage]
        
        return dic
    }
    
    
}

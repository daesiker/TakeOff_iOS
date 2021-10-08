//
//  Post.swift
//  TakeOff
//
//  Created by Jun on 2021/10/08.
//

import Foundation

struct Post {
    var id: String?
    let user:User
    let imageUrl: [String]
    let contents: String
    let creationDate: Date
    let hasLiked: [String]
    let location: String
    
    init(user: User, dictionary: [String: Any]) {
        
        self.user = user
        self.imageUrl = dictionary["imageUrl"] as? [String] ?? []
        self.contents = dictionary["contents"] as? String ?? ""
        self.hasLiked = dictionary["likes"] as? [String] ?? []
        self.location = dictionary["location"] as? String ?? ""
        
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
        
    }
    
}

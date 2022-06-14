//
//  Message.swift
//  TakeOff
//
//  Created by Jun on 2022/06/14.
//

import Foundation
import Firebase

class Message: NSObject {
    
    var fromId: String?
    var text: String?
    var timestamp:NSNumber?
    var toId: String?
    var imageUrl: String?
    var videoUrl: String?
    
    init(_ dic: [String:Any]) {
        self.fromId = dic["fromId"] as? String
        self.text = dic["text"] as? String
        self.toId = dic["toId"] as? String
        self.timestamp = dic["timestamp"] as? NSNumber
        self.imageUrl = dic["imageUrl"] as? String
        self.videoUrl = dic["videoUrl"] as? String
    }
    
    func chatPartnerId() -> String? {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
}

//
//  PostUploadTmp.swift
//  TakeOff
//
//  Created by Jun on 2022/01/19.
//

import Foundation

struct Post: Codable {
    
    var uid:String = ""
    var user:String = ""
    var images:[String] = []
    var contents:String = ""
    var date:Date = Date()
    var hashTag:[String] = []
    var heart:[String] = []
    
    init() {
    }
    
    init(_ uid: String, dic: [String:Any]) {
        self.uid = uid
        self.contents = dic["contents"] as? String ?? ""
        self.hashTag = dic["hashTag"] as? [String] ?? []
        
        let secondsFrom1970 = dic["date"] as? Double ?? 0
        self.date = Date(timeIntervalSince1970: secondsFrom1970)
        
        
        
    }
    
    func toDic() -> [String:Any] {
        
        let values:[String:Any] = [ "user": self.user,
                                    "images": self.images,
                                    "contents": self.contents,
                                    "date": self.date,
                                    "hashTag": self.hashTag,
                                    "heart": self.heart]
        
        return values
    }
    
    
}

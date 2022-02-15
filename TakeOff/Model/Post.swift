//
//  PostUploadTmp.swift
//  TakeOff
//
//  Created by Jun on 2022/01/19.
//

import Foundation

struct Post: Codable {
    
    var user:String = ""
    var images:[String] = []
    var contents:String = ""
    var date:TimeInterval = Date().timeIntervalSince1970
    var hashTag:[String] = []
    var heart:[String] = []
    
    init() {
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

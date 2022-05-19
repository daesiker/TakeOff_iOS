//
//  PostUploadTmp.swift
//  TakeOff
//
//  Created by Jun on 2022/01/19.
//

import Foundation
import UIKit

struct Post {
    
    var uid:String = ""
    var user:String = ""
    var images:[String] = []
    var contents:String = ""
    var date:Date = Date()
    var hashTag:[String] = []
    var heart:[String] = []
    var realImage:[UIImage] = []
    
    init() {
    }
    
    init(_ uid: String, dic: [String:Any]) {
        self.uid = uid
        self.contents = dic["contents"] as? String ?? ""
        self.hashTag = dic["hashTag"] as? [String] ?? []
        self.heart = dic["heart"] as? [String] ?? []
        self.user = dic["user"] as? String ?? ""
        
        let secondsFrom1970 = dic["date"] as? Double ?? 0
        self.date = Date(timeIntervalSince1970: secondsFrom1970)
        
        let urls = dic["images"] as? [String] ?? []
        for url in urls {
            let image = URL(string: url)
            let data = try? Data(contentsOf: image!)
            self.realImage.append(UIImage(data: data!)!)
        }
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

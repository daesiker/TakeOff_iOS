//
//  Calendar.swift
//  TakeOff
//
//  Created by Jun on 2022/06/03.
//

import Foundation

struct CalendarPost {
    
    var uid:String = UUID().uuidString
    var userName:String = ""
    var location:String = ""
    var title:String = ""
    var date:Double = Date().timeIntervalSince1970
    
    init() {
        
    }
    
    init(_ dic: [String:Any]) {
        self.uid = dic["uid"] as? String ?? ""
        self.userName = dic["userName"] as? String ?? ""
        self.location = dic["location"] as? String ?? ""
        self.title = dic["title"] as? String ?? ""
        self.date = dic["date"] as? Double ?? 0
        
    }
    
    
    func toDic() -> [String:Any] {
        
        let dic:[String:Any] = [
            "uid": self.uid,
            "userName":self.userName,
            "location": self.location,
            "title": self.title,
            "date" : self.date
        ]
        
        return dic
    }
    
    
    
}

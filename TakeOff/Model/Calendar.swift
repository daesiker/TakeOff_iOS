//
//  Calendar.swift
//  TakeOff
//
//  Created by Jun on 2022/06/03.
//

import Foundation

struct Calendar {
    
    let uid:String = UUID().uuidString
    var userName:String = ""
    var location:String = ""
    var title:String = ""
    var date:Double = Date().timeIntervalSince1970
    
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

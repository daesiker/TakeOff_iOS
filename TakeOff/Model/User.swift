//
//  LoginModel.swift
//  TakeOff
//
//  Created by mac on 2021/08/06.
//

import Foundation

import RxSwift
import RxRelay
import Firebase

struct User:Codable {
    static private var _loginedUser:User?
    static var loginedUser:User {
        get {
            guard let user = _loginedUser else {
                return User()
            }
            return user
        }
        set {
            _loginedUser = newValue
        }
    }
    
    static func initUser(uid:String, dbInfo:[String:Any]) throws -> User {
        var dic = dbInfo
        dic.updateValue(uid, forKey: "uid")
        
        let JsonData = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
        let user = try JSONDecoder().decode(self, from: JsonData)
		return user
    }
    
    var uid: String = ""
    var email: String = ""
    var name: String = ""
    var pw: String = ""
    var type: Bool = false
    var profileImage: String = ""
    var hashTag:[String] = [String]()
    var follower:[String] = [String]()
    var following:[String] = [String]()
    
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

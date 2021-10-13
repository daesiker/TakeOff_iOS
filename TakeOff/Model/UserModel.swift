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

class UserModel {
    let disposeBag = DisposeBag()
	    
    func doLogin(user:(email:String, password:String)) -> Observable< Event<User> > {
        return Observable<User>.create{ observer in
            Auth.auth().signIn(withEmail: user.email, password: user.password) { (result:AuthDataResult?, error:Error?) in
                if let user = result?.user {
                    self.saveUser(uid: user.uid)
                        .subscribe(observer)
                        .disposed(by: self.disposeBag)
                } else if let error = error {
                    observer.onError(error)
                } else {
                    let error = NSError(domain: "", code: 0, userInfo: nil)
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }.materialize()
    }
    
    func saveUser(uid:String) -> Observable<User> {
        return Observable<User>.create { observer in
            FirebaseDB.instance.getDB(path: "users/\(uid)")
                .subscribe { event in
                    switch event {
                    case .next(let value):
                        let dic = value as? [String:Any] ?? [:]
                        do {
                            let user = try User.initUser(uid: uid, dbInfo: dic)
                            User.loginedUser = user
                            observer.onNext(user)
                            observer.onCompleted() 
                        } catch  {
                            observer.onError(error)
                        }
                    case .error(let error):
                        observer.onError(error)
                    case .completed:
                        observer.onCompleted()
                    }
                }
                .disposed(by:self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    func refreshLoginedUser() -> Observable<User> {
        return Observable<User>.create { observer in
            self.saveUser(uid: User.loginedUser.uid)
                .subscribe(observer)
                .disposed(by: self.disposeBag)
            return Disposables.create()
        } 
    }
}

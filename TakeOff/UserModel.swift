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

struct User : Codable {
    var uid: String
    var email: String
    var name: String
    var type: Bool
    var profileImage: String
    var hashTag:[String]
    var follower:[String]
    var following:[String]
}

typealias re<T> = (info:T?, error:Error?)
class UserModel {
 
    let disposeBag = DisposeBag()
	    
    func doLogin(user:(email:String, password:String)) -> Observable<String> {
        return Observable<String>.create{ observer in
            Auth.auth().signIn(withEmail: user.email, password: user.password) { (result:AuthDataResult?, error:Error?) in                
                    let error = NSError(domain: "", code: 0, userInfo: nil)
                    observer.onError(error)
                
//                if let user = result?.user {
//                    self.saveUser(uid: user.uid).subscribe(observer).disposed(by: self.disposeBag)
//                } else if let error = error {
//                    observer.onError(error)
//                } else {
//                    let error = NSError(domain: "", code: 0, userInfo: nil)
//                    observer.onError(error)
//                }
            }
            return Disposables.create()
        }
    }
    
    private func saveUser(uid:String) -> Observable<String> {
        return Observable<String>.create { observer in
            FirebaseDB.instance.getDB(path: "users/\(uid)")
                .subscribe { event in
                    switch event {
                    case .next(let value):
                        let dic = value as? [String:Any] ?? [:]
                        do {
                            let JsonData = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
                            let user = try JSONDecoder().decode(User.self, from: JsonData)
                            print(user)
                            return observer.onNext("success")
                        } catch  {
                            return observer.onError(error)
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
}

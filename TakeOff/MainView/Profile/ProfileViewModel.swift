//
//  ProfileViewModel.swift
//  TakeOff
//
//  Created by mac on 2021/09/02.
//

import Foundation
import RxSwift
import RxCocoa
import Firebase

class ProfileViewModel {
    var input = Input()
    var output = Output()
    var disposeBag = DisposeBag()
    
    var posts = PublishRelay<[Post]>()
    
    struct Input {
        let refresh = PublishRelay<Void>()
        //        let tab:BehaviorRelay<String>
        //        let tab:PublishRelay<Void>
        //        let signUpTap:PublishRelay<Void>
        //        let autoLoginTap:PublishRelay<Void>
    } 
    
    struct Output {
        //        let loginIsEnabled:Driver<Bool>
        //        let goMain:Signal<User>
        //        var goSignUp:Signal<Void>
        let refreshEnd = PublishRelay<Void>()
        //        let error:Signal<Error>
        
    } 
    
    init() {
        
    }
    
    func fetchPosts() -> Observable<[Post]> {
        
        let user = Auth.auth().currentUser!
        
        return Observable.create { observe in
            
            Database.database().reference().child("posts").child(user.uid).observeSingleEvent(of: .value) { (snapshot) in
                var posts:[Post] = []
                if let userDictionary = snapshot.value as? [String:Any] {
                    for (key, value) in userDictionary {
                        let post = Post(key, dic: value as! [String : Any])
                        posts.append(post)
                    }
                    observe.onNext(posts)
                }
            }
            
            
            return Disposables.create()
        }
        
    }
    
}

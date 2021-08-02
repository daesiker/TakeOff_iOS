//
//  LoginViewModel.swift
//  TakeOff
//
//  Created by Jun on 2021/08/02.
//

import Foundation

import Foundation
import RxSwift
import RxRelay
import RxCocoa

protocol LoginViewBindable {
    var loginBtnTouched:PublishRelay<Void> { get }
}

class LoginViewModel {
    let emailObserver = BehaviorRelay<String>(value: "")
    let passwordObserver = BehaviorRelay<String>(value: "")
    
    func login(info: String) -> Observable<User> {
        
        return Observable.create({ (observer) -> Disposable in
            print("Firebase Login Function")
            observer.onNext(User(name: info))
            return Disposables.create()
        })
        
    }
    
    var isValid:Observable<Bool> {
        return Observable.combineLatest(emailObserver, passwordObserver)
            .map { email, password in
                return !email.isEmpty && email.contains(".") && email.contains("@") && password.count > 3
            }
    }
    
}

struct User {
    let name: String
}

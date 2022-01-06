//
//  LoginViewModel.swift
//  TakeOff
//
//  Created by Jun on 2021/08/02.
//

import Foundation

import Firebase
import RxSwift
import RxRelay
import RxCocoa

class LoginViewModel : ViewModelType {
    let userModel = User()
    
    let input =  Input()
    var output = Output()
    
    struct Input {
        let emailObserver = PublishRelay<String>()
        let pwObserver = PublishRelay<String>()
        let loginObserver = PublishRelay<String>()
    } 
    
    struct Output {
        var emailValid:Driver<Bool> = PublishRelay<Bool>().asDriver(onErrorJustReturn: false)
        var pwValid:Driver<Bool> = PublishRelay<Bool>().asDriver(onErrorJustReturn: false)
        var loginValid:Driver<Bool> = PublishRelay<Bool>().asDriver(onErrorJustReturn: false)
        var doLogin:PublishRelay<User> = PublishRelay<User>()
        var doError:PublishRelay<TakeOffError> = PublishRelay<TakeOffError>()
    } 
    
    var disposeBag: DisposeBag = DisposeBag()
    
    init() {
        
        output.emailValid = input.emailObserver
            .map { !$0.isEmpty && $0.contains(".") && $0.contains("@") }
            .asDriver(onErrorJustReturn: false)
        
        output.pwValid = input.pwObserver
            .map { $0.validPassword() }
            .asDriver(onErrorJustReturn: false)
        
        output.loginValid = Driver.combineLatest(output.emailValid, output.pwValid)
            .map { $0 && $1 }
            .asDriver(onErrorJustReturn: false)
        
        
        
    }
    
    func doLogin(_ email: String, pw: String) {
        
    }
    
    
}


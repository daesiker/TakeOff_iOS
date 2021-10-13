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
    let userModel = UserModel()
    
    var input: Input
    var output: Output
    
    struct Input {
        let emailText:BehaviorRelay<String>
        let passText:BehaviorRelay<String>
        let loginTap:PublishRelay<Void>
        let signUpTap:PublishRelay<Void>
        let autoLoginTap:PublishRelay<Void>
    } 
    
    struct Output {
        let loginIsEnabled:Driver<Bool>
        let goMain:Signal<User>
        var goSignUp:Signal<Void>
        let autoLogin:Signal<Void>
        let error:Signal<Error>
    } 
    
    var disposeBag: DisposeBag = DisposeBag()
    private func setInput() {}
    private func setOutput() {}
    init() {
        let mainRelay = PublishRelay<User>() 
        let signUpRelay = PublishRelay<Void>()
        let errorRelay = PublishRelay<Error>()
        
        self.input = Input(emailText: BehaviorRelay<String>(value: ""), 
                           passText: BehaviorRelay<String>(value: ""), 
                           loginTap: PublishRelay<Void>(), 
                           signUpTap: PublishRelay<Void>(),
                           autoLoginTap: PublishRelay<Void>())
        
        let isEnabled = Observable.combineLatest(input.emailText, input.passText)
            .map{$0.0.contains(".") && $0.0.contains("@") && $0.1.count > 3 }
            .asDriver(onErrorJustReturn: false)
        
        self.output = Output(loginIsEnabled: isEnabled, 
                             goMain: mainRelay.asSignal(), 
                             goSignUp: signUpRelay.asSignal(), 
                             autoLogin: input.autoLoginTap.asSignal(),
                             error: errorRelay.asSignal())
        
        input.loginTap.withLatestFrom(Observable.combineLatest(input.emailText, input.passText))
            .flatMapLatest(userModel.doLogin).bind(onNext: { (event:Event<User>) in
                switch event {
                case .next(let user):
                    mainRelay.accept(user)
                case .error(let error):
                    errorRelay.accept(error)
                default:
                    break
                }
            }).disposed(by: disposeBag)
        
        input.signUpTap.bind(to: signUpRelay).disposed(by: self.disposeBag)
    }
}


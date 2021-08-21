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
        let goMain:Signal<String>
        var goSignUp:Signal<Void>
        let autoLogin:Signal<Void>
        let error:Signal<Error>
    } 
    var mainRelay = PublishRelay<String>() 
    var signUpRelay = PublishRelay<Void>()
    var errorRelay = PublishRelay<Error>()
    var disposeBag: DisposeBag = DisposeBag()
    //    let d:Signal<String>
    private func setInput() {}
    private func setOutput() {}
    init() {
        mainRelay = PublishRelay<String>()
        signUpRelay = PublishRelay<Void>()
        errorRelay = PublishRelay<Error>()
        
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
            .flatMapLatest(userModel.doLogin).subscribe{ event in
                switch event {
                case .next(let str):
                    self.mainRelay.accept(str)
                case .error(let error):
                    self.errorRelay.accept(error)
                case .completed:
                    print("@#$")
                    
                }
            }.disposed(by: disposeBag)
        
        //            .asSignal(onErrorRecover: { (error:Error) -> Signal<String> in
        //                defer {
        //                	errorRelay.accept(error) // error signal 만들어서 에러는 해당 signal이 다 처리
        //                }
        ////                Completable
        //                return  BehaviorRelay(value:"").asSignal(onErrorJustReturn: "")
        //            })
        //            .asSignal(onErrorSignalWith: output.error).debug("signal")
        
        //            .asSignal(onErrorRecover: { (error:Error) -> Signal<String> in
        //                print(error) // 저번주에 말한 반환형을 튜플식으로 변경 ->
        //                return  BehaviorRelay(value:error.localizedDescription).asSignal(onErrorJustReturn: "")
        //            }).debug("Signal")
        //            .emit(to: mainRelay)
        //            .disposed(by: self.disposeBag)
        
        input.signUpTap.bind(to: signUpRelay).disposed(by: self.disposeBag)
        
        return Observable.create({ (observer) -> Disposable in
            print("Firebase Login Function")
            observer.onNext(User())
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


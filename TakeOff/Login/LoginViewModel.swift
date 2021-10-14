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
import GoogleSignIn

class LoginViewModel : ViewModelType {
    let userModel = UserModel()
    let signupViewModel = SignUpViewModel()
    
    var input: Input
    var output: Output
    
    struct Input {
        let emailText:BehaviorRelay<String>
        let passText:BehaviorRelay<String>
        let loginTap:PublishRelay<Void>
        let signUpTap:PublishRelay<Void>
        let googleSignUpTap:PublishRelay<UIViewController>
        let autoLoginTap:PublishRelay<Void>
    } 
    
    struct Output {
        let loginIsEnabled:Driver<Bool>
        let goMain:Signal<User>
        var goSignUp:Signal<Void>
        let autoLogin:Signal<Void>
        let apiSignUpRelay: Signal<Bool>
        let error:Signal<Error>
    } 
    
    var disposeBag: DisposeBag = DisposeBag()
    private func setInput() {}
    private func setOutput() {}
    init() {
        let mainRelay = PublishRelay<User>() 
        let signUpRelay = PublishRelay<Void>()
        let apiSignUpRelay = PublishRelay<Bool>()
        let errorRelay = PublishRelay<Error>()
        
        self.input = Input(emailText: BehaviorRelay<String>(value: ""), 
                           passText: BehaviorRelay<String>(value: ""), 
                           loginTap: PublishRelay<Void>(), 
                           signUpTap: PublishRelay<Void>(),
                           googleSignUpTap: PublishRelay<UIViewController>(),
                           autoLoginTap: PublishRelay<Void>())
        
        let isEnabled = Observable.combineLatest(input.emailText, input.passText)
            .map{$0.0.contains(".") && $0.0.contains("@") && $0.1.count > 3 }
            .asDriver(onErrorJustReturn: false)
        
        self.output = Output(loginIsEnabled: isEnabled, 
                             goMain: mainRelay.asSignal(), 
                             goSignUp: signUpRelay.asSignal(), 
                             autoLogin: input.autoLoginTap.asSignal(),
                             apiSignUpRelay: apiSignUpRelay.asSignal(),
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
        
        input.googleSignUpTap.flatMapLatest(doAPILogin(vc:))
            .subscribe { event in
                switch event {
                case .completed:
                    print("completed")
                case .next(let value):
                    apiSignUpRelay.accept(value)
                case .error(let error):
                    errorRelay.accept(error)
                }
            }
            .disposed(by: disposeBag)
        
        
    }
    
    
    
    
    func doAPILogin(vc: UIViewController) -> Observable<Bool> {
        return Observable.create { observer in
            
            let clientID = FirebaseApp.app()?.options.clientID ?? ""
            let signInConfig = GIDConfiguration.init(clientID: clientID)
            
            GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: vc) { user, error in
                if let error = error {
                    observer.onError(error)
                }
                
                guard let authentication = user?.authentication,
                      let idToken = authentication.idToken
                else { return }
                
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
                
                Auth.auth().signIn(with: credential) { result, error in
                    if let error = error {
                        observer.onError(error)
                    }
                    
                    if result != nil {
                        guard let uid = Auth.auth().currentUser?.uid else { return }
                        let ref = Database.database().reference().child("users").child(uid)
                        
                        ref.getData { error, snapshot in
                            if let error = error {
                                observer.onError(error)
                            } else if snapshot.exists() {
                                observer.onNext(true)
                            } else {
                                self.signupViewModel.user.uid = uid
                                observer.onNext(false)
                            }
                        }
                    }
                }
            }
            return Disposables.create()
        }
    }
}


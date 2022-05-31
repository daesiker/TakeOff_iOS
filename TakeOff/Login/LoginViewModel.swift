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
    var user = User()
    
    let input =  Input()
    var output = Output()
    
    struct Input {
        let emailObserver = PublishRelay<String>()
        let pwObserver = PublishRelay<String>()
        let loginObserver = PublishRelay<Void>()
    } 
    
    struct Output {
        var emailValid:Driver<Bool> = PublishRelay<Bool>().asDriver(onErrorJustReturn: false)
        var pwValid:Driver<Bool> = PublishRelay<Bool>().asDriver(onErrorJustReturn: false)
        var loginValid:Driver<Bool> = PublishRelay<Bool>().asDriver(onErrorJustReturn: false)
        var doLogin:PublishRelay<Void> = PublishRelay<Void>()
        var doError:PublishRelay<Error> = PublishRelay<Error>()
    } 
    
    var disposeBag: DisposeBag = DisposeBag()
    
    init() {
        
        input.emailObserver.subscribe(onNext: { value in
            self.user.email = value
        }).disposed(by: disposeBag)
        
        input.pwObserver.subscribe(onNext: { value in
            self.user.pw = value
        }).disposed(by: disposeBag)
        
        output.emailValid = input.emailObserver
            .map { !$0.isEmpty && $0.contains(".") && $0.contains("@") }
            .asDriver(onErrorJustReturn: false)
        
        output.pwValid = input.pwObserver
            .map { $0.validPassword() }
            .asDriver(onErrorJustReturn: false)
        
        output.loginValid = Driver.combineLatest(output.emailValid, output.pwValid)
            .map { $0 && $1 }
            .asDriver(onErrorJustReturn: false)
        
        input.loginObserver.flatMap(doLogin).subscribe( { event in
            
            switch event {
            case .next(()):
                self.output.doLogin.accept(())
            case .completed:
                break
            case .error(let error):
                self.output.doError.accept(error)
            }
            
        }).disposed(by: disposeBag)
        
    }
    
    func doLogin() -> Observable<Void> {
        return Observable<Void>.create{ observer in
            Auth.auth().signIn(withEmail: self.user.email, password: self.user.pw) { result, error in
                if let _ = result?.user {
                    
                    UserDefaults.standard.set(self.user.email, forKey: "email")
                    UserDefaults.standard.set(self.user.pw, forKey: "pw")
                    
                    Database.database().reference().child("users").observeSingleEvent(of: .value) { snapshot in
                        if let userDictionary = snapshot.value as? [String:Any] {
                            for (key, value) in userDictionary {
                                if let value = value as? [String:Any] {
                                    if value["email"] as! String == self.user.email {
                                        
                                        User.loginedUser = User(uid: key, dbInfo: value)
                                        observer.onNext(())
                                        break
                                    }
                                }
                            }
                        }
                    }
                    
                    
                    
                } else if let error = error {
                    observer.onError(error)
                } else {
                    let error = NSError(domain: "", code: 0, userInfo: nil)
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    
}


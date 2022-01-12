//
//  SignUpViewModel.swift
//  TakeOff
//
//  Created by Jun on 2021/08/02.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa
import Firebase

class SignUpViewModel {
    
    var user = User()
    let disposeBag = DisposeBag()
    let input = Input()
    var output = Output()
    
    enum EmailValid {
        case notAvailable
        case alreadyExsist
        case correct
        case serverError
    }
    
    
    struct Input {
        let emailObserver = PublishRelay<String>()
        let pwObserver = PublishRelay<String>()
        let pwConfirmObserver = PublishRelay<String>()
        let nameObserver = PublishRelay<String>()
        let typeObserver = PublishRelay<TypeValid>()
        let hasTagObserver = PublishRelay<String>()
    }
    
    struct Output {
        var emailValid = PublishRelay<EmailValid>()
        var pwValid = PublishRelay<Bool>()
        var pwConfirmValid = PublishRelay<Bool>()
        var nameValid = PublishRelay<Bool>()
        var typeValid = PublishRelay<TypeValid>()
        var hastagValid = PublishRelay<Bool>()
        var buttonValid = PublishRelay<Bool>().asDriver(onErrorJustReturn: false)
    }
    
    
    init() {
        
        input.emailObserver.subscribe(onNext: { value in
            self.user.email = value
        }).disposed(by: disposeBag)
        
        input.pwObserver.subscribe(onNext: { value in
            self.user.pw = value
        }).disposed(by: disposeBag)
        
        input.nameObserver.subscribe(onNext: { value in
            self.user.name = value
        }).disposed(by: disposeBag)
        
        input.typeObserver.subscribe(onNext: { value in
            switch value {
            case .artist:
                self.user.type = true
            case .person:
                self.user.type = false
            case .notSelected:
                break
            }
        }).disposed(by: disposeBag)
        
        input.hasTagObserver.subscribe(onNext: { value in
            if self.user.hashTag.contains(value) {
                if let index = self.user.hashTag.firstIndex(of: value) {
                    self.user.hashTag.remove(at: index)
                }
                
            } else {
                self.user.hashTag.append(value)
            }
            
            if self.user.hashTag.count != 0 {
                self.output.hastagValid.accept(true)
            } else {
                self.output.hastagValid.accept(false)
            }
            
            
        }).disposed(by: disposeBag)
        
        input.emailObserver.flatMap(firebaseEmailCheck)
            .subscribe({ event in
                switch event {
                case .next(let valid):
                    self.output.emailValid.accept(valid)
                default:
                    break
                }
            }).disposed(by: disposeBag)
        
        input.pwObserver.map { $0.validPassword() }
        .bind(to: self.output.pwValid )
        .disposed(by: disposeBag)
        
        input.pwConfirmObserver.map { $0 != "" && $0 == self.user.pw }
        .bind(to: self.output.pwConfirmValid)
        .disposed(by: disposeBag)
        
        input.nameObserver.flatMap(firebaseNameCheck)
            .subscribe({ event in
                switch event {
                case .next(let value):
                    self.output.nameValid.accept(value)
                default:
                    break
                }
            }).disposed(by: disposeBag)
        
        input.typeObserver
            .bind(to: self.output.typeValid)
            .disposed(by: disposeBag)
        
        
        
        output.buttonValid = Observable.combineLatest(output.emailValid, output.pwValid, output.pwConfirmValid, output.nameValid, output.typeValid, output.hastagValid)
            .map { $0 == .correct && $1 && $2 && $3 && $4 != .notSelected && $5 }
            .asDriver(onErrorJustReturn: false)
            
            
            
        
    }
    
    func firebaseEmailCheck(_ text: String) -> Observable<EmailValid> {
        return Observable.create { valid in
            if !(!text.isEmpty && text.contains(".") && text.contains("@")) {
                valid.onNext(.notAvailable)
                valid.onCompleted()
            } else {
                let ref = Database.database().reference().child("users")
                ref.observeSingleEvent(of: .value) { snapshot in
                    guard let dictionaries = snapshot.value as? [String: Any] else {  return valid.onNext(.serverError) } //Error 처리
                    
                    dictionaries.forEach { (key, value) in
                        guard let userDictionary = value as? [String:Any] else { return valid.onCompleted() }
                        guard let email = userDictionary["email"] as? String else {return valid.onCompleted() }
                        if email == text {
                            valid.onNext(.alreadyExsist)
                            valid.onCompleted()
                        }
                    }
                    valid.onNext(.correct)
                    valid.onCompleted()
                }
                
            }
            
            return Disposables.create()
        }
    }
    
    func firebaseNameCheck(_ text: String) -> Observable<Bool> {
        return Observable.create { valid in
            if text.isEmpty {
                valid.onCompleted()
            } else {
                let ref = Database.database().reference().child("users")
                ref.observeSingleEvent(of: .value) { snapshot in
                    guard let dictionaries = snapshot.value as? [String: Any] else {  return valid.onNext(true) } //Error 처리
                    
                    dictionaries.forEach { (key, value) in
                        guard let userDictionary = value as? [String:Any] else { return valid.onCompleted() }
                        guard let name = userDictionary["name"] as? String else {return valid.onCompleted() }
                        
                        if name == text {
                            valid.onNext(true)
                            valid.onCompleted()
                        }
                    }
                    valid.onNext(false)
                    valid.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
//    func createUser() -> Observable<Void> {
//
//        user.email = input.emailObserver.value
//        user.name = input.nameObserver.value
//
//        return Observable.create { result in
//            Auth.auth().createUser(withEmail: self.stepThree.input.emailObserver.value, password: self.stepThree.input.pwObserver.value) { (user, error: Error?) in
//                if let err = error {
//                    //Alert
//                    print("Failed to create user: ", err)
//                    result.onError(NSError(domain: "", code: 3, userInfo: nil))
//                    result.onCompleted()
//                }
//
//                guard let uid = user?.user.uid else { return result.onCompleted() }
//                let dictionaryValues = self.user.toDic()
//
//                let values = [uid: dictionaryValues]
//
//                Database.database().reference().child("users").updateChildValues(values) { err, ref in
//                    if let err = err {
//                        //Alert
//                        print("Failed to save user info into db", err)
//                        result.onError(NSError(domain: "", code: 3, userInfo: nil))
//                        result.onCompleted()
//                    }
//
//                    result.onNext(())
//                    result.onCompleted()
//                }
//
//            }
//            return Disposables.create()
//        }
//    }
    
    
    
}



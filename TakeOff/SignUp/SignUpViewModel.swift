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
        var emailValid = PublishRelay<EmailValid>().asDriver(onErrorJustReturn: .notAvailable)
        var pwValid = PublishRelay<Bool>().asDriver(onErrorJustReturn: false)
        var pwConfirmValid = PublishRelay<Bool>().asDriver(onErrorJustReturn: false)
        var nameValid = PublishRelay<Bool>().asDriver(onErrorJustReturn: false)
        var typeValid = PublishRelay<Bool>().asDriver(onErrorJustReturn: false)
        var hastagValid = PublishRelay<Bool>().asDriver(onErrorJustReturn: false)
        var buttonValid = PublishRelay<Bool>().asDriver(onErrorJustReturn: false)
    }
    
    
    init() {
        
        input.emailObserver.subscribe(onNext: { value in
            self.user.email = value
        }).disposed(by: disposeBag)
        
        output.emailValid = input.emailObserver.flatMap(self.firebaseEmailCheck).asDriver(onErrorJustReturn: .notAvailable)
        
        input.pwObserver.subscribe(onNext: { value in
            self.user.pw = value
        }).disposed(by: disposeBag)
        
        output.pwValid = input.pwObserver.map { $0.validPassword() }.asDriver(onErrorJustReturn: false)
        
        output.pwConfirmValid = input.pwConfirmObserver.map { $0 == self.user.pw && $0 != "" }.asDriver(onErrorJustReturn: false)
        
        input.nameObserver.subscribe(onNext: { value in
            self.user.name = value
        }).disposed(by: disposeBag)
        
        output.nameValid = input.nameObserver.flatMap(firebaseNameCheck).asDriver(onErrorJustReturn: false)
        
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
        
        output.typeValid = input.typeObserver.map { $0 != .notSelected }.asDriver(onErrorJustReturn: false)
        
        input.hasTagObserver.subscribe(onNext: { value in
            if self.user.hashTag.contains(value) {
                if let index = self.user.hashTag.firstIndex(of: value) {
                    self.user.hashTag.remove(at: index)
                }
                
            } else {
                self.user.hashTag.append(value)
            }
            
        }).disposed(by: disposeBag)
        
        output.hastagValid = input.hasTagObserver.map { _ in
            if self.user.hashTag.count == 0 {
                return false
            } else {
                return true
            }
        }.asDriver(onErrorJustReturn: false)
        
        
        output.buttonValid = Driver.combineLatest(output.emailValid, output.pwValid, output.pwConfirmValid, output.nameValid, output.typeValid, output.hastagValid)
            .map { $0 != .notAvailable && $1 && $2 && $3 && $4 && $5}
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
                    guard let dictionaries = snapshot.value as? [String: Any] else {  return valid.onNext(false) } //Error 처리
                    
                    dictionaries.forEach { (key, value) in
                        guard let userDictionary = value as? [String:Any] else { return valid.onCompleted() }
                        guard let name = userDictionary["name"] as? String else {return valid.onCompleted() }
                        
                        if name == text {
                            valid.onNext(false)
                            valid.onCompleted()
                        }
                    }
                    valid.onNext(true)
                    valid.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    func createUser() -> Observable<Void> {


        return Observable.create { result in
            Auth.auth().createUser(withEmail: self.user.email, password: self.user.pw) { user, error in
                if let error = error {
                    //Alert
                    result.onError(error)
                    result.onCompleted()
                }

                guard let uid = user?.user.uid else { return result.onCompleted() }
                let dictionaryValues = self.user.toDic()

                let values = [uid: dictionaryValues]

                Database.database().reference().child("users").updateChildValues(values) { error, ref in
                    if let error = error {
                        result.onError(error)
                        result.onCompleted()
                    }

                    result.onNext(())
                    result.onCompleted()
                }

            }
            return Disposables.create()
        }
    }
    
    
    
}



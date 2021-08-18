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
    
    private var user = User()
    let disposeBag = DisposeBag()
    let stepOne = StepOne()
    let stepTwo = StepTwo()
    var stepThree = StepThree()
    
    enum EmailValid {
        case notAvailable
        case alreadyExsist
        case correct
    }
    
    struct StepOne {
        let tap = PublishRelay<Bool>()
    }
    
    struct StepTwo {
        let radioClick = PublishRelay<String>()
        let buttonClick = PublishRelay<Void>()
    }
    
    struct StepThree {
        let emailObserver = BehaviorRelay<String>(value: "")
        let nameObserver = BehaviorRelay<String>(value: "")
        let pwObserver = BehaviorRelay<String>(value: "")
        let overlapPwObserver = BehaviorRelay<String>(value: "")
        
        //데이터만 보내면 되니까 굳이 Subject를 쓸필요 없음 Observable
        //asDriver : 스케줄러 관리
        //Driver랑 Signal사용
        let emailValid = BehaviorSubject<EmailValid>(value: .notAvailable)
        let nameValid = BehaviorSubject<Bool>(value: false)
        let pwValid = BehaviorSubject<Bool>(value: false)
        let overlapPwValid = BehaviorSubject<Bool>(value: false)
        var signupButtonValid:Observable<Bool> = Observable.of(false)
        
        
        let tapSignup = PublishSubject<Void>()
        let firebaseSignUp = PublishRelay<Void>()
    }
    
    
    init() {
        //MARK: Step 1
        stepOne.tap.subscribe(onNext: { type in
            self.user.type = type
        })
        .disposed(by: disposeBag)
        
        //MARK: Step 2
        stepTwo.radioClick.subscribe(onNext: { type in
            if self.user.hashTag.contains(type) {
                if let index = self.user.hashTag.firstIndex(of: type) {
                    self.user.hashTag.remove(at: index)
                }
            } else {
                self.user.hashTag.append(type)
            }
        })
        .disposed(by: disposeBag)
        
        stepTwo.buttonClick.subscribe().disposed(by: disposeBag)
        
        //MARK: Step3
        stepThree.emailObserver.flatMapLatest{ text in
            self.firebaseEmailCheck(text)
        }
        .bind(to: self.stepThree.emailValid)
        .disposed(by: disposeBag)
        
        stepThree.pwObserver
            .map { $0.count > 5}
            .bind(to: self.stepThree.pwValid)
            .disposed(by: disposeBag)
        
        stepThree.overlapPwObserver
            .map { $0 == self.stepThree.pwObserver.value }
            .bind(to: self.stepThree.overlapPwValid)
            .disposed(by: disposeBag)
        
        stepThree.nameObserver.flatMapLatest { name in
            self.firebaseNameCheck(name)
        }
        .bind(to: self.stepThree.nameValid)
        .disposed(by: disposeBag)
        
        
        
        stepThree.signupButtonValid = Observable.combineLatest(stepThree.emailValid, stepThree.nameValid, stepThree.pwValid, stepThree.overlapPwValid)
            .map { $0.0 == .correct && $0.1 && $0.2 && $0.3 }
            
            
//            .bind(to: self.stepThree.signupButtonValid)
//            .disposed(by: disposeBag)
        
        stepThree.tapSignup.flatMapLatest(self.createUser).subscribe { event in
            print("viewmodel next")
        } onError: { e in
            print(e)
        } onCompleted: {
            print("viewmodel completed")
        } onDisposed: {
            print("viewmodel disposed")
        }.disposed(by: disposeBag)
        
    }
    
    func firebaseEmailCheck(_ text: String) -> Observable<EmailValid> {
        return Observable.create { valid in
            if !(!text.isEmpty && text.contains(".") && text.contains("@")) {
                valid.onNext(.notAvailable)
                valid.onCompleted()
            } else {
                let ref = Database.database().reference().child("users")
                ref.observeSingleEvent(of: .value) { snapshot in
                    guard let dictionaries = snapshot.value as? [String: Any] else {  return valid.onCompleted() } //Error 처리
                    
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
                valid.onNext(false)
                valid.onCompleted()
            } else {
                let ref = Database.database().reference().child("users")
                ref.observeSingleEvent(of: .value) { snapshot in
                    guard let dictionaries = snapshot.value as? [String: Any] else {  return valid.onCompleted() } //Error 처리
                    
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
    
    func createUser() -> Observable<Void> {
        
        user.email = stepThree.emailObserver.value
        user.name = stepThree.nameObserver.value
        
        return Observable.create { result in
            Auth.auth().createUser(withEmail: self.stepThree.emailObserver.value, password: self.stepThree.pwObserver.value) { (user, error: Error?) in
                if let err = error {
                    //Alert
                    print("Failed to create user: ", err)
                    result.onError(NSError(domain: "", code: 3, userInfo: nil))
                    result.onCompleted()
                }
                
                guard let uid = user?.user.uid else { return result.onCompleted() }
                let dictionaryValues = self.user.toDic()
                
                let values = [uid: dictionaryValues]
                
                Database.database().reference().child("users").updateChildValues(values) { err, ref in
                    if let err = err {
                        //Alert
                        print("Failed to save user info into db", err)
                        result.onError(NSError(domain: "", code: 3, userInfo: nil))
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



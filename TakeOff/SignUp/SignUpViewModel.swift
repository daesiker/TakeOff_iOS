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
    let stepThree = StepThree()
    
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
        
        let emailValid = BehaviorSubject<Bool>(value: false)
        let nameValid = BehaviorSubject<Bool>(value: false)
        let pwValid = BehaviorSubject<Bool>(value: false)
        let overlapPwValid = BehaviorSubject<Bool>(value: false)
        let signupButtonValid = BehaviorSubject<Bool>(value: false)
        
        
        let firebaseSignUp = PublishRelay<Void>()
    }
    
    
    init() {
        stepOne.tap.subscribe(onNext: { type in
            self.user.type = type
        })
        .disposed(by: disposeBag)
        
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
        
        stepThree.emailObserver
            .map { $0.count > 0 && $0.contains("@") && $0.contains(".")}
            .bind(to: self.stepThree.emailValid)
            .disposed(by: disposeBag)
        
        stepThree.pwObserver
            .map { $0.count > 5}
            .bind(to: self.stepThree.pwValid)
            .disposed(by: disposeBag)
        
        stepThree.nameObserver
            .map {self.firebaseEmailCheck($0, isEmail: false)}
            .bind(to: self.stepThree.nameValid)
            .disposed(by: disposeBag)
        
        stepThree.overlapPwObserver
            .map { $0 == self.stepThree.pwObserver.value }
            .bind(to: self.stepThree.overlapPwValid)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(stepThree.emailValid, stepThree.nameValid, stepThree.pwValid, stepThree.overlapPwValid)
            .map { $0.0 && $0.1 && $0.2 && $0.3 }
            .bind(to: self.stepThree.signupButtonValid)
            .disposed(by: disposeBag)
        
    }
    
    func firebaseEmailCheck(_ text: String, isEmail: Bool = true) -> Bool {
        
        if text.isEmpty  { return false }
        
        let ref = Database.database().reference().child("users")
        var result = false
        ref.observeSingleEvent(of: .value) { snapshot in
            
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            dictionaries.forEach { (key, value) in
                guard let userDictionary = value as? [String: Any] else { return }
                guard let name = userDictionary["name"] as? String else { return }
                print(name)
                if name == text {
                    result = true
                    
                }
            }
        }
        return result
    }
    
    
}



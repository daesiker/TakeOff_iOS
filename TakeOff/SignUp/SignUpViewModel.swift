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
import FirebaseDatabase

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
        
        
        
    }
}

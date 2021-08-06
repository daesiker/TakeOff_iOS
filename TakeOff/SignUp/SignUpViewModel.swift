//
//  SignUpViewModel.swift
//  TakeOff
//
//  Created by Jun on 2021/08/02.
//

import Foundation
import RxSwift
import RxRelay
import Firebase
import FirebaseDatabase

class SignUpViewModel {
    
    private var user = User()
    let disposeBag = DisposeBag()
    let stapOne = StapOne()
    let stapTwo = StapTwo()
    let stapThree = StapThree()
    
    struct StapOne {
        let tap = PublishRelay<Bool>()
    }
    
    struct StapTwo {
        let radioClick = PublishRelay<String>()
        let buttonClick = PublishRelay<Void>()
    }
    
    struct StapThree {
        let firebaseSignUp = PublishRelay<Void>()
    }
    
    
    init() {
        stapOne.tap.subscribe(onNext: { type in
            self.user.type = type
            print(self.user.type)
        })
        .disposed(by: disposeBag)
        
        stapTwo.radioClick.subscribe(onNext: { type in
            if self.user.hashTag.contains(type) {
                if let index = self.user.hashTag.firstIndex(of: type) {
                    self.user.hashTag.remove(at: index)
                }
            } else {
                self.user.hashTag.append(type)
            }
            print(self.user.hashTag)
        })
        .disposed(by: disposeBag)
        
        
    }
}

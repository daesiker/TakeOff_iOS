//
//  SignUpViewModel.swift
//  TakeOff
//
//  Created by Jun on 2021/08/02.
//

import Foundation
import RxSwift
import RxRelay


protocol SignUpViewModelType {
    var tap: PublishRelay<Void> { get }
}



class SignUpViewModel: SignUpViewModelType {
    
    private let user = BehaviorRelay<User>(value: .init())
    let disposeBag = DisposeBag()
    
    let tap = PublishRelay<Void>()
    
    init() {
        self.tap
            .withLatestFrom(user)
            .map { user -> User in
                var nextUser = user
                nextUser.type = true
                return nextUser
            }.bind(to: self.user)
            .disposed(by: disposeBag)
    }
}

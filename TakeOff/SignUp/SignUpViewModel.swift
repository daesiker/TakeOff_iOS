//
//  SignUpViewModel.swift
//  TakeOff
//
//  Created by Jun on 2021/08/02.
//

import Foundation
import RxSwift
import RxRelay


class SignUpViewModel {
    
    private var user = User()
    let disposeBag = DisposeBag()
    let stapOne = StapOne()
    let stapTwo = StapTwo()
    
    struct StapOne {
        let tap = PublishRelay<Int>()
    }
    
    struct StapTwo {
        
    }
    
    
    
    init() {
        stapOne.tap.subscribe(onNext: { a in
            self.user.type = a == 1 ? true : false
        })
        .disposed(by: disposeBag)
        
        
        
    }
}

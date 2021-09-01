//
//  SharePhotoViewModel.swift
//  TakeOff
//
//  Created by Jun on 2021/09/01.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

class SharePhotoViewModel {
    
    let input = Input()
    let output = Output()
    
    struct Input {
        let textObserver = BehaviorRelay<String>(value: "")
        let imageObserver = BehaviorRelay<UIImage>(value: UIImage(named: "")!)
        let buttonObserver = PublishRelay<Void>()
    }
    
    struct Output {
        var shareDB:Signal<Void> = PublishRelay<Void>().asSignal()
        var error:Signal<Error> = PublishRelay<Error>().asSignal()
    }
    
    
    
    
}

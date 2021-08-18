//
//  Protocol.swift
//  TakeOff
//
//  Created by mac on 2021/08/04.
//

import Foundation
import RxSwift
import RxCocoa

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    var disposeBag: DisposeBag { get set }
    
    var input: Input { get }
    var output: Output { get }
    

}

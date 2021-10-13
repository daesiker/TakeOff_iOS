//
//  ProfileViewModel.swift
//  TakeOff
//
//  Created by mac on 2021/09/02.
//

import Foundation
import RxSwift
import RxCocoa

class ProfileViewModel: ViewModelType {
    var input: Input
    var output: Output
    var disposeBag: DisposeBag
    let um = UserModel()
    struct Input {
        let refresh:PublishRelay<Void>
        //        let tab:BehaviorRelay<String>
        //        let tab:PublishRelay<Void>
        //        let signUpTap:PublishRelay<Void>
        //        let autoLoginTap:PublishRelay<Void>
    } 
    
    struct Output {
        //        let loginIsEnabled:Driver<Bool>
        //        let goMain:Signal<User>
        //        var goSignUp:Signal<Void>
        let refreshEnd:Signal<User>
        //        let error:Signal<Error>
        
    } 
    
    init() {
        self.disposeBag = DisposeBag()
        let refreshRealy = PublishRelay<User>()
        self.input = Input(refresh: PublishRelay<Void>())
        
        self.output = Output(refreshEnd: refreshRealy.asSignal())
        
        input.refresh.flatMapFirst { self.um.refreshLoginedUser()}
            .asSignal(onErrorJustReturn: User.loginedUser)
            .emit(to: refreshRealy)
            .disposed(by: disposeBag)
    }
    
}

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
        let dismiss = PublishRelay<Void>()
    }
    
    struct StepTwo {
        let radioClick = PublishRelay<String>()
        let confirmClick = PublishRelay<Void>()
        let dismissClick = PublishRelay<Void>()
    }
    
    struct StepThree {
        
        struct Input {
            let emailObserver = BehaviorRelay<String>(value: "")
            let nameObserver = BehaviorRelay<String>(value: "")
            let pwObserver = BehaviorRelay<String>(value: "")
            let overlapPwObserver = BehaviorRelay<String>(value: "")
            let signUpTap = PublishRelay<Void>()
        }
        
        struct Output {
            var emailValid:Driver<EmailValid> = PublishRelay<EmailValid>().asDriver(onErrorJustReturn: .notAvailable)
            var nameValid:Driver<Bool> = PublishRelay<Bool>().asDriver(onErrorJustReturn: false)
            var pwValid:Driver<Bool> = PublishRelay<Bool>().asDriver(onErrorJustReturn: false)
            var overlapPwValid:Driver<Bool> = PublishRelay<Bool>().asDriver(onErrorJustReturn: false)
            var signupButtonValid:Driver<Bool> = PublishRelay<Bool>().asDriver(onErrorJustReturn: false)
            var goSignUp:Signal<Void> = PublishRelay<Void>().asSignal()
            var error:Signal<Error> = PublishRelay<Error>().asSignal()
        }
        let input = Input()
        var output = Output()
        
        let tapSignup = PublishSubject<Void>()
        let firebaseSignUp = PublishRelay<Void>()
    }
    
    
    init() {
        //MARK: Step 1
        stepOne.tap.subscribe(onNext: { type in
            self.user.type = type
        })
        .disposed(by: disposeBag)
        
        stepOne.dismiss.subscribe().disposed(by: disposeBag)
        
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
        
        stepTwo.confirmClick.subscribe().disposed(by: disposeBag)
        stepTwo.dismissClick.subscribe().disposed(by: disposeBag)
        
        
        //MARK: Step3
        stepThree.tapSignup.flatMapLatest(self.createUser).subscribe { event in
            print("viewmodel next")
        } onError: { e in
            print(e)
        } onCompleted: {
            print("viewmodel completed")
        } onDisposed: {
            print("viewmodel disposed")
        }.disposed(by: disposeBag)
        
        stepThree.output.emailValid = stepThree.input.emailObserver
            .flatMap(self.firebaseEmailCheck)
            .asDriver(onErrorJustReturn: .notAvailable)
        stepThree.output.nameValid = stepThree.input.nameObserver
            .flatMap(self.firebaseNameCheck)
            .asDriver(onErrorJustReturn: false)
        stepThree.output.pwValid = stepThree.input.pwObserver
            .map { $0.count > 5 }
            .asDriver(onErrorJustReturn: false)
        stepThree.output.overlapPwValid = stepThree.input.overlapPwObserver
            .map { $0 == self.stepThree.input.pwObserver.value && $0.count > 5 }
            .asDriver(onErrorJustReturn: false)
        stepThree.output.signupButtonValid = Driver.combineLatest(stepThree.output.emailValid, stepThree.output.nameValid, stepThree.output.pwValid, stepThree.output.overlapPwValid)
            .map {$0.0 == .correct && $0.1 && $0.2 && $0.3 }
            .asDriver(onErrorJustReturn: false)
        
        let errorRelay = PublishRelay<Error>()
        let signUpRelay = PublishRelay<Void>()
        stepThree.input.signUpTap.flatMapLatest(self.createUser).subscribe { event in
            switch event {
            case .completed:
                print("completed")
            case .next(_):
                print("next")
            case .error(let error):
                errorRelay.accept(error)
            }
        }
        .disposed(by: disposeBag)
        
        stepThree.input.signUpTap.bind(to: signUpRelay).disposed(by: disposeBag)
        stepThree.output.goSignUp = signUpRelay.asSignal()
        stepThree.output.error = errorRelay.asSignal()
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
        
        user.email = stepThree.input.emailObserver.value
        user.name = stepThree.input.nameObserver.value
        
        return Observable.create { result in
            Auth.auth().createUser(withEmail: self.stepThree.input.emailObserver.value, password: self.stepThree.input.pwObserver.value) { (user, error: Error?) in
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



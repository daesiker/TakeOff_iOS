//
//  AddCalendarViewModel.swift
//  TakeOff
//
//  Created by Jun on 2022/06/08.
//

import Foundation
import RxSwift
import RxCocoa
import Firebase

class AddCalendarViewModel {
    
    let disposeBag = DisposeBag()
    let input = Input()
    var output = Output()
    var calendar = CalendarPost()
    
    struct Input {
        let locationObserver = PublishRelay<String>()
        let titleObserver = PublishRelay<String>()
        let dateObserver = PublishRelay<Double>()
        let postObserver = PublishRelay<Void>()
        
    }
    
    struct Output {
        var errorValid = PublishRelay<Error>()
        var addPost = PublishRelay<Void>()
    }
    
    init() {
        
        input.locationObserver.subscribe(onNext: { value in
            self.calendar.location = value
        }).disposed(by: disposeBag)
        
        input.titleObserver.subscribe(onNext: { value in
            self.calendar.title = value
        }).disposed(by: disposeBag)
        
        input.dateObserver.subscribe(onNext: { value in
            self.calendar.date = value
        }).disposed(by: disposeBag)
        
        input.postObserver.flatMap(handleShare).subscribe({ event in
            switch event {
            case .next(_):
                self.output.addPost.accept(())
            case .completed:
                break
            case .error(let error):
                self.output.errorValid.accept(error)
            }
            
            
        }).disposed(by: disposeBag)
        
    }
    
    func handleShare() -> Observable<Void>{
        
        Observable<Void>.create { valid in
            
            if self.calendar.title == "" {
                let error = NSError.init(domain: "제목을 입력해주세요", code: 104)
                valid.onError(error)
            } else if self.calendar.location == "" {
                let error = NSError.init(domain: "내용을 작성해주세요.", code: 105)
                valid.onError(error)
            } else {
                self.calendar.userName = User.loginedUser.name
            
                let ref = Database.database().reference().child("calendars").childByAutoId()
                let values = self.calendar.toDic()
                ref.updateChildValues(values) { (err, ref) in
                    if let err = err {
                        valid.onError(err)
                        return
                    }
                    
                    valid.onNext(())
                }
            }
            return Disposables.create()
        }
        
    }
    
    
}

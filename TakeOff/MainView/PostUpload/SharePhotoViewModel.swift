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
import Firebase

class SharePhotoViewModel {
    
    var input = Input()
    var output = Output()
    let disposeBag = DisposeBag()
    
    struct Input {
        let textObserver = BehaviorRelay<String>(value: "")
        var imageObserver = BehaviorRelay<[UIImage]>(value : [])
        let buttonObserver = PublishRelay<Void>()
    }
    
    struct Output {
        var shareDB:Signal<Void> = PublishSubject<Void>().asSignal(onErrorJustReturn: print("error"))
        var error:Signal<Error> = PublishRelay<Error>().asSignal()
        
    }
    
    init() {
        
        let shareRelay = PublishRelay<Void>()
        input.buttonObserver.flatMap(handleShare).subscribe { event in
            switch event {
            case .completed:
                print("complete")
            case .next(_):
                print("next")
            case .error(let error):
                print(error)
            }
        }
        .disposed(by: disposeBag)
        
        input.buttonObserver.bind(to: shareRelay).disposed(by: disposeBag)
        self.output.shareDB = shareRelay.asSignal()
    }
    
    
    func handleShare() -> Observable<[String]>{
        
        Observable<[String]>.create { valid in
            var imageURLs:[String] = []
            for i in 0..<self.input.imageObserver.value.count {
                let fileName = NSUUID().uuidString
                let storageRef = Storage.storage().reference().child("posts").child(fileName)
                let uploadData = self.input.imageObserver.value[i].jpegData(compressionQuality: 0.5) ?? Data()
                
                storageRef.putData(uploadData, metadata: nil) { (metadata, err) in
                    if let err = err {
                        valid.onError(err)
                    }
                    storageRef.downloadURL(completion: { downloadURL, err in
                        if let err = err {
                            valid.onError(err)
                        }
                        let imageUrl = downloadURL?.absoluteString ?? ""
                        imageURLs.append(imageUrl)
                        if i == self.input.imageObserver.value.count - 1 {
                            guard let uid = Auth.auth().currentUser?.uid else { print("유저 없음"); return }
                            let userPostRef = Database.database().reference().child("posts").child(uid)
                            let ref = userPostRef.childByAutoId()
                            
                            let values:[String:Any] = ["imageUrl": imageURLs,
                                                       "contents": self.input.textObserver.value,
                                                       "likes": [],
                                                       "creationDate": Date().timeIntervalSince1970]
                            
                            ref.updateChildValues(values) { (err, ref) in
                                if let err = err {
                                    print(err)
                                    return
                                }
                                valid.onCompleted()
                            }
                        }
                    })
                }
            }
            return Disposables.create()
        }
        
    }
    
    
}

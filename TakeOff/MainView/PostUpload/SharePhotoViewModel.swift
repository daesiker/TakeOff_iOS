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
    
    var post:Post = Post()
    
    struct Input {
        let textObserver = BehaviorRelay<String>(value: "")
        let hashtagObserver = PublishRelay<[String]>()
        let buttonObserver = PublishRelay<[UIImage]>()
    }
    
    struct Output {
        var shareDB:Signal<Void> = PublishSubject<Void>().asSignal(onErrorJustReturn: print("error"))
        var error:Signal<Error> = PublishRelay<Error>().asSignal()
        
    }
    
    init() {
        
        input.hashtagObserver.subscribe(onNext: { value in
            self.post.hashTag = value
        }).disposed(by: disposeBag)
        
        input.textObserver.subscribe(onNext: { value in
            self.post.contents = value
        }).disposed(by: disposeBag)
        
        
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
        
    }
    
    
    func handleShare(images:[UIImage]) -> Observable<[String]>{
        
        Observable<[String]>.create { valid in
            
            for i in 0..<images.count {
                let fileName = NSUUID().uuidString
                let storageRef = Storage.storage().reference().child("posts").child(fileName)
                let uploadData = images[i].jpegData(compressionQuality: 0.5) ?? Data()
                
                storageRef.putData(uploadData, metadata: nil) { (metadata, err) in
                    if let err = err {
                        valid.onError(err)
                    }
                    storageRef.downloadURL(completion: { downloadURL, err in
                        if let err = err {
                            valid.onError(err)
                        }
                        let imageUrl = downloadURL?.absoluteString ?? ""
                        self.post.images.append(imageUrl)
                        if i == images.count - 1 {
                            guard let uid = Auth.auth().currentUser?.uid else { print("유저 없음"); return }
                            let userPostRef = Database.database().reference().child("posts").child(uid)
                            let ref = userPostRef.childByAutoId()
                            
                            self.post.date = Date().timeIntervalSince1970
                            
                            let values = self.post.toDic()
                            
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

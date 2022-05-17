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
        var shareDB = PublishRelay<Void>()
        var error = PublishRelay<Error>()
        
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
                self.output.shareDB.accept(())
            case .error(let error):
                self.output.error.accept(error)
            }
        }
        .disposed(by: disposeBag)
        
    }
    
    
    func handleShare(images:[UIImage]) -> Observable<Void>{
        
        Observable<Void>.create { valid in
            
            if self.post.hashTag.count == 0 {
                let error = NSError.init(domain: "한 개 이상의 해시테그를 추가해주세요.", code: 104)
                valid.onError(error)
            } else if self.post.contents == "" {
                let error = NSError.init(domain: "내용을 작성해주세요.", code: 105)
                valid.onError(error)
            } else {
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
                            self.post.user = User.loginedUser.name
                            if i == images.count - 1 {
                                guard let uid = Auth.auth().currentUser?.uid else { print("유저 없음"); return }
                                let userPostRef = Database.database().reference().child("posts").child(uid)
                                let ref = userPostRef.childByAutoId()
                                
                                self.post.date = Date()
                                
                                let values = self.post.toDic()
                                
                                ref.updateChildValues(values) { (err, ref) in
                                    if let err = err {
                                        valid.onError(err)
                                        return
                                    }
                                    valid.onNext(())
                                    valid.onCompleted()
                                }
                            }
                        })
                    }
                }
            }
            return Disposables.create()
        }
        
    }
    
    
}

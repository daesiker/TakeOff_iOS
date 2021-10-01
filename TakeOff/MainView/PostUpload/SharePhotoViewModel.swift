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
        var shareDB:Signal<Void> = PublishRelay<Void>().asSignal()
        var error:Signal<Error> = PublishRelay<Error>().asSignal()
    }
    
    init() {
        let shareRelay = PublishRelay<Void>()
        
        input.buttonObserver.flatMapLatest(handleShare).subscribe { event in
            var imageURLS:[String] = []
            switch event {
            case .completed:
                self.handleShare(imageURLs: imageURLS)
            case .next(let imageURL):
                imageURLS.append(imageURL)
            case .error(let error):
                print(error)
            }
        }.disposed(by: disposeBag)
        
        input.buttonObserver.bind(to: shareRelay).disposed(by: disposeBag)
        output.shareDB = shareRelay.asSignal()
    }
    
    
    func handleShare() -> Observable<String>{
        
        Observable<String>.create { valid in
            for image in self.input.imageObserver.value {
                let fileName = NSUUID().uuidString
                let storageRef = Storage.storage().reference().child("posts").child(fileName)
                let uploadData = image.jpegData(compressionQuality: 0.5) ?? Data()
                
                storageRef.putData(uploadData, metadata: nil) { (metadata, err) in
                    if let err = err {
                        valid.onError(err)
                    }
                    
                    storageRef.downloadURL(completion: { downloadURL, err in
                        if let err = err {
                            valid.onError(err)
                        }
                        let imageUrl = downloadURL?.absoluteString ?? ""
                        valid.onNext(imageUrl)
                    })
                }
            }
            valid.onCompleted()
            return Disposables.create()
        }
        
    }
    
    func handleShare(imageURLs: [String]) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userPostRef = Database.database().reference().child("posts").child(uid)
        let ref = userPostRef.childByAutoId()
        
        let values:[String:Any] = ["imageUrl": imageURLs,
                                   "contents": input.textObserver.value,
                                   "likes": 0,
                                   "creationDate": Date().timeIntervalSince1970]
        
        ref.updateChildValues(values) { (err, ref) in
            if let err = err {
                print(err) //에러처리
                return
            }
            print("성공")
        }
        
        
    }
    
//    fileprivate func saveToDatabaseWithImageUrl(imageUrl: String) {
//        //guard let postImage = selectedImage else { return }
//        guard let caption = textView.text else { return }
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//
//        let userPostRef = Database.database().reference().child("posts").child(uid)
//        let ref = userPostRef.childByAutoId()
//
//        let values:[String:Any] = ["imageUrl": imageUrl,
//                                   "caption": caption,
//                                   "creationDate": Date().timeIntervalSince1970 ]
//        ref.updateChildValues(values) { (err, ref) in
//            if let err = err {
//                self.navigationItem.rightBarButtonItem?.isEnabled = true
//                print("Failed to save post to DB", err)
//                return
//            }
//
//            //self.dismiss(animated: true, completion: nil)
//
//        }
//
//    }

    
    
    
}

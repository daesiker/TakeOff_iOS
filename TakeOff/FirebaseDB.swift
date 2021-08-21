//
//  FirebaseDB.swift
//  TakeOff
//
//  Created by Jun on 2021/08/21.
//

import Foundation

import Firebase
import RxSwift
//import Rx

class FirebaseDB {
    static let instance = FirebaseDB()
    private init () {}
    
    private let ref = Database.database().reference()
    private let disposeBag = DisposeBag()
    
    func getDB(path:String) -> Observable<Any> {
        return Observable<Any>.create { observer -> Disposable in
            self.ref.child(path).getData { (error:Error?, snapshot:DataSnapshot) in
                if let value = snapshot.value {
                    observer.onNext(value)
                }
                else if let error = error {
                    observer.onError(error)
                }
                else {
                    let error = NSError(domain: "", code: 3232, userInfo: [NSLocalizedDescriptionKey:"unkown error"])
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    
}

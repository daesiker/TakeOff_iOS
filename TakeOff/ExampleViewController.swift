//
//  ExampleViewController.swift
//  TakeOff
//
//  Created by Jun on 2021/09/13.
//

import UIKit
import Then
import RxSwift

class ExampleViewController: UIViewController {

    let textView = UITextView().then {
        $0.text = "Safe Area"
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 20)
        $0.backgroundColor = .clear
        $0.textAlignment = .center
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let disposeBag = DisposeBag()

        enum MyError: Error {
           case error
        }
        //기본값 : 4
        let b = BehaviorSubject<Int>(value: 4)

        //이벤트 생성 : 10
        b.onNext(10)

        //이벤트 방출
        b.subscribe {
            print("BehaviorSubject >> ", $0)
        }
        .disposed(by: disposeBag)
        
        //이벤트 생성 : 100
        b.onNext(100)

        b.subscribe {
            print("BehaviorSubject222 >> ", $0)
        }
        .disposed(by: disposeBag)

        //b.onCompleted()
        b.onError(MyError.error)

        b.subscribe {
            print("BehaviorSubject333> ", $0)
        }
        .disposed(by: disposeBag)
        
        //BehaviorSubject >>  next(10)
        //BehaviorSubject >>  next(100)
        //BehaviorSubject222 >>  next(100)
        //BehaviorSubject >>  error(error)
        //BehaviorSubject222 >>  error(error)
        //BehaviorSubject333>  error(error)
        
        view.backgroundColor = .red
        safeView.backgroundColor = .blue // 처음 부른 시점에 safeView가 생성된다.
        safeView.addSubview(textView)
        textView.snp.makeConstraints {
            $0.width.equalTo(200)
            $0.height.equalTo(40)
            $0.centerX.centerY.equalToSuperview()
        }
        
        
        
    }
}

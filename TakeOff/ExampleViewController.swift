//
//  ExampleViewController.swift
//  TakeOff
//
//  Created by Jun on 2021/09/13.
//

import UIKit
import Then
import RxSwift
import RxCocoa

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
        
        let bag = DisposeBag()

        let publishRelay = PublishRelay<Int>()


        publishRelay.accept(3)

        publishRelay.subscribe {
            print("1 : ", $0)
        }
        .disposed(by: bag)


        publishRelay.accept(3)

        let behaviorRelay = BehaviorRelay<Int>(value: 4)

        behaviorRelay.subscribe {
            print("2 : ", $0)
        }
        .disposed(by: bag)

        behaviorRelay.accept(5)

        print(behaviorRelay.value)
        
        //1 :  next(3)
        //2 :  next(4)
        //2 :  next(5)
        //5
        
        
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

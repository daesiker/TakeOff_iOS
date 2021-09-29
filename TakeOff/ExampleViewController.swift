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
        
        let bag = DisposeBag()



        let o1 = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe {
                print($0)
            }


        DispatchQueue.main
            .asyncAfter(deadline: .now() + 5) {
                o1.dispose()
            }


        
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

//
//  SignUp2View.swift
//  TakeOff
//
//  Created by Jun on 2021/08/02.
//

import UIKit
import Then
import RxSwift
import RxCocoa

class SignUp2View: UIViewController {
    
    let vm: SignUpViewModel
    var disposeBag = DisposeBag()
    
    let backgroundView = UIImageView(image: UIImage(named: "background"))
    let titleLayout = UIView()
    let stackLayout = UIView()
    
    let titleLabel = UILabel().then {
        $0.text = "관심사를 선택해주세요."
        $0.textColor = UIColor.black
        $0.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    let radioButton1 = UIButton(type: .system).then {
        $0.setTitle("선택1", for: .normal)
        $0.setTitleColor(UIColor.mainColor, for: .normal)
        $0.snp.makeConstraints {
            $0.width.equalTo(100)
        }
    }
    
    let radioButton2 = UIButton(type: .system).then {
        $0.setTitle("선택2", for: .normal)
        $0.setTitleColor(UIColor.mainColor, for: .normal)
    }
    
    let radioButton3 = UIButton(type: .system).then {
        $0.setTitle("선택3", for: .normal)
        $0.setTitleColor(UIColor.mainColor, for: .normal)
    }
    
    let radioButton4 = UIButton(type: .system).then {
        $0.setTitle("선택4", for: .normal)
        $0.setTitleColor(UIColor.mainColor, for: .normal)
        $0.snp.makeConstraints {
            $0.width.equalTo(100)
        }
    }
    
    let radioButton5 = UIButton(type: .system).then {
        $0.setTitle("선택5", for: .normal)
        $0.setTitleColor(UIColor.mainColor, for: .normal)
    }
    
    let radioButton6 = UIButton(type: .system).then {
        $0.setTitle("선택6", for: .normal)
        $0.setTitleColor(UIColor.mainColor, for: .normal)
        $0.snp.makeConstraints {
            $0.width.equalTo(100)
        }
    }
    
    let radioButton7 = UIButton(type: .system).then {
        $0.setTitle("선택7", for: .normal)
        $0.setTitleColor(UIColor.mainColor, for: .normal)
    }
    
    let radioButton8 = UIButton(type: .system).then {
        $0.setTitle("선택8", for: .normal)
        $0.setTitleColor(UIColor.mainColor, for: .normal)
    }
    
    let radioButton9 = UIButton(type: .system).then {
        $0.setTitle("선택9", for: .normal)
        $0.setTitleColor(UIColor.mainColor, for: .normal)
        $0.snp.makeConstraints {
            $0.width.equalTo(100)
        }
    }
    
    let radioButton10 = UIButton(type: .system).then {
        $0.setTitle("선택10", for: .normal)
        $0.setTitleColor(UIColor.mainColor, for: .normal)
    }
    
    let confirmButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.backgroundColor = UIColor.enableMainColor
        $0.layer.cornerRadius = 5.0
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        $0.setTitleColor(.white, for: .normal)
    }
    
    
    init(vm: SignUpViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bind()
    }
    


}

extension SignUp2View: SignUpViewAttributes {
    
    func setUI() {
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.safeView.addSubview(titleLayout)
        titleLayout.snp.makeConstraints {
            $0.top.equalTo(safeView.snp.top).offset(10)
            $0.left.right.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.1)
        }
        
        titleLayout.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(titleLayout.snp.height).multipliedBy(0.5)
            $0.centerX.equalTo(titleLayout.snp.centerX)
            $0.centerY.equalTo(titleLayout.snp.centerY)
        }
        
        self.safeView.addSubview(stackLayout)
        stackLayout.snp.makeConstraints {
            $0.top.equalTo(titleLayout.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
            
        }
        setStackView()
        
    }
    
    func setStackView() {
        let hStackView1 = UIStackView(arrangedSubviews: [radioButton1, radioButton2, radioButton3]).then {
            $0.alignment = .center
            $0.axis = .horizontal
            $0.spacing = 15
            $0.distribution = .fillEqually
        }
        
        let hStackView2 = UIStackView(arrangedSubviews: [radioButton4, radioButton5]).then {
            $0.alignment = .center
            $0.axis = .horizontal
            $0.spacing = 15
            $0.distribution = .fillEqually
        }
        
        let hStackView3 = UIStackView(arrangedSubviews: [radioButton6, radioButton7, radioButton8]).then {
            $0.alignment = .center
            $0.axis = .horizontal
            $0.spacing = 15
            $0.distribution = .fillEqually
        }
        
        let hStackView4 = UIStackView(arrangedSubviews: [radioButton9, radioButton10]).then {
            $0.alignment = .center
            $0.axis = .horizontal
            $0.spacing = 15
            $0.distribution = .fillEqually
        }
        
        let mainStackView = UIStackView(arrangedSubviews: [hStackView1, hStackView2, hStackView3, hStackView4]).then {
            $0.alignment = .center
            $0.axis = .vertical
            $0.spacing = 15
            $0.distribution = .equalCentering
            
        }
        
        stackLayout.addSubview(mainStackView)
        mainStackView.snp.makeConstraints {
            $0.centerX.equalTo(stackLayout.snp.centerX)
            $0.centerY.equalTo(stackLayout.snp.centerY)
            $0.width.equalTo(stackLayout.snp.width)
            $0.height.equalTo(stackLayout.snp.height).multipliedBy(0.8)
        }
        
        stackLayout.addSubview(confirmButton)
        confirmButton.snp.makeConstraints {
            $0.top.equalTo(mainStackView.snp.bottom).offset(5)
            
        }
        
    }
    
    func bind() {
        Observable.merge(
            radioButton1.rx.tap.map { "선택1" },
            radioButton2.rx.tap.map { "선택2" },
            radioButton3.rx.tap.map { "선택3" },
            radioButton4.rx.tap.map { "선택4" },
            radioButton5.rx.tap.map { "선택5" },
            radioButton6.rx.tap.map { "선택6" },
            radioButton7.rx.tap.map { "선택7" },
            radioButton8.rx.tap.map { "선택8" },
            radioButton9.rx.tap.map { "선택9" },
            radioButton10.rx.tap.map { "선택10" }
        )
        .bind(to: vm.stepTwo.radioClick)
        .disposed(by: disposeBag)
        
        confirmButton.rx.tap
            .bind(to: vm.stepTwo.buttonClick)
            .disposed(by: disposeBag)
        
        vm.stepTwo.buttonClick.bind { _ in
            self.changeScreen()
        }
        .disposed(by: disposeBag)
        
    }
    
    private func changeScreen() {
        let vc = SignUp3View(vm: vm)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
}

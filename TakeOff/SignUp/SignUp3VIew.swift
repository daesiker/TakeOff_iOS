//
//  SignUp3.swift
//  TakeOff
//
//  Created by Jun on 2021/08/09.
//

import UIKit
import Then
import RxSwift
import RxCocoa
import TextFieldEffects

class SignUp3View: UIViewController {
    
    let vm: SignUpViewModel
    var disposeBag = DisposeBag()
    
    let backgroundView = UIImageView(image: UIImage(named: "background"))
    let fieldLayoutView = UIView()
    
    let emailTextField = HoshiTextField().then {
        $0.placeholder = "email을 입력하세요"
        $0.placeholderColor = UIColor.mainColor
        $0.borderActiveColor = UIColor.mainColor
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .black
    }
    
    let emailCheckButton = UIButton(type: .system).then {
        $0.setTitle("중복확인", for: .normal)
        $0.backgroundColor = UIColor.mainColor
        $0.layer.cornerRadius = 5.0
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        $0.setTitleColor(.white, for: .normal)
    }
    
    let nameTextField = HoshiTextField().then {
        $0.placeholder = "이름을 입력하세요"
        $0.placeholderColor = UIColor.mainColor
        $0.borderActiveColor = UIColor.mainColor
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .black
        
        $0.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.width.equalTo(200)
        }
    }
    
    let pwTextField = HoshiTextField().then {
        $0.placeholder = "비밀번호를 입력하세요"
        $0.placeholderColor = UIColor.mainColor
        $0.borderActiveColor = UIColor.mainColor
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .black
        $0.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.width.equalTo(200)
        }
    }
    
    let pwConfirmTextField = HoshiTextField().then {
        $0.placeholder = "비밀번호 확인"
        $0.placeholderColor = UIColor.mainColor
        $0.borderActiveColor = UIColor.mainColor
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .black
        $0.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.width.equalTo(200)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    init(vm: SignUpViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension SignUp3View: SignUpViewAttributes {
    
    func setUI() {
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(fieldLayoutView)
        fieldLayoutView.snp.makeConstraints {
            $0.centerX.equalTo(self.safeView.snp.centerX)
            $0.centerY.equalTo(self.safeView.snp.centerY)
            $0.top.left.equalTo(self.safeView).offset(20)
            $0.right.bottom.equalTo(self.safeView).offset(-20)
        }
        
        makeInfoStack()
        
    }
    
    func makeInfoStack() {
        
        let emailStack = UIStackView(arrangedSubviews: [emailTextField, emailCheckButton]).then {
            $0.axis = .horizontal
        }
        emailTextField.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.width.equalTo(200)
            $0.leading.equalTo(emailStack)
        }
        
        emailCheckButton.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.width.equalTo(80)
            $0.trailing.equalTo(emailStack)
        }
        
        
        
        let fieldStack = UIStackView(arrangedSubviews: [emailStack, nameTextField, pwTextField, pwConfirmTextField]).then {
            $0.axis = .vertical
            $0.spacing = 15
            $0.distribution = .fillEqually
        }
        
        fieldLayoutView.addSubview(fieldStack)
        fieldStack.snp.makeConstraints {
            $0.top.left.right.equalTo(fieldLayoutView)
        }
        
        
    }
    
    
}

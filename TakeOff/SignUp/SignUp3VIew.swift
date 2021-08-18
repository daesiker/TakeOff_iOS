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
        $0.placeholder = "Email"
        $0.placeholderColor = UIColor.mainColor
        $0.placeholderFontScale = 1.0
        $0.borderActiveColor = UIColor.mainColor
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textColor = .black
    }
    
    let emailConfirmImage = UIImageView(image: UIImage(named: "check")).then {
        $0.backgroundColor = .clear
    }
    
    let emailConfirmLabel = UILabel().then {
        $0.text = "올바른 형식으로 입력하세요."
        $0.textColor = UIColor.black
        $0.font = UIFont.boldSystemFont(ofSize: 10)
    }
    
    let nameTextField = HoshiTextField().then {
        $0.placeholder = "Nickname"
        $0.placeholderColor = UIColor.mainColor
        $0.placeholderFontScale = 1.0
        $0.borderActiveColor = UIColor.mainColor
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textColor = .black
    }
    
    let nameConfirmImage = UIImageView(image: UIImage(named: "check")).then {
        $0.backgroundColor = .clear
    }
    
    let nameConfirmLabel = UILabel().then {
        $0.text = "올바른 형식으로 입력하세요."
        $0.textColor = UIColor.black
        $0.font = UIFont.boldSystemFont(ofSize: 10)
    }
    
    
    let pwTextField = HoshiTextField().then {
        $0.placeholder = "비밀번호를 입력하세요"
        $0.placeholderFontScale = 1.0
        $0.isSecureTextEntry = true
        $0.placeholderColor = UIColor.mainColor
        $0.borderActiveColor = UIColor.mainColor
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textColor = .black
       
    }
    
    let pwConfirmImage = UIImageView(image: UIImage(named: "check")).then {
        $0.backgroundColor = .clear
    }
    
    let pwConfirmLabel = UILabel().then {
        $0.text = "올바른 형식으로 입력하세요."
        $0.textColor = UIColor.black
        $0.font = UIFont.boldSystemFont(ofSize: 10)
    }
    
    let overlapPwTextField = HoshiTextField().then {
        $0.placeholder = "비밀번호 확인"
        $0.placeholderFontScale = 1.0
        $0.isSecureTextEntry = true
        $0.placeholderColor = UIColor.mainColor
        $0.borderActiveColor = UIColor.mainColor
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textColor = .black
    }
    
    let overlapPwConfirmImage = UIImageView(image: UIImage(named: "check")).then {
        $0.backgroundColor = .clear
    }
    
    let overlapPwConfirmLabel = UILabel().then {
        $0.text = "올바른 형식으로 입력하세요."
        $0.textColor = UIColor.black
        $0.font = UIFont.boldSystemFont(ofSize: 10)
    }
    
    let signUpButton = UIButton(type: .system).then {
        $0.setTitle("Sign Up", for: .normal)
        $0.backgroundColor = $0.isEnabled ? UIColor.mainColor : UIColor.enableMainColor
        $0.layer.cornerRadius = 5.0
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        $0.setTitleColor(.white, for: .normal)
        $0.isEnabled = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bindInput()
        bindOutput()
    }
    
    init(vm: SignUpViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension SignUp3View: SignUpViewAttributes {
    
    func setUI() {
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        safeView.addSubview(fieldLayoutView)
        fieldLayoutView.snp.makeConstraints {
            $0.centerX.equalTo(self.safeView.snp.centerX)
            $0.centerY.equalTo(self.safeView.snp.centerY)
            $0.top.left.equalTo(self.safeView).offset(20)
            $0.right.bottom.equalTo(self.safeView).offset(-20)
        }
        
        makeInfoStack()
        
    }
    
    func makeInfoStack() {
        
        let emailField = makeStackView(textfield: emailTextField, image: emailConfirmImage, label: emailConfirmLabel)
        let nameField = makeStackView(textfield: nameTextField, image: nameConfirmImage, label: nameConfirmLabel)
        let pwField = makeStackView(textfield: pwTextField, image: pwConfirmImage, label: pwConfirmLabel)
        let overlapField = makeStackView(textfield: overlapPwTextField, image: overlapPwConfirmImage, label: overlapPwConfirmLabel)
        
        let fieldStack = UIStackView(arrangedSubviews: [emailField, nameField, pwField, overlapField]).then {
            $0.axis = .vertical
            $0.spacing = 15
            $0.distribution = .fillEqually
        }
        
        fieldLayoutView.addSubview(fieldStack)
        fieldStack.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(0.7)
            $0.top.leading.trailing.equalToSuperview()
        }
        
        fieldLayoutView.addSubview(signUpButton)
        signUpButton.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.bottom.leading.trailing.equalToSuperview()
        }
        
        
    }
    
    func makeStackView(textfield: UITextField, image: UIImageView, label: UILabel) -> UIView {
        
        let view = UIView()
        
        view.addSubview(textfield)
        view.addSubview(image)
        view.addSubview(label)
        
        textfield.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
            $0.height.equalTo(50)
            $0.width.equalToSuperview().multipliedBy(0.8)
        }
        
        image.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.leading.equalTo(textfield.snp.trailing).offset(15)
            $0.width.height.equalTo(15)
        }
        
        label.snp.makeConstraints {
            $0.top.equalTo(textfield.snp.bottom).offset(5)
            $0.leading.equalToSuperview()
            $0.height.equalTo(10)
        }
        
        return view
    }
    
    
    func bindInput() {
        
        emailTextField.rx.controlEvent([.editingDidEnd])
            .map { self.emailTextField.text ?? "" }
            .bind(to: vm.stepThree.emailObserver)
            .disposed(by: disposeBag)
        
        nameTextField.rx.controlEvent([.editingDidEnd])
            .map { self.nameTextField.text ?? "" }
            .bind(to: vm.stepThree.nameObserver)
            .disposed(by: disposeBag)
        
        pwTextField.rx.text.orEmpty
            .bind(to: vm.stepThree.pwObserver)
            .disposed(by: disposeBag)
        
        overlapPwTextField.rx.text.orEmpty
            .bind(to: vm.stepThree.overlapPwObserver)
            .disposed(by: disposeBag)
        
        emailTextField.rx.controlEvent([.editingDidEnd])
            .asObservable()
            .subscribe(onNext: {
                print("end")
            }).disposed(by: disposeBag)
        
        signUpButton.rx.tap
            .bind(to: vm.stepThree.tapSignup)
            .disposed(by: disposeBag)
    }
    
    func bindOutput() {
        vm.stepThree.emailValid.subscribe(onNext: { valid in
            switch valid {
            case .notAvailable:
                self.emailConfirmLabel.text = "올바르지 않은 형식입니다."
                self.emailConfirmLabel.textColor = .red
            case .alreadyExsist:
                self.emailConfirmLabel.text = "이미 존재하는 아이디입니다."
                self.emailConfirmLabel.textColor = .red
            case .correct:
                self.emailConfirmLabel.text = "사용가능한 아이디입니다."
                self.emailConfirmLabel.textColor = UIColor.mainColor
            }
        })
        .disposed(by: disposeBag)
        
        vm.stepThree.nameValid.subscribe(onNext: { valid in
            if valid {
                self.nameConfirmLabel.text = "이미 존재하는 아이디입니다."
                self.nameConfirmLabel.textColor = .red
            } else {
                self.nameConfirmLabel.text = "사용가능한 아이디입니다."
                self.nameConfirmLabel.textColor = UIColor.mainColor
            }
        })
        .disposed(by: disposeBag)
        
        vm.stepThree.pwValid.subscribe(onNext: {valid in
            if valid {
                self.pwConfirmLabel.text = "올바른 형식의 비밀번호입니다."
                self.pwConfirmLabel.textColor = UIColor.mainColor
            } else {
                self.pwConfirmLabel.text = "비밀번호는 6자리이상이어야 합니다."
                self.pwConfirmLabel.textColor = .red
            }
        })
        .disposed(by: disposeBag)
        
        vm.stepThree.overlapPwValid.subscribe(onNext: { valid in
            if valid {
                self.overlapPwConfirmLabel.text = "비밀번호가 일치합니다."
                self.overlapPwConfirmLabel.textColor = UIColor.mainColor
            } else {
                self.overlapPwConfirmLabel.text = "비밀번호가 일치하지 않습니다."
                self.overlapPwConfirmLabel.textColor = .red
            }
        })
        .disposed(by: disposeBag)
        
        vm.stepThree.signupButtonValid.bind(to: self.signUpButton.rx.isEnabled)
            .disposed(by: disposeBag)
        //(onNext: { valid in
//
//
//
////            if valid {
////                //self.signUpButton.rx.isEnabled = false
////                self.signUpButton.backgroundColor = UIColor.mainColor
////            } else {
////                self.signUpButton.isEnabled = true
////                self.signUpButton.backgroundColor = UIColor.enableMainColor
////            }
//        })
//        .disposed(by: disposeBag)
        
        vm.stepThree.firebaseSignUp.subscribe { result in
            switch result {
            case .completed:
                print("completed")
            case .error(let error):
                print(error)
            case .next(_):
                print("next")
            }
        }.disposed(by: disposeBag)
        
    }
    
    
}

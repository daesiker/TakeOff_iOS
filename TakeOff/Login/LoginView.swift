//
//  HomeViewController.swift
//  TakeOff
//
//  Created by Jun on 2021/07/17.
//

import UIKit

import Firebase
import TextFieldEffects
import SnapKit
import Then
//import RxCocoa
import RxSwift

class LoginView: UIViewController {
    let vm = LoginViewModel()
    var handle: AuthStateDidChangeListenerHandle!
    
    // Layout View
    let logoLayout = UIView()
    let scrollView = UIScrollView().then {
        $0.alwaysBounceVertical = false
        $0.showsVerticalScrollIndicator = false   
    }
    let contentLayout = UIView()
    
    
    // Image View
    let backgroundView = UIImageView(image: UIImage(named: "background"))
    let logoImageView = UIImageView(image: UIImage(named: "logo"))
    
    let emailTextField = HoshiTextField().then {
        $0.placeholder = "Email"
        $0.placeholderColor = UIColor.mainColor
        $0.borderActiveColor = UIColor.mainColor
        $0.borderInactiveColor = UIColor.gray
        $0.textColor = .black        
        $0.text = "test@test.com"
    } 
    
    let passwordTextField = HoshiTextField().then {
        $0.placeholder = "Password"
        $0.isSecureTextEntry = true
        $0.placeholderColor = UIColor.mainColor
        $0.borderActiveColor = UIColor.mainColor
        $0.borderInactiveColor = UIColor.gray
        $0.textColor = .black   
        $0.text = "111111"
    }
    
    let loginButton = UIButton().then {
        $0.setTitle("Login", for: .normal)
        $0.layer.cornerRadius = 5.0
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        $0.setTitleColor(.white, for: .normal)
        $0.setBackgroundColor(UIColor.enableMainColor, for: .disabled)
        $0.setBackgroundColor(UIColor.mainColor, for: .normal)
        $0.isEnabled = true
    }
    
    let signupButton = UIButton(type: .system).then {
        let signUpText = "Don't have an account? Sign Up"
        // defalut font attribute
        let defaultAttr = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: UIFont.smallSystemFontSize), NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        // "Sign Up" font attribute
        let addAttr = [NSAttributedString.Key.font:  UIFont.boldSystemFont(ofSize: UIFont.systemFontSize), NSAttributedString.Key.foregroundColor: UIColor.mainColor]
        let attributedTitle = NSMutableAttributedString(string: signUpText, attributes: defaultAttr)
        
        let changeRange = (signUpText as NSString).range(of: "Sign Up")
        attributedTitle.addAttributes(addAttr, range: changeRange)
        $0.setAttributedTitle(attributedTitle, for: .normal)   
    }
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()    
        bind()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        self.vm.output.autoLogin.emit { _ in
//                        self.goToSignUp()
//            print("autologin")
        }.disposed(by: disposeBag)
        
        
        self.handle = Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
//                self.vm.input.autoLoginTap.accept(())
                // The user's ID, unique to the Firebase project.
                // Do NOT use this value to authenticate with your backend server,
                // if you have one. Use getTokenWithCompletion:completion: instead.
                let uid = user.uid
                let email = user.email
                let photoURL = user.photoURL
                var multiFactorString = "MultiFactor: "
                for info in user.multiFactor.enrolledFactors {
                    multiFactorString += info.displayName ?? "[DispayName]"
                    multiFactorString += " "
                }
                //                print("state change", uid, email, photoURL , multiFactorString)
                // ...
            }            
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(self.handle!)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    private func goToMain(s:String) {
        print("go main \(s)")
        
    }
    private func goToSignUp() {
        let viewController = SignUp1View()
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .fullScreen
        //        self.navigationController?.pushViewController(viewController, animated: true)
        self.present(viewController, animated: true)    
    }
    // MARK:- bind
    private func bind() {
        // bind intput
        self.emailTextField.rx.text.orEmpty
            .bind(to: vm.input.emailText)
            .disposed(by: disposeBag)
        self.passwordTextField.rx.text.orEmpty
            .bind(to: vm.input.passText)
            .disposed(by: disposeBag)
        self.loginButton.rx.tap
            .bind(to: vm.input.loginTap)
            .disposed(by: disposeBag)
        self.signupButton.rx.tap
            .bind(to: vm.input.signUpTap)
            .disposed(by: disposeBag)
        
        // bind output
        self.vm.output.loginIsEnabled
            .drive(loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        self.vm.output.goMain
            .emit(onNext: goToMain)
            .disposed(by: disposeBag)
        
        self.vm.output.goSignUp //튜플식 변경시 guard 문으로 체킹 해줘야함
            .emit(onNext: goToSignUp)
            .disposed(by: disposeBag)
//            
        self.vm.output.error.debug("aa").emit { e in // 에러 signal로 받으면 따로 체킹 필요없음 
            print("error  \(e)")
        }.disposed(by: disposeBag)
    }
    // MARK:- Set UI
    private func setUI() {
        self.setLayout()
        
        // Set Logo
        logoLayout.addSubview(logoImageView)          
        logoImageView.snp.makeConstraints {
            $0.height.equalTo(150)
            $0.height.width.lessThanOrEqualToSuperview()
            $0.width.equalTo(logoImageView.snp.height)
            $0.center.equalToSuperview()
        }
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField]).then {
            $0.axis = .vertical
            $0.spacing = 15
            $0.distribution = .fillEqually
            $0.alignment = .leading
        }
        self.setInputFields(stackView)
        
        // Set LoginButton
        contentLayout.addSubview(loginButton)
        loginButton.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).inset(-30)
            $0.left.right.equalToSuperview()
            $0.height.greaterThanOrEqualTo(50)
        }
        
        self.setSignUp()   
    }
    private func setLayout() {
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.safeView.addSubview(logoLayout)
        self.safeView.addSubview(scrollView)
        scrollView.addSubview(contentLayout)
        
        logoLayout.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.3)
        }
        scrollView.snp.makeConstraints {
            $0.top.equalTo(logoLayout.snp.bottom).inset(-30)
            $0.left.right.bottom.equalToSuperview()
        }
        contentLayout.snp.makeConstraints {
            $0.width.edges.equalToSuperview()   
        }
    }
    private func setInputFields(_ stackView:UIStackView) {
        contentLayout.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        stackView.arrangedSubviews.forEach{ 
            $0.snp.makeConstraints{
                $0.left.right.equalToSuperview()
                $0.height.greaterThanOrEqualTo(50)   
            }
        }
    }
    private func setSignUp() {
        let otherSignUpView = UIStackView().then{ $0.backgroundColor = UIColor.black}
        contentLayout.addSubview(otherSignUpView)
        otherSignUpView.snp.makeConstraints{
            $0.top.equalTo(loginButton.snp.bottom).inset(-20)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(700)   
        }
        
        contentLayout.addSubview(signupButton)
        signupButton.snp.makeConstraints {
            $0.top.equalTo(otherSignUpView.snp.bottom).inset(-50)
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
    }
}

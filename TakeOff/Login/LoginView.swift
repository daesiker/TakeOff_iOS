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
import NaverThirdPartyLogin
import RxSwift
import Alamofire
import GoogleSignIn


class LoginView: UIViewController {
    
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    let loginViewModel = LoginViewModel()
    let signupViewModel = SignUpViewModel()
    var handle: AuthStateDidChangeListenerHandle!
    
    // Layout View
    let backgroundView = UIImageView(image: UIImage(named: "background"))
    let logoLayout = UIView().then {
        $0.backgroundColor = .red
    }
    let scrollView = UIScrollView().then {
        $0.alwaysBounceVertical = false
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .blue
    }
    let contentLayout = UIView()
    
    let naverLoginBt = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "naverLogin"), for: .normal)
        $0.addTarget(self, action: #selector(naverLogin), for: .touchUpInside)
        
    }
    
    @objc private func naverLogin(_ sender: UIButton) {
        loginInstance?.delegate = self
        loginInstance?.requestThirdPartyLogin()
    }
    
    let googleLoginBt = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "naverLogin"), for: .normal)
        
    }
    
    // Component View
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
    
    let errorTextField = UILabel().then {
    	$0.lineBreakMode = .byWordWrapping
        $0.numberOfLines = 3
     	$0.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        $0.textColor = UIColor.mainColor      
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
        navigationController?.isNavigationBarHidden = true
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
    
    private func goToMain(user:User) {
        let viewController = MainTabViewController()
        let navController = UINavigationController(rootViewController: viewController)
        navController.isNavigationBarHidden = true
        navController.modalTransitionStyle = .crossDissolve
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true)
    }
    private func goToSignUp() {
        let viewController = SignUp1View(vm: signupViewModel)
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK:- bind
    private func bind() {
        // bind intput
        self.emailTextField.rx.text.orEmpty
            .bind(to: loginViewModel.input.emailText)
            .disposed(by: disposeBag)
        self.passwordTextField.rx.text.orEmpty
            .bind(to: loginViewModel.input.passText)
            .disposed(by: disposeBag)
        self.loginButton.rx.tap
            .bind(to: loginViewModel.input.loginTap)
            .disposed(by: disposeBag)
        self.signupButton.rx.tap
            .bind(to: loginViewModel.input.signUpTap)
            .disposed(by: disposeBag)
        self.googleLoginBt.rx.tap
            .map { self }
            .bind(to: loginViewModel.input.googleSignUpTap)
            .disposed(by: disposeBag)
        
        
        // bind output
        self.loginViewModel.output.loginIsEnabled
            .drive(loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        self.loginViewModel.output.goMain
            .emit(onNext: goToMain)
            .disposed(by: disposeBag)
        
        self.loginViewModel.output.goSignUp //튜플식 변경시 guard 문으로 체킹 해줘야함
            .emit(onNext: goToSignUp)
            .disposed(by: disposeBag)

        self.loginViewModel.output.apiSignUpRelay
            .emit(onNext: isSigned)
            .disposed(by: disposeBag)
        
        self.loginViewModel.output.error
            .emit {
                self.errorTextField.text = $0.localizedDescription
                self.passwordTextField.text = ""
                self.loginButton.isEnabled = false
            } 
            .disposed(by: disposeBag)
        
        
    }
    // MARK:- Set UI
    private func setUI() {
        setLayout()
         //Set Logo
        logoLayout.addSubview(logoImageView)
        logoImageView.snp.makeConstraints {
            $0.height.equalTo(150)
            $0.height.width.lessThanOrEqualToSuperview()
            $0.width.equalTo(logoImageView.snp.height)
            $0.center.equalToSuperview()
        }
        
        // Set login TextField Stack
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
        
        contentLayout.addSubview(errorTextField)
        errorTextField.snp.makeConstraints {
        	$0.top.equalTo(loginButton.snp.bottom).inset(-10)
            $0.left.right.equalToSuperview()
               
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
        contentLayout.addSubview(signupButton)
        signupButton.snp.makeConstraints {
            $0.top.equalTo(errorTextField.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.greaterThanOrEqualTo(50)   
        }
        
        
        contentLayout.addSubview(naverLoginBt)
        naverLoginBt.snp.makeConstraints {
            $0.top.equalTo(signupButton.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.05)
        }
        
        contentLayout.addSubview(googleLoginBt)
        googleLoginBt.snp.makeConstraints {
            $0.top.equalTo(naverLoginBt.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.05)
        }
        
//        let otherSignUpView = UIStackView(arrangedSubviews: [naverLoginBt]).then{
//            $0.backgroundColor = UIColor.clear
//            $0.axis = .vertical
//            $0.spacing = 15
//            $0.distribution = .fillEqually
//            $0.alignment = .leading
//        }
//        contentLayout.addSubview(naverLoginBt)
//        naverLoginBt.snp.makeConstraints{
//            $0.top.equalTo(signupButton.snp.bottom)
//            $0.bottom.left.right.equalToSuperview()
//            $0.height.equalTo(700)
//        }
    }
    
}

extension LoginView: NaverThirdPartyLoginConnectionDelegate {
    
    private func getNaverInfo() {
        guard let isValidAccessToken = loginInstance?.isValidAccessTokenExpireTimeNow() else { return }
        
        if !isValidAccessToken { return }
        
        guard let tokenType = loginInstance?.tokenType else { return }
        guard let accessToken = loginInstance?.accessToken else { return }
        let urlStr = "https://openapi.naver.com/v1/nid/me"
        guard let url = URL(string: urlStr) else { return }
        let authorization = "\(tokenType) \(accessToken)"
        
        
        let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
        let signVm = SignUpViewModel()
        req.responseJSON { response in
            guard let result = response.value as? [String: Any] else { return }
            guard let object = result["response"] as? [String: Any] else { return }
            
            guard let email = object["email"] as? String else { return }
            
            signVm.user.email = email
            signVm.user.uid = authorization
            
            
            
            
        }.resume()
        //jwt
        //firebase custom -> jwt
        
        let viewController = SignUp1View(vm: signVm)
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    //로그인에 성공했을 경우 호출
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("[Success] : Success Naver Login")
        getNaverInfo()
    }
    
    //접속 토큰 갱신
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        
    }
    
    //로그아웃 할 경우 호출(토큰 삭제)
    func oauth20ConnectionDidFinishDeleteToken() {
        loginInstance?.requestDeleteToken()
    }
    
    //Error 처리
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("[Error] :", error.localizedDescription)
    }
    
}

extension LoginView {
    
    
    
    func isSigned(value: Bool) {
        if value {
            
        } else {
            let viewController = SignUp1View(vm: loginViewModel.signupViewModel)
            viewController.modalTransitionStyle = .crossDissolve
            viewController.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    
}

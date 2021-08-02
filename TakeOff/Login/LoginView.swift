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

class LoginView: UIViewController {
    
    let backgroundView: UIView = {
        let view = UIImageView(image: UIImage(named: "background"))
        return view
    }()
    
    let logoImageView: UIView = {
        let view = UIImageView(image: UIImage(named: "logo"))
        return view
    }()
    
    let emailTextField: HoshiTextField = {
        let tf = HoshiTextField()
        tf.placeholder = "Email"
        tf.placeholderColor = UIColor.mainColor
        tf.borderActiveColor = UIColor.mainColor
        tf.textColor = .black
        return tf
    }()
    
    let passwordTextField: HoshiTextField = {
        let tf = HoshiTextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.placeholderColor = UIColor.mainColor
        tf.borderActiveColor = UIColor.mainColor
        tf.textColor = .black
        return tf
    }()
    
    let loginButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("Login", for: .normal)
        bt.backgroundColor = UIColor.enableMainColor
        bt.layer.cornerRadius = 5.0
        bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        bt.setTitleColor(.white, for: .normal)
        bt.isEnabled = false
        return bt
    }()
    
    let signupButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account? ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.mainColor]))
        
        button.setTitle("Don't have an account? Sign Up.", for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    @objc func handleShowSignUp() {
        let viewController = SignUpView()
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints {
            $0.height.equalTo(100)
            $0.width.equalTo(100)
            $0.top.equalToSuperview().offset(50)
            $0.centerX.equalToSuperview()
        }
        
        setupInputFields()
        
        view.addSubview(signupButton)
        signupButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().offset(-20)
            $0.leading.trailing.equalToSuperview()
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    fileprivate func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.height.equalTo(180)
            $0.top.equalTo(logoImageView.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(40)
            $0.trailing.equalToSuperview().offset(-40)
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

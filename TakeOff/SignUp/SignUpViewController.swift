//
//  DefaultSignUpViewController.swift
//  TakeOff
//
//  Created by Jun on 2022/01/06.
//

import UIKit
import RxSwift
import RxCocoa
import AVFAudio

class SignUpViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    let scrollView:UIScrollView = {
        let sv = UIScrollView()
        sv.showsHorizontalScrollIndicator = false
        sv.showsVerticalScrollIndicator = false
        sv.backgroundColor = .clear
        return sv
    }()
    
    let backgroundView = UIImageView(image: UIImage(named: "background"))
    
    let backBt = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "btBack"), for: .normal)
    }
    
    let welcomeLabel = UILabel().then {
        $0.text = "환영합니다!"
        $0.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 15)
        $0.textColor = UIColor.rgb(red: 101, green: 101, blue: 101)
    }
    
    let titleLabel = UILabel().then {
        $0.attributedText = NSAttributedString(string: "한페이지로\n끝내는 회원가입").withLineSpacing(6)
        $0.font = UIFont(name: "GodoM", size: 26)
        $0.textColor = UIColor.rgb(red: 101, green: 101, blue: 101)
        $0.numberOfLines = 2
    }
    
    let emailLabel = UILabel().then {
        $0.text = "이메일"
        $0.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 14)
        $0.textColor = UIColor.rgb(red: 100, green: 98, blue: 94)
    }
    
    let emailTextField = CustomTextField(image: UIImage(named: "tfEmail")!, text: "이메일 주소 입력").then {
        $0.backgroundColor = UIColor.rgb(red: 243, green: 243, blue: 243)
        $0.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
    }
    
    let emailAlert = UILabel().then {
        $0.text = ""
        $0.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 11)
        $0.textColor = UIColor.rgb(red: 255, green: 108, blue: 0)
    }
    
    let pwLabel = UILabel().then {
        $0.text = "비밀번호"
        $0.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 14)
        $0.textColor = UIColor.rgb(red: 100, green: 98, blue: 94)
    }
    
    let pwTextField = CustomTextField(image: UIImage(named: "tfPassword")!, text: "영문자와 숫자 포함 8자 이상 입력").then {
        $0.backgroundColor = UIColor.rgb(red: 243, green: 243, blue: 243)
        $0.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
        $0.isSecureTextEntry = true
    }
    
    let pwAlert = UILabel().then {
        $0.text = ""
        $0.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 11)
        $0.textColor = UIColor.rgb(red: 255, green: 108, blue: 0)
    }
    
    let pwConfirmLabel = UILabel().then {
        $0.text = "비밀번호 확인"
        $0.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 14)
        $0.textColor = UIColor.rgb(red: 100, green: 98, blue: 94)
    }
    
    let pwConfirmTextField = CustomTextField(image: UIImage(named: "tfPassword")!, text: "다시 한번 입력").then {
        $0.backgroundColor = UIColor.rgb(red: 243, green: 243, blue: 243)
        $0.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
        $0.isSecureTextEntry = true
    }
    
    let pwConfirmAlert = UILabel().then {
        $0.text = ""
        $0.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 11)
        $0.textColor = UIColor.rgb(red: 255, green: 108, blue: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bind()
    }
    
}

extension SignUpViewController {
    
    private func setUI() {
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        safeView.addSubview(backBt)
        backBt.snp.makeConstraints {
            $0.top.equalToSuperview().offset(6)
            $0.leading.equalToSuperview().offset(20)
        }
        
        safeView.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(backBt.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        scrollView.addSubview(welcomeLabel)
        welcomeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(13)
            $0.leading.equalToSuperview().offset(25)
        }
        
        scrollView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(welcomeLabel.snp.bottom).offset(11)
            $0.leading.equalToSuperview().offset(25)
        }
        
        scrollView.addSubview(emailLabel)
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(33)
            $0.leading.equalToSuperview().offset(25)
        }
        
        scrollView.addSubview(emailTextField)
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(25)
            $0.width.equalTo(self.view.frame.width - 50)
        }
        
        scrollView.addSubview(emailAlert)
        emailAlert.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(25)
        }
        
        scrollView.addSubview(pwLabel)
        pwLabel.snp.makeConstraints {
            $0.top.equalTo(emailAlert.snp.bottom).offset(17)
            $0.leading.equalToSuperview().offset(25)
        }
        
        scrollView.addSubview(pwTextField)
        pwTextField.snp.makeConstraints {
            $0.top.equalTo(pwLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(25)
            $0.width.equalTo(self.view.frame.width - 50)
        }
        
        scrollView.addSubview(pwAlert)
        pwAlert.snp.makeConstraints {
            $0.top.equalTo(pwTextField.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(25)
        }
        
        scrollView.addSubview(pwConfirmLabel)
        pwConfirmLabel.snp.makeConstraints {
            $0.top.equalTo(pwAlert.snp.bottom).offset(17)
            $0.leading.equalToSuperview().offset(25)
        }
        
        scrollView.addSubview(pwConfirmTextField)
        pwConfirmTextField.snp.makeConstraints {
            $0.top.equalTo(pwConfirmLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(25)
            $0.width.equalTo(self.view.frame.width - 50)
        }
        
        scrollView.addSubview(pwConfirmAlert)
        pwConfirmAlert.snp.makeConstraints {
            $0.top.equalTo(pwConfirmTextField.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(25)
        }
        
        
        
        scrollView.updateContentSize()
        scrollView.layoutIfNeeded()
    }
    
    private func bind() {
        bindInput()
        bindOutput()
    }
    
    private func bindInput() {
        
    }
    
    private func bindOutput() {
        
    }
}

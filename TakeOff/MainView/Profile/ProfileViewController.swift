//
//  ProfileViewController.swift
//  TakeOff
//
//  Created by Jun on 2021/08/25.
//

import Foundation
import UIKit
import SnapKit
import Then
import Firebase
import RxSwift

class ProfileViewController: UIViewController {
    let vm = ProfileViewModel()
    
    let logOutBt = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: nil)
    
    let exampleText = UITextField().then {
        $0.text = "ProfileViewController"
    }
    
    let userContainer = UIView().then {
        $0.backgroundColor = UIColor.red
    }
    let postContainer = UIView().then {
        $0.backgroundColor = UIColor.yellow
    }
    
    let profileImageView = UIImageView().then {
        $0.image = UIImage(named: "logo")
        $0.layer.cornerRadius = 40
        $0.backgroundColor = UIColor.white   
        $0.layer.masksToBounds = true
    }
    
    
    let usernameLabel = UILabel().then {
        $0.text = User.loginedUser.name
        $0.font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    let postLabel = UILabel().then {
        $0.text =  "0"
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    let followLabel = UILabel().then {
        $0.text = String(User.loginedUser.follower.count)
        $0.textAlignment = .center
    }
    
    let followingLabel = UILabel().then {
        $0.text = String(User.loginedUser.following.count)
        $0.textAlignment = .center
    }
    
    let disposBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
}

extension ProfileViewController {
    
    
    private func setUI() {
        
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = logOutBt
        
        safeView.addSubview(userContainer)
        userContainer.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.25)
        }
        
        userContainer.addSubview(profileImageView)
        profileImageView.snp.makeConstraints {
            $0.leading.top.equalToSuperview().offset(12)
            $0.width.height.equalTo(80)
            
        }
        
        userContainer.addSubview(usernameLabel)
        usernameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(12)
        }
        
        safeView.addSubview(postContainer)
        postContainer.snp.makeConstraints {
            $0.top.equalTo(userContainer.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.75)
        }
        
    }
    
    fileprivate func setupUserStackView() {
        
        
        
    }
    
    
    
    
}

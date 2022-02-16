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
    
    
    
    let exampleText = UITextField().then {
        $0.text = "ProfileViewController"
    }
    
    let settingContainer = UIView().then {
        $0.backgroundColor = .green
    }
    
    let userContainer = UIView().then {
        $0.backgroundColor = UIColor.red
    }
    let postContainer = UIView().then {
        $0.backgroundColor = UIColor.yellow
    }
    
    let userImage = UIImageView().then {
        $0.image = UIImage(named: "logo")
        $0.layer.cornerRadius = 50
        $0.backgroundColor = UIColor.white   
        $0.layer.masksToBounds = true
    }
    
    
    
    let userLabel = UILabel().then {
        $0.text = User.loginedUser.name
        $0.backgroundColor = UIColor.green   
    }
    
    let postLabel = UILabel().then {
        $0.text =  "0" //처음 0뜨는 거 막을려면 init으로 user 가져오거나 usermodel에 저장시켜놓기?
        //  저장 시킬려면 로그인시 한번 저장 currentuser() 할때 저장값 최신화?
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
        
        safeView.addSubview(settingContainer)
        settingContainer.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.05)
        }
        
        safeView.addSubview(userContainer)
        userContainer.snp.makeConstraints {
            $0.top.equalTo(settingContainer.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.25)
        }
        
        safeView.addSubview(postContainer)
        postContainer.snp.makeConstraints {
            $0.top.equalTo(userContainer.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.7)
        }
        
        
        
        
    }
    
    
}

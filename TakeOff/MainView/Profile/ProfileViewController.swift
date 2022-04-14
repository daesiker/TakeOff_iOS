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
    
    let userContainer = UIView()
    
    let postContainer = UIView()
    
    let profileImageView = UIImageView().then {
        $0.image = UIImage(named: "logo")
        $0.layer.cornerRadius = 40
        $0.backgroundColor = UIColor.white
        $0.clipsToBounds = true
        $0.layer.masksToBounds = true
    }
    
    let usernameLabel = UILabel().then {
        $0.text = User.loginedUser.name
        $0.font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    let postTitleLabel = UILabel().then {
        $0.text = "posts"
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = UIColor.lightGray
        $0.textAlignment = .center
    }
    
    let postLabel = UILabel().then {
        $0.text =  "0"
        $0.textColor = UIColor.black
        $0.font = UIFont.boldSystemFont(ofSize: 14)
        $0.textAlignment = .center
    }
    
    let followersTitleLabel = UILabel().then {
        $0.text = "followers"
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = UIColor.lightGray
        $0.textAlignment = .center
    }
    
    let followersLabel = UILabel().then {
        $0.text = String(User.loginedUser.follower.count)
        $0.textColor = UIColor.black
        $0.font = UIFont.boldSystemFont(ofSize: 14)
        $0.textAlignment = .center
    }
    
    let followingTitleLabel = UILabel().then {
        $0.text = "following"
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = UIColor.lightGray
        $0.textAlignment = .center
    }
    
    let followingLabel = UILabel().then {
        $0.text = String(User.loginedUser.following.count)
        $0.textColor = UIColor.black
        $0.font = UIFont.boldSystemFont(ofSize: 14)
        $0.textAlignment = .center
    }
    
    lazy var gridButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "square.grid.2x2"), for: .normal)
        $0.tintColor = UIColor.mainColor
    }
    
    lazy var listButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "list.dash"), for: .normal)
        $0.tintColor = UIColor(white: 0, alpha: 0.2)
    }
    
    lazy var bookmarkButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "bookmark"), for: .normal)
        $0.tintColor = UIColor(white: 0, alpha: 0.2)
    }
    
    lazy var editProfileFollowButton = UIButton(type: .system).then {
        $0.setTitle("Edit Profile", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 3
    }
    
    lazy var postCV: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .red
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsMultipleSelection = false
        return collectionView
    }()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setCV()
    }
    
}

extension ProfileViewController {
    
    
    private func setCV() {
        self.postCV.dataSource = nil
        self.postCV.delegate = nil
        //register
        postCV.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private func setUI() {
        
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = logOutBt
        
        safeView.addSubview(userContainer)
        userContainer.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.3)
        }
        
        setHeaderUI()

        safeView.addSubview(postContainer)
        postContainer.snp.makeConstraints {
            $0.top.equalTo(userContainer.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.7)
        }
        
        postContainer.addSubview(postCV)
        postCV.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        
    }
    
    fileprivate func setHeaderUI() {
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
        
        setupUserStackView()
        
        setupBottomToolBar()
    }
    
    fileprivate func setupUserStackView() {
        
        let postStackView = UIStackView(arrangedSubviews: [postLabel, postTitleLabel])
        postStackView.axis = .vertical
        postStackView.spacing = 10
        
        let followersStackView = UIStackView(arrangedSubviews: [followersLabel, followersTitleLabel])
        followersStackView.axis = .vertical
        followersStackView.spacing = 10
        
        let followingStackView = UIStackView(arrangedSubviews: [followingLabel, followingTitleLabel])
        followingStackView.axis = .vertical
        followingStackView.spacing = 10
        
        let stackView = UIStackView(arrangedSubviews: [postStackView, followersStackView, followingStackView])
        stackView.distribution = .fillEqually
        
        userContainer.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().offset(-12)
            $0.height.equalTo(40)
        }
        
        userContainer.addSubview(editProfileFollowButton)
        editProfileFollowButton.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(stackView)
            $0.height.equalTo(34)
        }
        
        
        
    }
    
    fileprivate func setupBottomToolBar() {
        
        let topDividerView = UIView()
        topDividerView.backgroundColor = UIColor.lightGray
        
        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = UIColor.lightGray
        
        let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        userContainer.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        userContainer.addSubview(topDividerView)
        topDividerView.snp.makeConstraints {
            $0.bottom.equalTo(stackView.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        
        userContainer.addSubview(bottomDividerView)
        bottomDividerView.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        
    }
    
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 4) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }
    
}

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

    let scrollView = UIScrollView()
    //let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 200, height: 500))
    let disposBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        view.backgroundColor = .white
        initScrollView()
    }
    
    //MARK:- ScrollView with Refresh
    private func initScrollView() {
        
        let refresh = UIRefreshControl()
        refresh.rx.controlEvent(.valueChanged)
            .bind(to: vm.input.refresh)
            .disposed(by: disposBag)

		vm.output.refreshEnd.emit { user in
            print(user)
            // user.~  로 새로고침 함수 하나 만들기 bind로 가능한가?   
            self.followLabel.text = "100"   
            refresh.endRefreshing()   
        }.disposed(by: disposBag)
        
        refresh.backgroundColor = UIColor.clear
        self.scrollView.refreshControl = refresh
    }

    //MARK:- Set UI
    private func setUI() {
        
        setUserProfile()
        
        self.scrollView.addSubview(postContainer)

        postContainer.snp.makeConstraints {
            $0.top.equalTo(userContainer.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
        
        //postContainer.addSubview(collectionView)
        postContainer.snp.makeConstraints {
        	$0.top.left.right.bottom.equalToSuperview()
        }
//let colorObservable = Observable.of([UIColor.red, UIColor.blue, UIColor.gray])
//        
//        colorObservable.bind(to: collectionView.rx.items(cellIdentifier: "q")) {index, c, cell in 
//          cell.backgroundColor = c
//        
//        }
    }
    private func setUserProfile() {
        self.safeView.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        self.scrollView.addSubview(userContainer)
        userContainer.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.25)
            $0.width.equalToSuperview()   
        }
        
        let profileCotainer = UIView().then {
            $0.backgroundColor = UIColor.blue
        }
        
        let userActiveContainer = UIView().then {
            $0.backgroundColor = UIColor.gray
        }
        userContainer.addSubview(profileCotainer)
        userContainer.addSubview(userActiveContainer)
        
        profileCotainer.snp.makeConstraints {
            $0.bottom.top.left.equalToSuperview().inset(10)
            $0.width.equalToSuperview().multipliedBy(0.33)
        }
        
        profileCotainer.addSubview(userImage)
        userImage.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.8)   
        }
        profileCotainer.addSubview(userLabel)
        userLabel.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
        }
        
        userActiveContainer.snp.makeConstraints {
            $0.left.equalTo(profileCotainer.snp.right).inset(-10)
            $0.top.right.bottom.equalToSuperview().inset(10)
        }
        let view1 = infoView(label: postLabel, text: "게시물")
        let view2 = infoView(label: followLabel, text: "follow")
        let view3 = infoView(label: followingLabel, text: "following")
        
        let stackContainer = UIStackView(arrangedSubviews: [view1, view2, view3]) .then {
            $0.alignment = .center
            $0.distribution = .equalSpacing
            $0.axis = .horizontal
        }
        userActiveContainer.addSubview(stackContainer)
        stackContainer.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.right.equalToSuperview()
        }
    }
    
    private func infoView(label:UILabel, text:String) -> UIView {
        let view = UIView().then { $0.backgroundColor = UIColor.yellow }
        view.addSubview(label)
        label.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }
        
        let textLabel = UILabel().then { $0.text = text
            $0.backgroundColor = UIColor.systemBlue
            $0.textAlignment = .center
        }
        view.addSubview(textLabel)
        textLabel.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(label.snp.bottom)
        }
        return view
    }
    
    
}

extension ProfileViewController:UIScrollViewDelegate {
}

//
//  HomeViewController.swift
//  TakeOff
//
//  Created by Jun on 2021/08/23.
//

import Foundation
import UIKit
import SnapKit
import Then
import RxSwift
import RxRelay
import Firebase

class HomeViewController: UIViewController {
    
    lazy var postCV:UICollectionView = {
       let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    let disposeBag = DisposeBag()
    
    var posts = PublishRelay<[Post]>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setCV()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fetchPosts().subscribe({ event in
            switch event {
            case .next(let posts):
                self.posts.accept(posts)
                self.postCV.reloadData()
            case .error(let error):
                print(error)
            case .completed:
                print("comlete")
            }
        }).disposed(by: disposeBag)
    }
}

extension HomeViewController {
    
    private func setUI() {
        
        view.backgroundColor = .white
        safeView.addSubview(postCV)
        postCV.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    private func setCV() {
        
        self.postCV.dataSource = nil
        self.postCV.delegate = nil
        self.postCV.register(PostViewCell.self, forCellWithReuseIdentifier: "cell")
        self.postCV.rx.setDelegate(self).disposed(by: disposeBag)
        self.posts
            .bind(to: self.postCV.rx.items(cellIdentifier: "cell", cellType: PostViewCell.self)) { indexPath, post, cell in
                cell.post = post
            }.disposed(by: disposeBag)
    }
    
    func fetchPosts() -> Observable<[Post]> {
        
        return Observable.create { observe in
            
            Database.database().reference().child("posts").observeSingleEvent(of: .value) { (snapshot) in
                var posts:[Post] = []
                if let userDictionary = snapshot.value as? [String:Any] {
                    for (key, value) in userDictionary {
                        let post = Post(key, dic: value as! [String : Any])
                        if post.user == User.loginedUser.name || User.loginedUser.follower.contains(post.user) {
                            posts.append(post)
                        }
                    }
                    observe.onNext(posts)
                }
            }
            
            return Disposables.create()
        }
    }
    
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height:CGFloat = 40 + 8 + 8
        height += view.frame.width
        height += 110
        return CGSize(width: view.frame.width, height: height)
    }
    
    
}


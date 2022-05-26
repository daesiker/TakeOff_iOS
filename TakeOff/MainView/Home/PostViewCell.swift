//
//  PostViewCell.swift
//  TakeOff
//
//  Created by Jun on 2022/05/25.
//

import UIKit
import Then
import RxSwift

class PostViewCell: UICollectionViewCell {
    
    var post: Post? {
        didSet {
            
        }
    }
    
    let userProfileImageView:CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 40 / 2
        return iv
    }()
    
    let photoImageScrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.isPagingEnabled = true
        $0.alwaysBounceVertical = false
        $0.isScrollEnabled = true
        $0.bounces = false
        $0.backgroundColor = .red
    }
    
    let pageControl = UIPageControl()
    
    let userNameLabel = UILabel().then {
        $0.text = "Username"
        $0.textColor = .black
        $0.font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    let optionButton = UIButton(type: .system).then {
        $0.setTitle("•••", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }
    
    lazy var likeButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "like_unselected")?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    lazy var commentButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "comment")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
    }
    
    let sendMessageButton = UIButton(type: .system).then {
        
        $0.setImage(UIImage(named: "send2")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
    }
    
    let bookmarkButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "ribbon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
    }
    
    let captionLabel = UILabel().then {
        $0.textColor = .black
        $0.numberOfLines = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        
        addSubview(userProfileImageView)
        userProfileImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(8)
        }
        
        addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(userProfileImageView.snp.trailing).offset(8)
        }
        
        addSubview(optionButton)
        optionButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        addSubview(photoImageScrollView)
        photoImageScrollView.snp.makeConstraints {
            $0.top.equalTo(userProfileImageView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.width.height.equalTo(frame.width)
        }
        
        let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, sendMessageButton]).then {
            $0.distribution = .fillEqually
        }
        
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalTo(photoImageScrollView.snp.bottom)
            $0.leading.equalToSuperview().offset(4)
            $0.width.equalTo(120)
            $0.height.equalTo(50)
        }
        
        addSubview(captionLabel)
        captionLabel.snp.makeConstraints {
            $0.top.equalTo(likeButton.snp.bottom)
            $0.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-8)
            $0.bottom.equalToSuperview()
        }
        
        
    }
    
    private func setSV() {
        let count = post?.realImage.count ?? 1
        photoImageScrollView.delegate = self
        photoImageScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(count), height: UIScreen.main.bounds.width)
        pageControl.currentPage = 0
        pageControl.numberOfPages = (post?.realImage.count)!
        pageControl.pageIndicatorTintColor = UIColor.rgb(red: 171, green: 171, blue: 171)
        pageControl.currentPageIndicatorTintColor = UIColor.mainColor
    }
    
    private func addContentScrollView() {
        for i in 0..<(post?.realImage.count)! {
            let imageView = UIImageView()
            let xPos = frame.width * CGFloat(i)
            imageView.frame = CGRect(x: xPos, y: 0, width: photoImageScrollView.bounds.width, height: photoImageScrollView.bounds.height)
            imageView.image = post?.realImage[i]
            photoImageScrollView.addSubview(imageView)
            photoImageScrollView.contentSize.width = imageView.frame.width * CGFloat(i + 1)
        }
    }
    
}

extension PostViewCell: UIScrollViewDelegate {
    
    private func setPageControlSelectedPage(currentPage: Int) {
        pageControl.currentPage = currentPage
    }
}

//
//  PostListCell.swift
//  TakeOff
//
//  Created by Jun on 2021/10/08.
//

import Foundation
import UIKit
import Then
import FSPagerView

class PostListCell: UICollectionViewCell {
    
    
    
    
    
    //프로필 사진
    let userProfileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    //게시물
    let pagerView = FSPagerView().then {
        $0.transformer = FSPagerViewTransformer(type: .linear)
    }
    
    let pageControl = FSPageControl().then {
        $0.setStrokeColor(.gray, for: .normal)
        $0.setStrokeColor(UIColor.mainColor, for: .selected)
        $0.setFillColor(.gray, for: .normal)
        $0.setFillColor(UIColor.mainColor, for: .selected)
        $0.hidesForSinglePage = true
    }
    
    //닉네임
    let usernameLabel = UILabel().then {
        $0.text = "Username"
        $0.textColor = .black
        $0.font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    //위치
    let locationLabel = UILabel().then {
        $0.text = "location"
        $0.textColor = .gray
        $0.font = UIFont.boldSystemFont(ofSize: 12)
    }
    
    //내용
    let captionLabel = UILabel().then {
        $0.textColor = .black
        $0.numberOfLines = 0
    }
    
    //좋아요 버튼
    lazy var likeButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "like_unselected")?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    //댓글 버튼
    lazy var commentButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "comment")?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    //메세지 버튼
    lazy var sendMessageButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "send")?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    lazy var bookMarkButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "ribbon")?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}

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
    
    var post: Post?
    
    let userProfileImageView:CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let photoImageView: UIScrollView = {
        let sv = UIScrollView()
        return sv
    }()
    
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

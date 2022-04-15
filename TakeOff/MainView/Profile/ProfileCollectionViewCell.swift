//
//  ProfileCollectionViewCell.swift
//  TakeOff
//
//  Created by Jun on 2022/04/15.
//

import UIKit
import Then

class ProfileCollectionViewCell: UICollectionViewCell {
    
    var post: Post? {
        didSet {
            if let url = post?.images[0] {
                photoImageView.loadImage(urlString: url)
            }
        }
    }
    
    let photoImageView = CustomImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(photoImageView)
        photoImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

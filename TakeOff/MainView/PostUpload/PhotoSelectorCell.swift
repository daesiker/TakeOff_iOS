//
//  PhotoSelectorCell.swift
//  TakeOff
//
//  Created by Jun on 2021/08/26.
//

import Foundation
import UIKit
import Then

class PhotoSelectorCell: UICollectionViewCell {
    
    let vm = PostUploadViewModel.instance
    
    lazy var photoImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = .lightGray
    }
    
    lazy var text = UILabel().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 15.0
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.white.cgColor
        $0.text = ""
        $0.textAlignment = .center
        $0.textColor = .white
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                text.isHidden = false
            } else {
                text.isHidden = true
                text.text = ""
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        
        addSubview(photoImageView)
        photoImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        photoImageView.addSubview(text)
        text.isHidden = true
        text.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.right.equalToSuperview().offset(-5)
            $0.width.height.equalToSuperview().multipliedBy(0.3)
        }
        
    }
}

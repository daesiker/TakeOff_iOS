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
    
    let photoImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = .lightGray
    }
    
    let text = UILabel().then {
        $0.text = ""
        $0.textColor = .black
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
        if vm.isMultiSelected.value {
            addSubview(text)
            text.snp.makeConstraints {
                $0.top.equalToSuperview().offset(5)
                $0.bottom.equalToSuperview().offset(-5)
                $0.width.height.equalTo(20)
            }
        }
        
    }
}

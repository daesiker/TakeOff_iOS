//
//  SharePhotoController.swift
//  TakeOff
//
//  Created by Jun on 2021/08/29.
//

import Foundation
import UIKit
import Firebase
import Then
class SharePhotoController: UIViewController {
    
    var selectedImage: UIImage? {
        didSet {
            self.imageView.image = selectedImage
        }
    }
    
    let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = .red
    }
    
    let textVIew = UITextView().then {
        $0.font = UIFont.systemFont(ofSize: 14)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageAndTextViews()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    fileprivate func setupImageAndTextViews() {
        let contentView = UIView()
        contentView.backgroundColor = .white
        
        view.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.height.equalTo(100)
            $0.left.right.top.equalToSuperview()
        }
    }
}

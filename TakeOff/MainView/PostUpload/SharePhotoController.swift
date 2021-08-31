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
    
    let textView = UITextView().then {
        $0.font = UIFont.systemFont(ofSize: 14)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        setupImageAndTextViews()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    fileprivate func setupImageAndTextViews() {
        let contentView = UIView()
        contentView.backgroundColor = .white
        
        safeView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.height.equalTo(100)
            $0.left.right.top.equalToSuperview()
        }
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.width.equalTo(84)
            $0.top.left.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview().offset(-8)
        }
        
        contentView.addSubview(textView)
        textView.snp.makeConstraints {
            $0.top.bottom.right.equalToSuperview()
            $0.left.equalTo(imageView).offset(4)
        }
    }
    
    @objc func handleShare() {
        guard let caption = textView.text, !caption.isEmpty else { return }
        guard let image = selectedImage else { return }
        guard let uploadData = image.jpegData(compressionQuality: 0.5) else { return }
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let fileName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("posts").child(fileName)
        
        storageRef.putData(uploadData, metadata: nil) { (metadata, err) in
            if let err = err {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to upload post image: ", err)
                return
            }
            
            storageRef.downloadURL { downloadURL, err in
                if let err = err {
                    print("Failed to fetch downloadURL: ", err)
                    return
                }
                
                guard let imageUrl = downloadURL?.absoluteString else { return }
                print("Successfully uploaded post image:", imageUrl)
                
                
            }
            
        }
        
    }
    
    fileprivate func saveToDatabaseWithImageUrl(imageUrl: String) {
        //guard let postImage = selectedImage else { return }
        guard let caption = textView.text else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userPostRef = Database.database().reference().child("posts").child(uid)
        let ref = userPostRef.childByAutoId()
        
        let values:[String:Any] = ["imageUrl": imageUrl,
                                   "caption": caption,
                                   "creationDate": Date().timeIntervalSince1970 ]
        ref.updateChildValues(values) { (err, ref) in
            if let err = err {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to save post to DB", err)
                return
            }
            
            self.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    
    
    
}

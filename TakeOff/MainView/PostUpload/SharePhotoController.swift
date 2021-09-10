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
import RxSwift
import RxCocoa
import FSPagerView

class SharePhotoController: UIViewController {
    
    let vm = SharePhotoViewModel()
    var disposeBag = DisposeBag()
    
    var images:[UIImage] = []
    
    
    let contentView = UIView().then {
        $0.backgroundColor = .white
    }
    
    let pagerView = FSPagerView().then {
        $0.transformer = FSPagerViewTransformer(type: .linear)
    }
    
    let pageControl = FSPageControl().then {
        $0.setStrokeColor(.gray, for: .normal)
        $0.setStrokeColor(UIColor.mainColor, for: .selected)
        $0.setFillColor(.gray, for: .normal)
        $0.setFillColor(UIColor.mainColor, for: .selected)
        $0.hidesForSinglePage = false
    }
    
    
    let textView = UITextView().then {
        $0.font = UIFont.systemFont(ofSize: 14)
        
    }
    
    let shareButton = UIBarButtonItem().then {
        $0.title = "Share"
        $0.style = .plain
        $0.target = $0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        setPagerView()
        setUI()
        bind()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

extension SharePhotoController: SignUpViewAttributes {
    
    func setPagerView() {
        pagerView.delegate = self
        pagerView.dataSource = self
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        pageControl.contentHorizontalAlignment = .center
        pageControl.numberOfPages = self.images.count
    }
    
    func setUI() {
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        navigationItem.rightBarButtonItem = shareButton
        
        safeView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(0.8)
            $0.top.equalToSuperview()
            $0.left.right.equalTo(self.view)
        }
        
        contentView.addSubview(pagerView)
        pagerView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.5)
        }
        
        contentView.addSubview(textView)
        textView.snp.makeConstraints {
            $0.top.equalTo(pageControl.snp.bottom).offset(2)
            $0.left.right.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.3)
        }
        
        
    }
    
    func bind() {
        bindInput()
        bindOutput()
    }
    
    func bindInput() {
        textView.rx.text.orEmpty
            .bind(to: vm.input.textObserver)
            .disposed(by: disposeBag)
        
            
        
//        vm.input.imageObserver
//            .bind(to: imageView.rx.image)
//            .disposed(by: disposeBag)
        
        
        shareButton.rx.tap
            .bind(to: vm.input.buttonObserver)
            .disposed(by: disposeBag)
    }
    
    func bindOutput() {
        
        
        
    }
    
}

extension SharePhotoController: FSPagerViewDelegate, FSPagerViewDataSource {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return images.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.image = images[index]
        cell.imageView?.clipsToBounds = true
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
    }
    
    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int) {
        self.pageControl.currentPage = index
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.pageControl.currentPage = targetIndex
    }
    
}

extension SharePhotoController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textViewSetupView()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textViewSetupView()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewSetupView() {
        if textView.text == "내용입력" {
            textView.text = ""
            textView.textColor = .black
        } else if textView.text == "" {
            textView.text = "내용입력"
            textView.textColor = .gray
        }
    }
    
}


//@objc func handleShare() {
//    guard let caption = textView.text, !caption.isEmpty else { return }
//    guard let image = selectedImage else { return }
//    guard let uploadData = image.jpegData(compressionQuality: 0.5) else { return }
//
//    navigationItem.rightBarButtonItem?.isEnabled = false
//
//    let fileName = NSUUID().uuidString
//    let storageRef = Storage.storage().reference().child("posts").child(fileName)
//
//    storageRef.putData(uploadData, metadata: nil) { (metadata, err) in
//        if let err = err {
//            self.navigationItem.rightBarButtonItem?.isEnabled = true
//            print("Failed to upload post image: ", err)
//            return
//        }
//
//        storageRef.downloadURL { downloadURL, err in
//            if let err = err {
//                print("Failed to fetch downloadURL: ", err)
//                return
//            }
//
//            guard let imageUrl = downloadURL?.absoluteString else { return }
//            print("Successfully uploaded post image:", imageUrl)
//
//
//        }
//
//    }
//
//}
//
//fileprivate func saveToDatabaseWithImageUrl(imageUrl: String) {
//    //guard let postImage = selectedImage else { return }
//    guard let caption = textView.text else { return }
//    guard let uid = Auth.auth().currentUser?.uid else { return }
//
//    let userPostRef = Database.database().reference().child("posts").child(uid)
//    let ref = userPostRef.childByAutoId()
//
//    let values:[String:Any] = ["imageUrl": imageUrl,
//                               "caption": caption,
//                               "creationDate": Date().timeIntervalSince1970 ]
//    ref.updateChildValues(values) { (err, ref) in
//        if let err = err {
//            self.navigationItem.rightBarButtonItem?.isEnabled = true
//            print("Failed to save post to DB", err)
//            return
//        }
//
//        self.dismiss(animated: true, completion: nil)
//
//    }
//
//}

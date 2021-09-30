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
    var images:[UIImage]
    
    let backgroundView = UIImageView(image: UIImage(named: "background"))
    let contentView = UIView().then {
        $0.backgroundColor = .clear
    }
    
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
    
    
    let textView = UITextView().then {
        $0.text = "문구 입력"
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = UIColor.lightGray
        $0.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
    }
    
    let shareButton = UIBarButtonItem().then {
        $0.title = "Share"
        $0.style = .plain
        $0.target = $0
    }
    
    init(images: [UIImage]) {
        self.images = images
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        setPagerView()
        setUI()
        //bind()
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
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        navigationItem.rightBarButtonItem = shareButton
        
        safeView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(0.8)
            $0.top.equalToSuperview()
            $0.left.right.equalTo(self.view)
        }
        
        contentView.addSubview(pagerView)
        pagerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.left.right.equalTo(self.safeView)
            $0.height.equalToSuperview().multipliedBy(0.5)
        }

        pagerView.addSubview(pageControl)
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-8)
            $0.width.equalToSuperview().multipliedBy(0.5)
            $0.height.equalToSuperview().multipliedBy(0.1)
        }
        
        contentView.addSubview(textView)
        textView.snp.makeConstraints {
            $0.top.equalTo(pagerView.snp.bottom).offset(8)
            $0.left.right.equalTo(self.safeView)
            $0.height.equalToSuperview().multipliedBy(0.3)
        }
        
        //위치 추가해주기
        
        
    }
    
    func bind() {
        bindInput()
        bindOutput()
    }
    
    func bindInput() {
        textView.rx.text.orEmpty
            .bind(to: vm.input.textObserver)
            .disposed(by: disposeBag)
        
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
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "문구 입력"
            textView.textColor = UIColor.lightGray
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

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

//MARK: 게시물 올릴 때 유저 이름 추가
//MARK: 에러발생시 알림 추가
//MARK: 게시물을 올린뒤에 꺼져야함


class SharePhotoController: UIViewController {
    
    let vm = SharePhotoViewModel()
    var disposeBag = DisposeBag()
    var images:[UIImage]
    
    let selectedPhotoSV = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.isPagingEnabled = true
        $0.alwaysBounceVertical = false
        $0.isScrollEnabled = true
        $0.bounces = false
        $0.backgroundColor = .red
    }
    
    let pageControl = UIPageControl().then {
        $0.hidesForSinglePage = true
    }
    
    let middleView = UIView()
    
    let hashTagCV: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsMultipleSelection = true
        return collectionView
    }()
    
    let hashTagData = Observable<[String]>.of(["#재즈", "#버스킹", "#밴드", "#힙합", "#인디", "#공예", "#전시", "#디지털", "#패션", "#기타"])
    
    let hashTagDomy:[String] = ["#재즈", "#버스킹", "#밴드", "#힙합", "#인디", "#공예", "#전시", "#디지털", "#패션", "#기타"]
    
    lazy var textView = UITextView().then {
        $0.text = "문구 입력"
        $0.delegate = self
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = UIColor.lightGray
        $0.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
    }
    
    let shareButton = UIBarButtonItem(title: "Share", style: .plain, target: self, action: nil)
    
    init(images: [UIImage]) {
        self.images = images
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setCV()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setScrollView()
    }
    
}

extension SharePhotoController {
    
    func setCV() {
        
        hashTagCV.delegate = nil
        hashTagCV.dataSource = nil
        hashTagCV.register(HashtagCell.self, forCellWithReuseIdentifier: "cell")
        hashTagCV.rx.setDelegate(self).disposed(by: disposeBag)
        hashTagData
            .bind(to: hashTagCV.rx.items(cellIdentifier: "cell", cellType: HashtagCell.self)) { indexPath, title, cell in
                cell.configure(name: title)
            }.disposed(by: disposeBag)
        
        hashTagCV.rx.itemSelected.subscribe(onNext: { _ in
            
            var hashTags:[String] = []
            
            if let indexPaths = self.hashTagCV.indexPathsForSelectedItems {
                for indexPath in indexPaths {
                    let cell = self.hashTagCV.cellForItem(at: indexPath) as! HashtagCell
                    hashTags.append(cell.titleLabel.text!)
                }
            }
            
            self.vm.input.hashtagObserver.accept(hashTags)
            
        }).disposed(by: disposeBag)
        
        hashTagCV.rx.itemDeselected.subscribe(onNext: { _ in
            
            var hashTags:[String] = []
            if let indexPaths = self.hashTagCV.indexPathsForSelectedItems {
                for indexPath in indexPaths {
                    let cell = self.hashTagCV.cellForItem(at: indexPath) as! HashtagCell
                    hashTags.append(cell.titleLabel.text!)
                }
            }
            self.vm.input.hashtagObserver.accept(hashTags)
            
        }).disposed(by: disposeBag)
        
    }
    
    func setUI() {
        
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = shareButton
        
        safeView.addSubview(selectedPhotoSV)
        selectedPhotoSV.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.width.equalTo(view.frame.width - 20)
            $0.height.equalToSuperview().multipliedBy(0.5)
        }
        
        safeView.addSubview(middleView)
        middleView.snp.makeConstraints {
            $0.top.equalTo(selectedPhotoSV.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.1)
        }
        
        middleView.addSubview(hashTagCV)
        hashTagCV.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        safeView.addSubview(textView)
        textView.snp.makeConstraints {
            $0.top.equalTo(middleView.snp.bottom)
            $0.leading.trailing.equalTo(self.safeView)
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
        
        shareButton.rx.tap.map { self.images }
            .bind(to: vm.input.buttonObserver)
            .disposed(by: disposeBag)
        
        
        
    }
    
    func bindOutput() {
        vm.output.shareDB
            .emit(onNext: dismiss)
            .disposed(by: disposeBag)
    }
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
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

extension SharePhotoController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return HashtagCell.fittingSize(availableHeight: 21, name: hashTagDomy[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 20)
    }
    
}

extension SharePhotoController: UIScrollViewDelegate {
    
    private func setScrollView() {
        selectedPhotoSV.delegate = self
        selectedPhotoSV.contentSize = CGSize(width: (UIScreen.main.bounds.width - 20) * CGFloat(images.count), height: UIScreen.main.bounds.height / 2)
        pageControl.currentPage = 0
        pageControl.numberOfPages = images.count
        pageControl.pageIndicatorTintColor = UIColor.rgb(red: 171, green: 171, blue: 171)
        pageControl.currentPageIndicatorTintColor = UIColor.mainColor
        
        addContentScrollView()
    }
    
    private func addContentScrollView() {
        
        for i in 0..<images.count {
            
            let imageView = UIImageView()
            let xPos = (self.view.frame.width - 20) * CGFloat(i)
            imageView.frame = CGRect(x: xPos, y: 0, width: selectedPhotoSV.bounds.width, height: selectedPhotoSV.bounds.height)
            imageView.image = images[i]
            selectedPhotoSV.addSubview(imageView)
            selectedPhotoSV.contentSize.width = imageView.frame.width * CGFloat(i + 1)
            
        }
        
        selectedPhotoSV.layoutIfNeeded()
    }
    
    private func setPageControlSelectedPage(currentPage:Int) {
        pageControl.currentPage = currentPage
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = scrollView.contentOffset.x / scrollView.frame.size.width
        setPageControlSelectedPage(currentPage: Int(round(value)))
    }
    
}

final class HashtagCell:UICollectionViewCell {
    
    static func fittingSize(availableHeight: CGFloat, name: String) -> CGSize {
        
        let cell = HashtagCell()
        cell.configure(name: name)
        
        let targetSize = CGSize(width: UIView.layoutFittingCompressedSize.width, height: availableHeight)
        
        return cell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .fittingSizeLevel, verticalFittingPriority: .required)
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                borderView.alpha = 1.0
                titleLabel.textColor = UIColor.rgb(red: 137, green: 75, blue: 41)
                titleLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
            } else {
                titleLabel.textColor = UIColor.rgb(red: 205, green: 153, blue: 117)
                titleLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 14)
                borderView.alpha = 0.0
            }
        }
    }
    
    let titleLabel: UILabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = UIColor.rgb(red: 205, green: 153, blue: 117)
        $0.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
    }
    
    let borderView = UIView().then {
        $0.backgroundColor = UIColor.rgb(red: 255, green: 199, blue: 143)
        $0.layer.cornerRadius = 3.0
        $0.alpha = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        contentView.addSubview(borderView)
        borderView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(10)
        }
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(name: String) {
        titleLabel.text = name
    }
    
}

//
//  PostUploadViewController.swift
//  TakeOff
//
//  Created by Jun on 2022/01/19.
//

import UIKit
import RxSwift
import RxCocoa
import Photos
import RxDataSources
import FSPagerView

class PostUploadViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    let vm = PostUploadViewModel()
    
    //이미지 바인딩
    
    let selectedPhotoSV = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.isPagingEnabled = true
        $0.alwaysBounceVertical = false
        $0.isScrollEnabled = true
        $0.bounces = false
    }
    
    let pageControl = UIPageControl()
    
    let photoCV: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.rgb(red: 255, green: 228, blue: 182)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setupNavigationButtons()
        setCV()
        bind()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}

extension PostUploadViewController {
    
    private func setUI() {
        view.backgroundColor = .white
        
        
        safeView.addSubview(photoCV)
        photoCV.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    fileprivate func setupNavigationButtons() {
        navigationController?.navigationBar.tintColor = UIColor.mainColor
        navigationController?.title = "New Post"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: nil)
        
    }
    
    
    private func bind() {
        self.photoCV.reloadData()
    }
    
    
    
    private func setCV() {
        self.photoCV.dataSource = nil
        self.photoCV.delegate = nil
        photoCV.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: "photoCell")
        photoCV.rx.setDelegate(self).disposed(by: disposeBag)
        
        vm.totalImage
            .bind(to: self.photoCV.rx.items(cellIdentifier: "photoCell", cellType: PhotoSelectorCell.self)) { indexPath, image, cell in
                cell.photoImageView.image = image
            }.disposed(by: disposeBag)
        
        
    }
}

extension PostUploadViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3) / 4
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    
}

extension PostUploadViewController: UIScrollViewDelegate {
    
    private func setScrollView() {
        selectedPhotoSV.delegate = self
        
        
    }
    
    
}

//
//  PostUploadViewController.swift
//  TakeOff
//
//  Created by Jun on 2022/01/19.
//

import UIKit
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
    
    let headerPagerView = FSPagerView().then {
        $0.transformer = FSPagerViewTransformer(type: .linear)
    }
    
    let headerPageControl = FSPageControl().then {
        $0.setStrokeColor(.gray, for: .normal)
        $0.setStrokeColor(UIColor.mainColor, for: .selected)
        $0.setFillColor(.gray, for: .normal)
        $0.setFillColor(UIColor.mainColor, for: .selected)
        $0.hidesForSinglePage = true
    }
    
    
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
        
        safeView.addSubview(headerPagerView)
        headerPagerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(self.view.frame.height).multipliedBy(0.5)
        }
        
        headerPagerView.addSubview(headerPageControl)
        headerPageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-8)
            $0.width.equalToSuperview().multipliedBy(0.5)
            $0.height.equalToSuperview().multipliedBy(0.1)
        }
        
        safeView.addSubview(photoCV)
        photoCV.snp.makeConstraints {
            $0.top.equalTo(headerPagerView.snp.bottom)
            $0.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    fileprivate func setupNavigationButtons() {
        navigationController?.navigationBar.tintColor = UIColor.mainColor
        navigationController?.title = "New Post"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: nil)
        
    }
    
    private func bind() {
        
    }
    
    
    
    private func setCV() {
        headerPagerView.delegate = self
        headerPagerView.dataSource = self
        headerPagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "headerCell")
        headerPageControl.contentHorizontalAlignment = .center
        headerPageControl.numberOfPages = vm.selectedImage.count
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

extension PostUploadViewController: FSPagerViewDelegate, FSPagerViewDataSource {
    
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return vm.selectedImage.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "headerCell", at: index)
        cell.imageView?.image = vm.selectedImage[index]
        cell.imageView?.clipsToBounds = true
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
    }
    
    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int) {
        self.headerPageControl.currentPage = index
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.headerPageControl.currentPage = targetIndex
    }
    
}

extension PostUploadViewController: UIScrollViewDelegate {
    
    private func setScrollView() {
        selectedPhotoSV.delegate = self
        
        
    }
    
    
}

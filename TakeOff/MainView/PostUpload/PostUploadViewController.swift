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
    
    var selectedImage:[UIImage] = []
    
    let rightBarButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: nil)
    let leftBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: nil)
    
    let selectedPhotoSV = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.isPagingEnabled = true
        $0.alwaysBounceVertical = false
        $0.isScrollEnabled = true
        $0.bounces = false
        $0.backgroundColor = .red
    }
    
    let middleView = UIView()
    
    let pageControl = UIPageControl().then {
        $0.hidesForSinglePage = true
    }
    
    let multiSelectedButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(systemName: "aspectratio"), for: .normal)
        $0.tintColor = .gray
    }
    
    
    let photoCV: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsMultipleSelection = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setupNavigationButtons()
        setCV()
        bind()
        setScrollView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        vm.fetchPhotos()
            .asSignal(onErrorJustReturn: [])
            .emit { images in
                self.selectedImage = [images[0]]
                self.vm.totalImage.accept(images)
                self.photoCV.reloadData()
                self.setScrollView()
            }.disposed(by: disposeBag)
    }
    
    
}

extension PostUploadViewController {
    
    private func setUI() {
        view.backgroundColor = .white
        
        //add ScrollView
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
            $0.height.equalToSuperview().multipliedBy(0.05)
        }
        
        middleView.addSubview(pageControl)
        pageControl.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        middleView.addSubview(multiSelectedButton)
        multiSelectedButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-8)
        }
        
        safeView.addSubview(photoCV)
        photoCV.snp.makeConstraints {
            $0.top.equalTo(middleView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.45)
        }
    }
    
    fileprivate func setupNavigationButtons() {
        navigationController?.navigationBar.tintColor = UIColor.mainColor
        navigationController?.title = "New Post"
        navigationItem.rightBarButtonItem = rightBarButton
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    
    private func bind() {
        
        leftBarButton.rx.tap.subscribe(onNext: {
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        rightBarButton.rx.tap.subscribe(onNext: {
            
            let vc = SharePhotoController(images: self.selectedImage)
            self.navigationController?.pushViewController(vc, animated: true)
            
        }).disposed(by: disposeBag)
        
        multiSelectedButton.rx.tap.subscribe(onNext: {
            
            if self.photoCV.allowsMultipleSelection {
                self.multiSelectedButton.tintColor = .gray
                self.photoCV.allowsMultipleSelection = false
            } else {
                self.multiSelectedButton.tintColor = .mainColor
                self.photoCV.allowsMultipleSelection = true
            }
            
        }).disposed(by: disposeBag)
        
        
        
    }
    
    //전체 사진 CollectionView에 바인딩
    private func setCV() {
        self.photoCV.dataSource = nil
        self.photoCV.delegate = nil
        photoCV.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: "photoCell")
        photoCV.rx.setDelegate(self).disposed(by: disposeBag)
        
        photoCV.rx.itemSelected.subscribe(onNext: { _ in
            
            if let indexPaths = self.photoCV.indexPathsForSelectedItems {
                self.selectedImage = []
                if indexPaths.count == 1 {
                    let cell = self.photoCV.cellForItem(at: indexPaths[0]) as! PhotoSelectorCell
                    cell.text.text = "V"
                    self.selectedImage = [cell.photoImageView.image!]
                } else {
                    for i in 0..<indexPaths.count {
                        let cell = self.photoCV.cellForItem(at: indexPaths[i]) as! PhotoSelectorCell
                        cell.text.text = "\(i + 1)"
                        self.selectedImage.append(cell.photoImageView.image!)
                    }
                }
                self.setScrollView()
            }
            
        }).disposed(by: disposeBag)
        
        photoCV.rx.itemDeselected.subscribe(onNext: { indexPath in
            
            
            if let indexPaths = self.photoCV.indexPathsForSelectedItems {
                if indexPaths.count == 0 {
                    let cell = self.photoCV.cellForItem(at: indexPath) as! PhotoSelectorCell
                    cell.isSelected = true
                    cell.text.text = "V"
                    self.selectedImage = [cell.photoImageView.image!]
                } else {
                    self.selectedImage = []
                    for i in 0..<indexPaths.count {
                        let cell = self.photoCV.cellForItem(at: indexPaths[i]) as! PhotoSelectorCell
                        cell.text.text = "\(i + 1)"
                        self.selectedImage.append(cell.photoImageView.image!)
                    }
                }
            } else {
                let cell = self.photoCV.cellForItem(at: indexPath) as! PhotoSelectorCell
                cell.isSelected = true
                cell.text.text = "V"
                self.selectedImage = [cell.photoImageView.image!]
            }
            
            self.setScrollView()
        }).disposed(by: disposeBag)
        
        vm.totalImage
            .bind(to: self.photoCV.rx.items(cellIdentifier: "photoCell", cellType: PhotoSelectorCell.self)) { indexPath, image, cell in
                if indexPath == 0 {
                    cell.isSelected = true
                    cell.text.text = "V"
                }
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
        let width = (view.frame.width - 5) / 4
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }
    
}

extension PostUploadViewController: UIScrollViewDelegate {
    
    private func setScrollView() {
        selectedPhotoSV.delegate = self
        selectedPhotoSV.contentSize = CGSize(width: (UIScreen.main.bounds.width - 20) * CGFloat(selectedImage.count), height: UIScreen.main.bounds.height / 2)
        pageControl.currentPage = 0
        pageControl.numberOfPages = selectedImage.count
        pageControl.pageIndicatorTintColor = UIColor.rgb(red: 171, green: 171, blue: 171)
        pageControl.currentPageIndicatorTintColor = UIColor.mainColor
        addContentScrollView()
        
    }
    
    private func addContentScrollView() {
        
        for i in 0..<selectedImage.count {
            let imageView = UIImageView()
            let xPos = (self.view.frame.width - 20) * CGFloat(i)
            imageView.frame = CGRect(x: xPos, y: 0, width: selectedPhotoSV.bounds.width, height: selectedPhotoSV.bounds.height)
            imageView.image = selectedImage[i]
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

//
//  RxPostUploadView.swift
//  TakeOff
//
//  Created by Jun on 2021/09/03.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Photos
import RxDataSources

class PostUploadView: UICollectionViewController {
    let cellId = "cellId"
    let headerId = "headerId"
    let disposeBag = DisposeBag()
    let vm = PostUploadViewModel.instance
    var header: PhotoSelectorHeader?
    
    var dataSource = RxCollectionViewSectionedReloadDataSource<PostUploadSectionModel> { ds, cv, ip, item in
        let cell = cv.dequeueReusableCell(withReuseIdentifier: "cellId", for: ip) as! PhotoSelectorCell
        //전체 이미지를 가져옴
        let image = ds.sectionModels[0].items[ip.item]
        //이미지를 ImageView에 넣고
        cell.photoImageView.image = image
        //인덱스 값 초기화
        var index = -1
        //선택된 이미지들을 가져오고
        let selectedImages = ds.sectionModels[0].header
        //이미지가 선택되어 있으면 인덱스 값을 가져온다.
        if selectedImages.contains(image) {
        
            index = selectedImages.firstIndex(of: image) ?? -1
        }
        if index != -1 {
            cell.text.text = String(index + 1)
            cell.text.backgroundColor = UIColor.mainColor
        } else {
            cell.text.text = ""
            cell.text.backgroundColor = UIColor.clear
        }
        return cell
    } configureSupplementaryView: { ds, cv, kind, ip in
        let header = cv.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: ip) as! PhotoSelectorHeader
        header.images = ds.sectionModels[0].header
        header.pagerView.reloadData()
        return header
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        setupNavigationButtons()
        setupCollectionView()
        setupViewModel()
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}


extension PostUploadView {
    private func setupCollectionView() {
        self.collectionView.dataSource = nil
        self.collectionView.delegate = nil
        collectionView.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(PhotoSelectorHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        collectionView.rx.itemSelected
            .map { [weak self] indexPath -> UIImage? in
                return self?.dataSource[indexPath]
            }
            .subscribe(onNext: { [weak self] item in
                if let vm = self?.vm {
                    vm.seletedItem(value: item!)
                }
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
    }
    
    private func setupViewModel() {
        
        vm.items
            .asDriver()
            .drive(self.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        vm.updateItems()
        
        vm.isMultiSelected.bind { value in
            
            self.collectionView.reloadData()
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
        .disposed(by: disposeBag)
        
    }
    
    fileprivate func setupNavigationButtons() {
        navigationController?.navigationBar.tintColor = UIColor.mainColor
        navigationController?.title = "New Post"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
        
    }
    
    @objc func handleNext() {
        let sharePhotoController = SharePhotoController(images: vm.items.value[0].header)
        navigationController?.pushViewController(sharePhotoController, animated: true)
    }
    
    @objc func handleCancel() {
        vm.clear()
        dismiss(animated: true, completion: nil)
    }
}


extension PostUploadView: UICollectionViewDelegateFlowLayout {
    
    
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    
}

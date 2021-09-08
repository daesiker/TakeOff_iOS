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
        cell.photoImageView.image = ds.sectionModels[0].items[ip.item].image
        return cell
    } configureSupplementaryView: { ds, cv, kind, ip in
        let header = cv.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: ip) as! PhotoSelectorHeader
        header.images = ds.sectionModels[ip.section].header
        header.pagerView.reloadData()
        return header
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
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
            .map { [weak self] indexPath -> PostUpload? in
                return self?.dataSource[indexPath]
            }
            .subscribe(onNext: { [weak self] item in
                if let item = item {
                    dataSource.sectionModels[0].header.append(item)
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

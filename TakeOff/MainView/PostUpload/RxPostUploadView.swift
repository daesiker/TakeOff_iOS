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

class RxPostUploadView: UICollectionViewController {
    var images:Observable<[UIImage]> = Observable.just([])
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        
        images.asObservable()
            .flatMap{  _ -> Observable<[UIImage]> in
                self.tmp()
            }
            .bind(to: collectionView.rx.items(cellIdentifier: "cellId", cellType: PhotoSelectorCell.self)) { indexPath, element, cell in
                
                
            }
            .disposed(by: disposeBag)
        
    }
    
    fileprivate func assetsFetchOptions() -> PHFetchOptions {
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 30
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortDescriptor]
        return fetchOptions
    }
    
    func tmp() -> Observable<[UIImage]> {
        let allPhotos = PHAsset.fetchAssets(with: .image, options: self.assetsFetchOptions())
        var images:[UIImage] = []
        return Observable.create { observer in
            allPhotos.enumerateObjects { asset, count, stop in
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 200, height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options) { image, info in
                    if let image = image {
                        images.append(image)
                    }
                }
            }
            observer.onNext(images)
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    
}


class RxPostUploadViewModel {
    
    public let imageData: PublishSubject<[UIImage]> = PublishSubject()
    
    
    
    
    func fetchData() {
        
    }
    
}

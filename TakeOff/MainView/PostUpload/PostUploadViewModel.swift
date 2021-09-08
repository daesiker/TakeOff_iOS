//
//  PostUploadViewModel.swift
//  TakeOff
//
//  Created by Jun on 2021/09/06.
//

import Foundation
import RxSwift
import RxCocoa
import Photos

class PostUploadViewModel {
    static let instance = PostUploadViewModel()
    init() {}
    
    var items = BehaviorRelay<[PostUploadSectionModel]>(value: [])
    let isMultiSelected = BehaviorRelay<Bool>(value: false)
    let disposeBag = DisposeBag()
    
    func updateItems() {
        var section = PostUploadSectionModel()
        fetchPhotos().subscribe { result in
            switch result {
            case .next(let image):
                var postUpload = PostUpload(number: 0, image: image)
                if section.header.isEmpty {
                    postUpload.number += 1
                    section.header.append(postUpload)
                }
                section.items.append(postUpload)
            case .completed:
                self.items.accept([section])
            case .error(let error):
                print(error)
            }
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
    
    fileprivate func fetchPhotos() -> Observable<UIImage> {
        let allPhotos = PHAsset.fetchAssets(with: .image, options: assetsFetchOptions())
        
        return Observable.create { observe in
            allPhotos.enumerateObjects { asset, count, stop in
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 100, height: 100)
                let options = PHImageRequestOptions()
                options.deliveryMode = .highQualityFormat
                options.isSynchronous = true
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options) { image, info in
                    if let image = image {
                        observe.onNext(image)
                    }
                }
            }
            observe.onCompleted()
            return Disposables.create()
        }
    }
}


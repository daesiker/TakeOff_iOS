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
    var section = PostUploadSectionModel()
    
    func updateItems() {
        fetchPhotos().subscribe { result in
            switch result {
            case .next(let image):
                if self.section.header.isEmpty {
                    self.section.header.append(image)
                }
                self.section.items.append(image)
            case .completed:
                self.items.accept([self.section])
            case .error(let error):
                print(error)
            }
        }
        .disposed(by: disposeBag)
    }
    
    func seletedItem(value: UIImage) {
        if isMultiSelected.value {
            var index = -1
            let check = section.header.contains { post in
                if post == value {
                    index = section.header.firstIndex(of: post) ?? 0
                    return true
                }
                else { return false}
            }
            
            if check {
                if section.header.count != 1 {
                    section.header.remove(at: index)
                }
            } else {
                section.header.append(value)
            }
        } else {
            self.section.header = [value]
        }
        
        self.items.accept([self.section])
    }
    
    /**
        사진 파일 가져오기 옵션값 리턴
     */
    fileprivate func assetsFetchOptions() -> PHFetchOptions {
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 30
        
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortDescriptor]
        return fetchOptions
    }
    
    
    /**
     사진 App에 있는 사진 이미지를 Observable로 하나씩 리턴
     */
    fileprivate func fetchPhotos() -> Observable<UIImage> {
        let allPhotos = PHAsset.fetchAssets(with: .image, options: assetsFetchOptions())
        
        return Observable.create { observe in
            //여기서 이미지를 하나씩 뿌려줌
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
    
    func clear() {
        self.section = PostUploadSectionModel()
        self.items.accept([self.section])
        
        
    }
}


//
//  PhotoSelectorHeader.swift
//  TakeOff
//
//  Created by Jun on 2021/08/26.
//

import Foundation
import UIKit
import Then
import FSPagerView
import RxCocoa
import RxSwift

class PhotoSelectorHeader: UICollectionViewCell {
    var disposeBag = DisposeBag()
    var images:[PostUpload] = []
    let vm = PostUploadViewModel.instance
    
    let layoutView = UIView().then {
        $0.backgroundColor = .white
    }
    
    let multiSelectionButton = UIButton().then {
        $0.setImage(UIImage(named: "alarm_grey"), for: .normal)
    }
    
    let pagerView = FSPagerView().then {
        $0.transformer = FSPagerViewTransformer(type: .linear)
    }
    
    let pageControl = FSPageControl().then {
        $0.setStrokeColor(.gray, for: .normal)
        $0.setStrokeColor(UIColor.mainColor, for: .selected)
        $0.hidesForSinglePage = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setPagerView()
        setUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPagerView() {
        pagerView.delegate = self
        pagerView.dataSource = self
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        pageControl.contentHorizontalAlignment = .center
        pageControl.numberOfPages = self.images.count
    }
    
    func setUI() {
        addSubview(layoutView)
        layoutView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        layoutView.addSubview(pagerView)
        pagerView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.9)
        }
        
        layoutView.addSubview(multiSelectionButton)
        multiSelectionButton.snp.makeConstraints {
            $0.bottom.right.equalToSuperview().offset(-4)
            $0.width.height.equalToSuperview().multipliedBy(0.08)
        }
        
        layoutView.addSubview(pageControl)
        pageControl.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-4)
        }
    }
    
    func bind() {
        multiSelectionButton.rx.tap
            .scan(false) { (lastState, newValue) in
                !lastState
            }
            .bind(to: vm.isMultiSelected)
            .disposed(by: disposeBag)
        
        vm.isMultiSelected
            .subscribe(onNext: { value in
                self.multiSelectionButton.setImage(value ? UIImage(named: "alarm_blue") : UIImage(named: "alarm_grey"), for: .normal)
            })
            .disposed(by: disposeBag)
        
    }
    
}

extension PhotoSelectorHeader: FSPagerViewDelegate, FSPagerViewDataSource {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return images.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.image = images[index].image
        cell.imageView?.clipsToBounds = true
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.pageControl.currentPage = targetIndex
    }
}


//
//  HomeViewController.swift
//  TakeOff
//
//  Created by Jun on 2021/08/23.
//

import Foundation
import UIKit
import SnapKit
import Then

class HomeViewController: UIViewController {
    
    lazy var postCV:UICollectionView = {
       let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
}

extension HomeViewController {
    
    private func setUI() {
        view.backgroundColor = .white
        safeView.addSubview(postCV)
        postCV.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setCV() {
        self.postCV.dataSource = nil
        self.postCV.delegate = nil
        
    }
    
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    
}

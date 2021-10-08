//
//  PostListView.swift
//  TakeOff
//
//  Created by Jun on 2021/10/08.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class PostListView: UICollectionViewController {
    let cellId = "cellId"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

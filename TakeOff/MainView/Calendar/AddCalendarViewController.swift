//
//  AddCalendarViewController.swift
//  TakeOff
//
//  Created by Jun on 2022/06/06.
//

import UIKit

class AddCalendarViewController: UIViewController {
    
    let rightBarButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: nil)
    let leftBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: nil)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationButtons()
        setUI()
    }
   
}

extension AddCalendarViewController {
    
    fileprivate func setupNavigationButtons() {
        navigationController?.navigationBar.tintColor = UIColor.mainColor
        navigationController?.title = "New Post"
        navigationItem.rightBarButtonItem = rightBarButton
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    fileprivate func setUI() {
        view.backgroundColor = .white
    }
}

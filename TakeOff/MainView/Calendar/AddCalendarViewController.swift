//
//  AddCalendarViewController.swift
//  TakeOff
//
//  Created by Jun on 2022/06/06.
//

import UIKit
import Then
import RxSwift
import RxCocoa

class AddCalendarViewController: UIViewController {
    
    var vm = AddCalendarViewModel()
    
    let rightBarButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: nil)
    let leftBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: nil)
    
    let datePicker = UIDatePicker().then {
        $0.preferredDatePickerStyle = .inline
        $0.datePickerMode = .dateAndTime
        $0.locale = Locale(identifier: "ko-KR")
        $0.timeZone = .autoupdatingCurrent
        $0.tintColor = UIColor.mainColor
    }
    
    let locationLb = UILabel().then {
        $0.text = "장소"
        $0.font = UIFont(name: "NotoSansCJKkr-Medium", size: 16)
    }
    
    let locationTf = UITextField().then {
        $0.placeholder = "장소를 입력하세요."
        $0.borderStyle = .roundedRect
        $0.clearButtonMode = .whileEditing
    }
    
    let titleLb = UILabel().then {
        $0.text = "내용"
        $0.font = UIFont(name: "NotoSansCJKkr-Medium", size: 16)
    }
    
    let titleTf = UITextField().then {
        $0.placeholder = "내용을 입력하세요."
        $0.borderStyle = .roundedRect
        $0.clearButtonMode = .whileEditing
    }
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationButtons()
        setUI()
        bind()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
        
        safeView.addSubview(datePicker)
        datePicker.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.height.equalToSuperview().multipliedBy(0.6)
        }
        
        safeView.addSubview(locationLb)
        locationLb.snp.makeConstraints {
            $0.top.equalTo(datePicker.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(25)
        }
        
        safeView.addSubview(locationTf)
        locationTf.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-25)
            $0.top.equalTo(datePicker.snp.bottom).offset(8)
            $0.height.equalTo(40)
            $0.width.equalTo(290)
        }
        
        safeView.addSubview(titleLb)
        titleLb.snp.makeConstraints {
            $0.top.equalTo(locationLb.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(25)
        }
        
        safeView.addSubview(titleTf)
        titleTf.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-25)
            $0.top.equalTo(locationLb.snp.bottom).offset(33)
            $0.height.equalTo(40)
            $0.width.equalTo(290)
        }
        
    }
    
    fileprivate func bind() {
        
        leftBarButton.rx.tap.subscribe(onNext: {
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        locationTf.rx.text
            .orEmpty
            .skip(1)
            .bind(to: vm.input.locationObserver)
            .disposed(by: disposeBag)
        
        titleTf.rx.text
            .orEmpty
            .skip(1)
            .bind(to: vm.input.titleObserver)
            .disposed(by: disposeBag)
        
        datePicker.rx.controlEvent([.valueChanged])
            .map { self.datePicker.date.timeIntervalSince1970 }
            .bind(to: vm.input.dateObserver)
            .disposed(by: disposeBag)
        
        rightBarButton.rx.tap.bind(to: vm.input.postObserver)
            .disposed(by: disposeBag)
        
        vm.output.addPost.asSignal().emit(onNext: { _ in
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        vm.output.errorValid.asSignal()
            .emit(onNext: { error in
                let alertController = UIAlertController(title: "에러", message: error.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
                self.present(alertController, animated: true)
            }).disposed(by: disposeBag)
        
    }
}

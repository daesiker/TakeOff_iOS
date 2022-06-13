//
//  CalendarViewController.swift
//  TakeOff
//
//  Created by Jun on 2021/08/25.
//

import Foundation
import UIKit
import SnapKit
import Then
import FSCalendar
import RxSwift
import Firebase

class CalendarViewController: UIViewController {
    
    let calendarLayoutView = UIView().then {
        $0.backgroundColor = UIColor.rgb(red: 251, green: 229, blue: 187)
    }
    
    let tableLayoutView = UIView().then {
        $0.backgroundColor = .white
    }
    
    lazy var calendarView: FSCalendar = {
        let calendar = FSCalendar(frame: .zero)
        calendar.delegate = self
        calendar.dataSource = self
        calendar.register(FSCalendarCell.self, forCellReuseIdentifier: "calCell")
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.appearance.weekdayFont = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        calendar.appearance.weekdayTextColor = UIColor.rgb(red: 188, green: 131, blue: 92)
        calendar.placeholderType = .fillHeadTail
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        calendar.headerHeight = 0
        calendar.appearance.todayColor = .clear
        calendar.appearance.titleTodayColor = UIColor.rgb(red: 255, green: 92, blue: 20)
        calendar.appearance.todaySelectionColor = .clear
        calendar.appearance.selectionColor = UIColor.rgb(red: 255, green: 142, blue: 85)
        calendar.appearance.titleSelectionColor = .white
        calendar.appearance.eventDefaultColor = UIColor.rgb(red: 255, green: 161, blue: 102)
        calendar.appearance.eventSelectionColor = UIColor.rgb(red: 255, green: 161, blue: 102)
        calendar.scrollEnabled = false
        return calendar
    }()
    
    let leftBt = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "calendar_left_bt"), for: .normal)
    }
    
    let titleLb = UILabel().then {
        $0.text = "2022.02"
        $0.font = UIFont(name: "AppleSDGothicNeoEB", size: 21)
        $0.textColor = UIColor.rgb(red: 164, green: 97, blue: 61)
    }
    
    let rightBt = UIButton(type: .custom).then {
        $0.setImage(UIImage(named: "calendar_right_bt"), for: .normal)
    }
    
    let addPostBt = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "plus.circle.fill")?.withTintColor(UIColor.mainColor, renderingMode: .alwaysOriginal), for: .normal)
    }
    
    lazy var collectionView:UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CalendarCell.self, forCellWithReuseIdentifier: "colCell")
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    let disposeBag = DisposeBag()
    let refreshControl = UIRefreshControl()
    
    var tableData:[CalendarPost] = []
    var calendarData:[String: [CalendarPost]] = [:]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bind()
        setTitle()
        fetchData()
    }
}

extension CalendarViewController {
    
    private func setUI() {
        view.backgroundColor = .white
        
        safeView.addSubview(calendarLayoutView)
        calendarLayoutView.snp.makeConstraints {
            $0.top.equalTo(self.view.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.6)
        }
        
        calendarLayoutView.addSubview(leftBt)
        leftBt.snp.makeConstraints {
            $0.top.equalTo(safeView.snp.top)
            $0.leading.equalToSuperview().offset(26)
        }
        
        calendarLayoutView.addSubview(titleLb)
        titleLb.snp.makeConstraints {
            $0.top.equalTo(safeView.snp.top)
            $0.leading.equalTo(leftBt.snp.trailing).offset(1)
        }
        
        calendarLayoutView.addSubview(rightBt)
        rightBt.snp.makeConstraints {
            $0.top.equalTo(safeView.snp.top)
            $0.leading.equalTo(titleLb.snp.trailing).offset(1)
        }
        
        calendarLayoutView.addSubview(calendarView)
        calendarView.snp.makeConstraints {
            $0.top.equalTo(leftBt.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(safeView.snp.height).multipliedBy(0.5)
        }
        
        safeView.addSubview(tableLayoutView)
        tableLayoutView.snp.makeConstraints {
            $0.top.equalTo(calendarLayoutView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        collectionView.refreshControl = refreshControl
        tableLayoutView.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        safeView.addSubview(addPostBt)
        addPostBt.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.width.height.equalTo(40)
        }
    }
    
    private func bind() {
        
        addPostBt.rx.tap.subscribe(onNext: {
            let vc = AddCalendarViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalTransitionStyle = .flipHorizontal
            self.present(nav, animated: true)
        }).disposed(by: disposeBag)
        
        leftBt.rx.tap.subscribe(onNext: {
            let _calendar = Calendar.current
            var dateComponents = DateComponents()
            dateComponents.month = -1 // For prev button
            self.calendarView.currentPage = _calendar.date(byAdding: dateComponents, to: self.calendarView.currentPage)!
            self.calendarView.setCurrentPage(self.calendarView.currentPage, animated: true)
            self.setTitle()
            self.calendarView.reloadData()
        }).disposed(by: disposeBag)
        
        rightBt.rx.tap.subscribe(onNext: {
            
            let _calendar = Calendar.current
            var dateComponents = DateComponents()
            dateComponents.month = 1
            self.calendarView.currentPage = _calendar.date(byAdding: dateComponents, to: self.calendarView.currentPage)!
            self.calendarView.setCurrentPage(self.calendarView.currentPage, animated: true)
            self.setTitle()
            self.calendarView.reloadData()
        }).disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent([.valueChanged]).subscribe(onNext: {
            self.fetchData()
        }).disposed(by: disposeBag)
    }
    
    func setTitle() {
        let date = calendarView.currentPage
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM"
        let title = dateFormatter.string(from: date)
        titleLb.text = title
    }
    
    
    func fetchData() {
        Database.database().reference().child("calendars").observeSingleEvent(of: .value) { (snapshot) in
            
            if let userDictionary = snapshot.value as? [String:Any] {
                for (_, value) in userDictionary {
                    let data = CalendarPost(value as! [String : Any])
                    if data.userName == User.loginedUser.name || User.loginedUser.follower.contains(data.userName) {
                        let date = Date(timeIntervalSince1970: data.date)
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy.MM.dd"
                        let title = dateFormatter.string(from: date)
                        
                        var currentDate = ""
                        
                        if let selectedDate = self.calendarView.selectedDate {
                            currentDate = dateFormatter.string(from: selectedDate)
                        } else {
                            currentDate = dateFormatter.string(from: Date())
                        }
                        
                        
                        print("\(currentDate), \(title)")
                        
                        if title == currentDate {
                            self.tableData.append(data)
                        }
                        
                        if let _ = self.calendarData[title] {
                            self.calendarData[title]!.append(data)
                        } else {
                            self.calendarData[title] = [data]
                        }
                        
                    }
                }
                
                
                
                DispatchQueue.main.async {
                    self.calendarView.reloadData()
                    self.collectionView.reloadData()
                }
                
            }
        }
    }
    
    
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "calCell", for: date, at: position)
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        var count = 0
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let title = dateFormatter.string(from: date)
        
        
        for (k, v) in calendarData {
            if k == title {
                count = v.count > 3 ? 3 : v.count
            }
        }
        return count
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let title = dateFormatter.string(from: date)
        
        if let posts = calendarData[title] {
            tableData = posts
        } else {
            tableData = []
        }
        collectionView.reloadData()
    }
    
}

extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colCell", for: indexPath) as! CalendarCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        var currentDate = ""
        if let selectedDate = self.calendarView.selectedDate {
            currentDate = dateFormatter.string(from: selectedDate)
        } else {
            currentDate = dateFormatter.string(from: Date())
        }
        
        if let posts = calendarData[currentDate] {
            cell.calendarPost = posts[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 17
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 17
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width - 40
        return CGSize(width: width, height: 144)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    
    
}

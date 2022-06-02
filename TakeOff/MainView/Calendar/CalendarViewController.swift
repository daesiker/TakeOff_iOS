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

class CalendarViewController: UIViewController {
    
    let calendarLayoutView = UIView().then {
        $0.backgroundColor = .clear
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
        
        
    }
}

extension CalendarViewController {
    
    private func setUI() {
        view.backgroundColor = UIColor.rgb(red: 251, green: 229, blue: 187)
        
        safeView.addSubview(calendarLayoutView)
        calendarLayoutView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.6)
        }
        
        calendarLayoutView.addSubview(leftBt)
        leftBt.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(26)
        }
        
        calendarLayoutView.addSubview(titleLb)
        titleLb.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(leftBt.snp.trailing).offset(1)
        }
        
        calendarLayoutView.addSubview(rightBt)
        rightBt.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(titleLb.snp.trailing).offset(1)
        }
        
        calendarLayoutView.addSubview(calendarView)
        calendarView.snp.makeConstraints {
            $0.top.equalTo(leftBt.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(safeView.snp.height).multipliedBy(0.5)
        }
        
        view.addSubview(tableLayoutView)
        tableLayoutView.snp.makeConstraints {
            $0.top.equalTo(calendarLayoutView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.view.snp.bottom)
        }
        
        
        
    }
    
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "calCell", for: date, at: position)
        return cell
    }
    
}

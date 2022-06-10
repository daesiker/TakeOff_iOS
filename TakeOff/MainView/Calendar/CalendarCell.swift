//
//  CalendarTableViewCell.swift
//  TakeOff
//
//  Created by Jun on 2022/06/03.
//

import UIKit
import Then

class CalendarCell: UICollectionViewCell {
    
    var calendarPost:CalendarPost? {
        didSet {
            setData()
        }
    }
    
    let profileImgView = UIImageView(image: UIImage(named: "seoul"))
    
    let nameLb = UILabel().then {
        $0.text = "서울시"
        $0.textColor = UIColor.rgb(red: 122, green: 122, blue: 122)
        $0.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16)
    }
    
    let titleLb = UILabel().then {
        $0.text = "청년고용지원"
        $0.textColor = UIColor.rgb(red: 38, green: 38, blue: 38)
        $0.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 19)
    }
    
    let locationLb = UILabel().then {
        $0.text = "최대 250만원 지원"
        $0.textColor = UIColor.rgb(red: 255, green: 126, blue: 68)
        $0.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
    }
    
    let dayLb = UILabel().then {
        $0.text = "2021.12.31까지"
        $0.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 14)
        $0.textColor = UIColor.rgb(red: 148, green: 148, blue: 148)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 30
    }
    
    private func setData() {
        if let calendarPost = calendarPost {
            nameLb.text = calendarPost.userName
            titleLb.text = calendarPost.title
            locationLb.text = calendarPost.location
            
            let date = Date(timeIntervalSince1970: calendarPost.date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy년 MM월 dd일 hh시 MM분"
            
            let stringDate = dateFormatter.string(from: date)
            dayLb.text = stringDate
        }
    }
    
    private func setupView() {
        backgroundColor = UIColor.rgb(red: 255, green: 246, blue: 232)
        addSubview(profileImgView)
        profileImgView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.leading.equalToSuperview().offset(19)
            $0.width.height.equalTo(21)
        }
        
        addSubview(nameLb)
        nameLb.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.leading.equalTo(profileImgView.snp.trailing).offset(7)
            $0.trailing.equalToSuperview().offset(-19)
        }
        
        addSubview(titleLb)
        titleLb.snp.makeConstraints {
            $0.top.equalTo(nameLb.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(22)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        addSubview(locationLb)
        locationLb.snp.makeConstraints {
            $0.top.equalTo(titleLb.snp.bottom).offset(5)
            $0.leading.equalToSuperview().offset(22)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        addSubview(dayLb)
        dayLb.snp.makeConstraints {
            $0.top.equalTo(locationLb.snp.bottom).offset(5)
            $0.leading.equalToSuperview().offset(22)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
    }
    
}

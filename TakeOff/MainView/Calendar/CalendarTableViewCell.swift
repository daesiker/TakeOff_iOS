//
//  CalendarTableViewCell.swift
//  TakeOff
//
//  Created by Jun on 2022/06/03.
//

import UIKit
import Then

class CalendarTableViewCell: UITableViewCell {
    
    let profileImage = UIImageView().then {
        $0.backgroundColor = .red
    }
    
    let nemaLb = UILabel().then {
        $0.text = "청년고용지원"
        $0.textColor = UIColor.rgb(red: 38, green: 38, blue: 38)
        $0.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 19)
    }
    
    let titleLb = UILabel().then {
        $0.text = "adsf"
        $0.textColor = UIColor.rgb(red: 255, green: 126, blue: 68)
        $0.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 20)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

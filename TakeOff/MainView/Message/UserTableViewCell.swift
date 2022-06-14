//
//  UserTableViewCell.swift
//  TakeOff
//
//  Created by Jun on 2022/06/14.
//

import UIKit
import Then
import Firebase

class UserTableViewCell: UITableViewCell {
    
    var message:Message? {
        didSet {
            setupNameAndProfileImage()
            
            detailTextLabel?.text = message?.text
            detailTextLabel?.textColor = .black
            if let seconds = message?.timestamp?.doubleValue {
                let timestampDate = Date(timeIntervalSince1970: seconds)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                timeLabel.text = dateFormatter.string(from: timestampDate)
            }
        }
    }
    
    let profileImageView = CustomImageView().then {
        $0.layer.cornerRadius = 24
        $0.layer.masksToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    
    let timeLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 13)
        $0.textColor = UIColor.darkGray
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    fileprivate func setUI() {
        self.backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(8)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(48)
        }
        
        addSubview(timeLabel)
        timeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.trailing.equalToSuperview().offset(-18)
            $0.width.equalTo(100)
            $0.height.equalTo(self.textLabel!.snp.height)
        }
    }
    
    fileprivate func setupNameAndProfileImage() {
        
        if let id = message?.chatPartnerId() {
            let ref = Database.database().reference().child("users").child(id)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: Any] {
                    self.textLabel?.text = dictionary["username"] as? String
                    
                    if let profileImageUrl = dictionary["profileImageUrl"] as? String {
                        self.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
                    }
                }
                
            }, withCancel: nil)
        }
    }
    
}

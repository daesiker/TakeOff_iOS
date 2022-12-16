//
//  ChatInputContainerView.swift
//  TakeOff
//
//  Created by Jun on 2022/06/23.
//

import UIKit
import Then

class ChatInputContainerView: UIView, UITextFieldDelegate {

    weak var chatLogViewController: ChatLogViewController? {
        didSet {
            
        }
    }
    
    lazy var inputTextField = UITextField().then {
        $0.placeholder = "Enter message..."
        $0.delegate = self
    }
    
    let uploadImageView = UIImageView().then {
        $0.isUserInteractionEnabled = true
        $0.image = UIImage(named: "upload_image_icon")
    }
    
    let sendButton = UIButton(type: .system).then {
        $0.setTitle("Send", for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setUI() {
        backgroundColor = .white
        
        addSubview(uploadImageView)
        uploadImageView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(44)
        }
        
        addSubview(sendButton)
        sendButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //chatLogViewController?.handleSend()
        return true
    }
    
}


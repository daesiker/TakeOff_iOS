//
//  MessageViewController.swift
//  TakeOff
//
//  Created by Jun on 2021/08/25.
//

import Foundation
import UIKit
import SnapKit
import Then
import Firebase

class MessageViewController: UITableViewController {
    
    let cellId = "cellId"
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
        
    }
    
    fileprivate func setUI() {
        let image = UIImage(named: "new_message_icon")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem?.tintColor = .orange
        
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    
    func observeUserMessages() {
        
        let uid = User.loginedUser.uid
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            
            let userId = snapshot.key
            Database.database().reference().child("user-messages").child(uid).child(userId).observe(.childAdded, with: { (snapshot) in
                
                let messageId = snapshot.key
                self.fetchMessageWithMessageId(messageId)
                
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    fileprivate func fetchMessageWithMessageId(_ messageId: String) {
        let messagesReference = Database.database().reference().child("messages").child(messageId)
        
        messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message(dictionary)
                if let chatPartnerId = message.chatPartnerId() {
                    self.messagesDictionary[chatPartnerId] = message
                }
                
                //self.attemptReloadOfTable()
            }
            
        }, withCancel: nil)
    }
    
    
    
    func setupNavBarWithUser(_ user: User) {
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        
        observeUserMessages()
        
        navigationItem.title = "Message"
        
    }
    
    func showChatControllerForUser(_ user: User) {
//        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
//        chatLogController.user = user
//        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
}


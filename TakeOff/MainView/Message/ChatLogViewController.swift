//
//  ChatLogViewController.swift
//  TakeOff
//
//  Created by Jun on 2022/06/22.
//

import UIKit
import Then
import Firebase
import MobileCoreServices
import AVFoundation

class ChatLogViewController: UICollectionViewController {
    
    var user: User? {
        didSet {
            navigationItem.title = user?.name
            //observeMessages()
        }
    }
    
    var messages:[Message] = []
    let cellId = "cellId"

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func observeMessages() {
        
        let uid = User.loginedUser.uid
        guard let toId = user?.uid else { return }
        
        let userMessagesRef = Database.database().reference().child("user-messages").child(uid).child(toId)
        
        userMessagesRef.observe(.childAdded) { snapshot in
            let messageId = snapshot.key
            let messagesRef = Database.database().reference().child("messages").child(messageId)
            
            messagesRef.observeSingleEvent(of: .value) { snapshot in
                guard let dictionary = snapshot.value as? [String:AnyObject] else { return }
                
                self.messages.append(Message(dictionary))
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            }
        }
    }

    

}

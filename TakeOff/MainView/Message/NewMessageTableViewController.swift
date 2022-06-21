//
//  NewMessageTableViewController.swift
//  TakeOff
//
//  Created by Jun on 2022/06/20.
//

import UIKit
import Firebase
import Then

class NewMessageTableViewController: UITableViewController {
    
    let cellId = "cellId"
    var filteredUsers:[User] = []
    var users:[User] = []
    var messageViewController:MessageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        fetchUsers()
    }
    
    fileprivate func setUI() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem?.tintColor = .orange
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func fetchUsers() {
        let ref = Database.database().reference().child("users")
        
        ref.observeSingleEvent(of: .value) { snapshot in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            dictionaries.forEach { (key, value) in
                
                if key == User.loginedUser.uid {
                    return
                }
                
                guard let userDictionary = value as? [String: Any] else { return }
                
                let user = User(uid: key, dbInfo: userDictionary)
                self.users.append(user)
            }
            
            self.users.sort { u1, u2 in
                return u1.name.compare(u2.name) == .orderedAscending
            }
            
            self.filteredUsers = self.users
            self.tableView.reloadData()
            
        }
    }
    
    
}

extension NewMessageTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserTableViewCell
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            let user = self.users[indexPath.row]
            self.messageViewController?.showChatControllerForUser(user)
        }
    }
    
    
}


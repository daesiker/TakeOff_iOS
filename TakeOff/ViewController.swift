//
//  ViewController.swift
//  TakeOff
//
//  Created by Jun on 2021/07/17.
//

import UIKit
import Firebase
import RxSwift

class ViewController: UIViewController {
    private let logoImageView: UIImageView = {
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 220, height: 220))
        imgView.image = UIImage(named: "logo")
        return imgView
    }()
    
    private let backgroundImageView: UIImageView = {
        let imgView = UIImageView(frame: CGRect())
        imgView.image = UIImage(named: "background")
        return imgView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroundImageView)
        backgroundImageView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        view.addSubview(logoImageView)
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        logoImageView.center = view.center
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.animate()
        }
    }
    
    private func animate() {
        UIView.animate(withDuration: 1, animations: {
            let size = self.view.frame.size.width * 1.5
            let difX = size - self.view.frame.size.width
            let difY = self.view.frame.size.height - size
            
            self.logoImageView.frame = CGRect(x: -(difX/2), y: (difY/2), width: size, height: size)
        })
        
        UIView.animate(withDuration: 1.5, animations: {
            self.logoImageView.alpha = 0
        }, completion: { done in
            
            if let id = UserDefaults.standard.string(forKey: "email"),
               let pw = UserDefaults.standard.string(forKey: "pw") {
                
                Auth.auth().signIn(withEmail: id, password: pw) { auth, error in
                    if let _ = error {
                        self.goToLoginView()
                    }
                    
                    if let uid = Auth.auth().currentUser?.uid {
                        let ref = Database.database().reference()
                        
                        ref.child("users").child(uid).observeSingleEvent(of: .value) { snapshot in
                            let userData = snapshot.value as? [String: Any] ?? [:]
                            
                            let user = User.init(uid: uid, dbInfo: userData)
                            
                            User.loginedUser = user
                            //self.goToMainView()
                            self.goToLoginView()
                            
                        }
                    }
                    
                }
            } else {
                self.goToLoginView()
            }
        })
    }
    
    
    private func goToLoginView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let viewController = LoginViewController()
            let navController = UINavigationController(rootViewController: viewController)
            navController.isNavigationBarHidden = true
            navController.modalTransitionStyle = .crossDissolve
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true)
            
        }
    }
    
    private func goToMainView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let viewController = MainTabViewController()
            let navController = UINavigationController(rootViewController: viewController)
            navController.isNavigationBarHidden = true
            navController.modalTransitionStyle = .crossDissolve
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true)
            
        }
    }
}


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
    var handle: AuthStateDidChangeListenerHandle!
    let disposeBag = DisposeBag()
    let userModel = UserModel()
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
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(self.handle!)
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
            if done {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.handle = Auth.auth().addStateDidChangeListener { auth, user in
                        if let user = user {
                            // UserModel을 싱글톤?...
                            self.userModel.saveUser(uid: user.uid).asDriver(onErrorJustReturn: User()).drive { (user:User) in
                                let viewController = MainTabViewController()
                                let navController = UINavigationController(rootViewController: viewController)
                                navController.isNavigationBarHidden = true
                                navController.modalTransitionStyle = .crossDissolve
                                navController.modalPresentationStyle = .fullScreen
                                self.present(navController, animated: true)
                            }.disposed(by: self.disposeBag)
                        } else {
                            let viewController = LoginView()
                            let navController = UINavigationController(rootViewController: viewController)
                            navController.isNavigationBarHidden = true
                            navController.modalTransitionStyle = .crossDissolve
                            navController.modalPresentationStyle = .fullScreen
                            self.present(navController, animated: true) 
                        }           
                    }
                }
            }
        })
    }
}


//
//  ViewController.swift
//  TakeOff
//
//  Created by Jun on 2021/07/17.
//

import UIKit

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
            if done {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    
//                    let vc = MainTabViewController()
//                    vc.modalPresentationStyle = .fullScreen
//                    vc.modalTransitionStyle = .crossDissolve
//                    self.present(vc, animated: true)
                    let viewController = LoginView()
                    let navController = UINavigationController(rootViewController: viewController)
                    navController.isNavigationBarHidden = true
                    navController.modalTransitionStyle = .crossDissolve
                    navController.modalPresentationStyle = .fullScreen
                    self.present(navController, animated: true)
                }
            }
        })
    }
}


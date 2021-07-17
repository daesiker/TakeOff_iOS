//
//  HomeViewController.swift
//  TakeOff
//
//  Created by Jun on 2021/07/17.
//

import UIKit

class LoginViewController: UIViewController {

    let label:UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.font = .systemFont(ofSize: 24, weight: .bold)
        lb.text = "Hello!"
        lb.textColor = UIColor.black
        return lb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
        label.center = view.center
        view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

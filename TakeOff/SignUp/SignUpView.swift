//
//  SignUpView.swift
//  TakeOff
//
//  Created by Jun on 2021/08/02.
//

import Foundation
import UIKit

protocol SignUpViewAttributes {
    func setUI()
}

class SignUpView: UIViewController {
    
    
    let backgroundView: UIView = {
        let view = UIImageView(image: UIImage(named: "background"))
        return view
    }()
    
    let chooseLabel: UILabel = {
       let lb = UILabel()
        lb.text = "가입 유형을 선택해주세요"
        lb.textColor = UIColor.mainColor
        lb.font = UIFont.boldSystemFont(ofSize: 14)
        return lb
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
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

extension SignUpView: SignUpViewAttributes {
    
    func setUI() {
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
}

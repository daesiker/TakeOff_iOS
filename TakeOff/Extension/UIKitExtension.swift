//
//  Extension.swift
//  TakeOff
//
//  Created by Jun on 2021/08/02.
//

import UIKit
import RxDataSources

extension UIColor {
    //rgb 컬러 정수로 계산하는 UIColor Extension
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
    
    //Signiture Color
    static var mainColor = UIColor.rgb(red: 255, green: 85, blue: 54)
    
    static var enableMainColor = UIColor.rgb(red: 250, green: 224, blue: 212)
}

extension UIViewController {
    var safeView:UIView {
        get{
            guard let safeView = self.view.viewWithTag(Int(INT_MAX)) else {
                let guide = self.view.safeAreaLayoutGuide
                let view = UIView()
                view.tag = Int(INT_MAX)
//                view.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
                self.view.addSubview(view)
                view.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    view.topAnchor.constraint(equalTo: guide.topAnchor),
                    view.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
                    view.leftAnchor.constraint(equalTo: guide.leftAnchor, constant:20.0),
                    view.rightAnchor.constraint(equalTo: guide.rightAnchor, constant:-20.0)
                ])
                return view
            }
            return safeView
        }
    }
}

extension UIButton {
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))
        
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
         
        self.setBackgroundImage(backgroundImage, for: state)
    }
}



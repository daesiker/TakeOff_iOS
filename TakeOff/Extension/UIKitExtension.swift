//
//  Extension.swift
//  TakeOff
//
//  Created by Jun on 2021/08/02.
//

import UIKit

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
                
                self.view.addSubview(view)
                view.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    view.topAnchor.constraint(equalTo: guide.topAnchor),
                    view.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
                    view.leftAnchor.constraint(equalTo: guide.leftAnchor),
                    view.rightAnchor.constraint(equalTo: guide.rightAnchor)
                ])
                return view
            }
            return safeView
        }
    }
}

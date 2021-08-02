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

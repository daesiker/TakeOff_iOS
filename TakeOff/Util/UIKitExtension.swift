//
//  Extension.swift
//  TakeOff
//
//  Created by Jun on 2021/08/02.
//

import UIKit
import RxDataSources
import Then

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
        //get 방식을 통해 읽기전용으로 sageView 구현
        get{
            guard let safeView = self.view.viewWithTag(Int(INT_MAX)) else {
                let guide = self.view.safeAreaLayoutGuide
                let view = UIView()
                view.tag = Int(INT_MAX)
                //view.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
                self.view.addSubview(view)
                view.snp.makeConstraints {
                    $0.edges.equalTo(guide)
                }
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


extension UITextField {
    
    func setLeft(image: UIImage, withPadding padding: CGFloat = 0) {
        let wrapperView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 31, height: 21))
        let imageView = UIImageView(frame: CGRect.init(x: 10, y: 0, width: 21, height: 21))
        
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        wrapperView.addSubview(imageView)
        
        leftView = wrapperView
        leftViewMode = .always
        
    }
    
    func setErrorRight() {
        let wrapperView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: bounds.height, height: bounds.height))
        let imageView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 21, height: 20))
        
        imageView.image = UIImage(named: "tfAlert")
        imageView.contentMode = .scaleAspectFit
        wrapperView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        rightView = wrapperView
        rightViewMode = .always
        
    }
    
    func setRight() {
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(UIImage(named: "tfCancel")!, for: .normal)
        clearButton.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        clearButton.addTarget(self, action: #selector(UITextField.clear), for: .touchUpInside)
        self.addTarget(self, action: #selector(UITextField.displayClearButtonIfNeeded), for: .editingDidBegin)
        self.addTarget(self, action: #selector(UITextField.displayClearButtonIfNeeded), for: .editingChanged)
        self.rightView = clearButton
        self.rightViewMode = .whileEditing
    }
    
    @objc private func displayClearButtonIfNeeded() {
        self.rightView?.isHidden = (self.text?.isEmpty) ?? true
    }
    
    @objc private func clear(sender: AnyObject) {
        self.text = ""
        sendActions(for: .editingChanged)
    }
    
}

extension UIScrollView {
    
    func updateContentSize() {
        let unionCalculatedTotalRect = recursiveUnionInDepthFor(view: self)
        
        self.contentSize = CGSize(width: self.frame.width, height: unionCalculatedTotalRect.height + 46)
    }
    
    private func recursiveUnionInDepthFor(view: UIView) -> CGRect {
        var totalRect:CGRect = .zero
        
        for subView in view.subviews {
            totalRect = totalRect.union(recursiveUnionInDepthFor(view: subView))
        }
        
        return totalRect.union(view.frame)
    }
    
    
}

let imageCache1 = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(_ urlString: String) {
        self.image = nil
        
        if let cachedImage = imageCache1.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with: url!) { data, response, error in
            if let error = error {
                //에러처리
                print(error)
                return
            }
            
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!) {
                    imageCache1.setObject(downloadedImage, forKey: urlString as AnyObject)
                    
                    self.image = downloadedImage
                }
            }
        }.resume()
        
    }
    
}

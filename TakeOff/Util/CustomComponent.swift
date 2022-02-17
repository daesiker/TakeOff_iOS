//
//  CustomComponent.swift
//  TakeOff
//
//  Created by Jun on 2022/01/05.
//

import Foundation
import UIKit

class CustomTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(image: UIImage, text: String) {
        self.init()
        self.backgroundColor = UIColor.rgb(red: 243, green: 243, blue: 243)
        self.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor : UIColor.rgb(red: 194, green: 194, blue: 194)])
        self.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
        self.layer.cornerRadius = 20.0
        self.layer.masksToBounds = true
        self.isUserInteractionEnabled = true
        self.delegate = self
        self.textColor = UIColor.rgb(red: 65, green: 65, blue: 65)
        self.setLeft(image: image)
        self.setRight()
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 12, left: 40, bottom: 13, right: 40))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: UIEdgeInsets.init(top: 12, left: 9, bottom: 13, right: 9))
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: UIEdgeInsets.init(top: 12, left: 9, bottom: 13, right: 9))
    }
    
}

extension CustomTextField: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.backgroundColor = UIColor.rgb(red: 252, green: 245, blue: 235)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.backgroundColor = UIColor.rgb(red: 243, green: 243, blue: 243)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}


class CustomImageView: UIImageView {
    
    var imageUrl:String?
    
    func loadImage(urlString: String) {
        imageUrl = urlString
        self.image = nil
        
        
        
    }
    
    
    
}

let imageCache1 = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(_ urlString: String) {
        
        self.image = nil
        
        //check cache for image first
        if let cachedImage = imageCache1.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        //otherwise fire off a new download
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            //download hit an error so lets return out
            if error != nil {
                print(error ?? "")
                return
            }
            
            DispatchQueue.main.async(execute: {
                
                if let downloadedImage = UIImage(data: data!) {
                    imageCache1.setObject(downloadedImage, forKey: urlString as AnyObject)
                    
                    self.image = downloadedImage
                }
            })
            
        }).resume()
    }
    
    
}

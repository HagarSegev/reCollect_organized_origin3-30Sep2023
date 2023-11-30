//
//  CustomInfoPlaceholder.swift
//  reCollect_organized
//
//  Created by Daniel Pikovsky Yoffe on 13/07/2023.
//

import UIKit

class CustomInfoPlaceholder: UITextField {
    let buttonHeight: CGFloat = 53 * (UIScreen.main.bounds.height / 844)
    let buttonWidth: CGFloat = 297 * (UIScreen.main.bounds.height / 844)
    
    init(placeholder: String) {
        super.init(frame: .zero)
        
        self.placeholder = placeholder
        self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1) // white
        self.font = UIFont.systemFont(ofSize: 16)
        self.textColor = .black
        self.textInputMode
        self.textAlignment = .left
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 0
        self.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor // black
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 32 * (UIScreen.main.bounds.width / 390), height: self.bounds.height))
        self.leftViewMode = .always
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: self.buttonWidth, height: self.buttonHeight)
    }
}

//
//  CustomSignInButton.swift
//  reCollect_organized
//
//  Created by Daniel Pikovsky Yoffe on 11/07/2023.
//

import UIKit

class CustomSignInButton: UIButton {
    let buttonHeight: CGFloat = 53 * (UIScreen.main.bounds.height / 844)
    let buttonWidth: CGFloat = 297 * (UIScreen.main.bounds.height / 844)
    let imageSize: CGFloat = 28 * (UIScreen.main.bounds.height / 844)
    let distFromLeftCorner = 80 * (UIScreen.main.bounds.width / 390)
    var behavior: ButtonBehavior = ScaleBehaviorBigObj()

    private var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    init(title: String, logoName: String) {
        super.init(frame: .zero)
        behavior.apply(to: self)
        
        // Set up the logo
        if let logoImage = UIImage(named: logoName) {
            logoImageView.image = logoImage
        }
        
        self.addSubview(logoImageView)
        
        // Constraints for logo
        NSLayoutConstraint.activate([
            logoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            logoImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: imageSize),
            logoImageView.heightAnchor.constraint(equalToConstant: imageSize)
        ])
        
        self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1) // white
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        self.setTitleColor(.black, for: .normal)
        self.contentHorizontalAlignment = .left
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: distFromLeftCorner, bottom: 0, right: 0)
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 0 // no conture
        self.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor // black
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: self.buttonWidth, height: self.buttonHeight)
    }
}

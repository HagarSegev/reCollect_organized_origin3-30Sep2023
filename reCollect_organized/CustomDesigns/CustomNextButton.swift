//
//  CustomNextButton.swift
//  reCollect_organized
//
//  Created by Daniel Pikovsky Yoffe on 20/07/2023.
//

import UIKit

class CustomNextButton: UIButton {
    
    private var height: CGFloat
    private var width: CGFloat
    private var behavior: ButtonBehavior
    
    var buttonText: String? {
        didSet {
            setTitle(buttonText, for: .normal)
        }
    }

    init(behavior: ButtonBehavior, width: CGFloat? = nil, height: CGFloat? = nil) {
        self.height = height ?? 53 * (UIScreen.main.bounds.height / 844)
        self.width = width ?? (297 * (UIScreen.main.bounds.height / 844)) / 2
        self.behavior = behavior

        super.init(frame: .zero)
        self.buttonText = "Next" // Default text
        //self.setTitle("Next", for: .normal)
        setTitle(buttonText, for: .normal)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        self.backgroundColor = UIColor.black
        self.setTitleColor(UIColor.white, for: .normal)
        self.layer.cornerRadius = 10
        self.alpha = 0
        self.translatesAutoresizingMaskIntoConstraints = false
        
        behavior.apply(to: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: height)
    }
    
    func animateButton(shouldShow: Bool) {
        UIView.animate(withDuration: 1) {
            self.alpha = shouldShow ? 1 : 0
        }
        self.isUserInteractionEnabled = shouldShow
    }
}


class CustomreadyButton: UIButton {
    
    private var height: CGFloat
    private var width: CGFloat
    private var behavior: ButtonBehavior
    
    init(behavior: ButtonBehavior, width: CGFloat? = nil, height: CGFloat? = nil) {
        self.height = height ?? 53 * (UIScreen.main.bounds.height / 844)
        self.width = width ?? (297 * (UIScreen.main.bounds.height / 844)) / 2
        self.behavior = behavior
        super.init(frame: .zero)
        
        self.setTitle("I'm Ready", for: .normal)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        self.backgroundColor = UIColor.black
        self.setTitleColor(UIColor.white, for: .normal)
        self.layer.cornerRadius = 10
        self.alpha = 0
        self.translatesAutoresizingMaskIntoConstraints = false
        
        behavior.apply(to: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: height)
    }
    
    func animateButton(shouldShow: Bool) {
        UIView.animate(withDuration: 1) {
            self.alpha = shouldShow ? 1 : 0
        }
        self.isUserInteractionEnabled = shouldShow
    
    }
    
    func updateHeightToThird() {
        let newHeight = self.height / 3
        self.height = newHeight
        invalidateIntrinsicContentSize()
    }
    
}

class CustomVButton: UIButton {
    
    
    private let buttonSize: CGFloat = 65.0 // Change the button size to make the circle bigger
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let bcolor = UIColor(red: 78/255, green: 175/255, blue: 196/255, alpha: 1.0)
        self.layer.borderColor = bcolor.cgColor
        self.layer.borderWidth = 4.0 // Adjust the width of the stroke as needed
        self.layer.cornerRadius = buttonSize / 2
        self.clipsToBounds = true
        self.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        self.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        
        // Set the title "V" for the button
        self.setTitle("V", for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 38.0) // Adjust the font size as needed
        self.setTitleColor(bcolor, for: .normal) // Set the text color
        self.titleLabel?.adjustsFontSizeToFitWidth = true // Adjust text size to fit within the button
        self.titleLabel?.minimumScaleFactor = 0.5 // Set the minimum scale factor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class CustomXButton: UIButton {
    

    
    
    private let buttonSize: CGFloat = 65.0 // Change the button size to make the circle bigger
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let bcolor = UIColor(red: 226.0 / 255.0, green: 94.0 / 255.0, blue: 67.0 / 255.0, alpha: 1.0)
        self.layer.borderColor = bcolor.cgColor
        self.layer.borderWidth = 4.0 // Adjust the width of the stroke as needed
        self.layer.cornerRadius = buttonSize / 2
        self.clipsToBounds = true
        self.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        self.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        
        // Set the title "V" for the button
        self.setTitle("X", for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 38.0) // Adjust the font size as needed
        self.setTitleColor(bcolor, for: .normal) // Set the text color
        self.titleLabel?.adjustsFontSizeToFitWidth = true // Adjust text size to fit within the button
        self.titleLabel?.minimumScaleFactor = 0.5 // Set the minimum scale factor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateButton(shouldShow: Bool) {
        UIView.animate(withDuration: 1) {
            self.alpha = shouldShow ? 1 : 0
        }
        self.isUserInteractionEnabled = shouldShow
    }
    
}


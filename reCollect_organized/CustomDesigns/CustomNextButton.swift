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

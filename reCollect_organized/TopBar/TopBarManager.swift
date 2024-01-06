//
//  TopBarManager.swift
//  reCollect_organized
//
//  Created by Daniel Pikovsky Yoffe on 13/07/2023.
//

import UIKit

class TopBarManager {
    static let shared = TopBarManager()
    
    public var topBar: UIView!
    private var titleLabel: UILabel?
    private var hamburgerButton: UIButton?
    
    private var originalHeight: CGFloat = 0.0
    private var barExpended: Bool = false
    
    private var behavior: ButtonBehavior = ScaleBehavior()  // default behavior
    
    private init() {
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        let navigationBarHeight = UINavigationController().navigationBar.frame.size.height
        let topBarHeight = max(statusBarHeight, navigationBarHeight)
        
        let blurEffect = UIBlurEffect(style: .light)
        topBar = UIVisualEffectView(effect: nil)
        //topBar = UIView()
        topBar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: topBarHeight)
        topBar.alpha = 0
        print("TopBarManager - Initialized with originalHeight: \(originalHeight)")
        
        originalHeight = topBarHeight
        
    }
    
    func addToView(_ view: UIView) {
        print("TopBarManager - Adding topBar to view")
        view.addSubview(topBar)
        view.bringSubviewToFront(topBar)
        
    }
    
    func animateHeight(to height: CGFloat, duration: TimeInterval = 0.5) {
        UIView.animate(withDuration: duration) {
            self.topBar.frame.size.height = height
        }
    }
    
    func animateOpacity(to opacity: CGFloat, duration: TimeInterval = 0.5) {
        UIView.animate(withDuration: duration) {
            self.topBar.alpha = opacity
            self.titleLabel?.alpha = opacity
            self.hamburgerButton?.alpha = opacity
        }
    }
    
    func extendBar() {
        let expandedHeight = originalHeight * 2.0
        animateHeight(to: expandedHeight)
        
        if titleLabel == nil {
            addTitleLabel()
        }
        
        if hamburgerButton == nil {
            addHamburger()
        }
        
        animateOpacity(to: 1, duration: 0.5)
    }
    
    func withdrawBar() {
        animateHeight(to: originalHeight)
        
        if let titleLabel = titleLabel {
            titleLabel.removeFromSuperview()
            self.titleLabel = nil
        }
        
        if let hamburgerButton = hamburgerButton {
            hamburgerButton.removeFromSuperview()
            self.hamburgerButton = nil
        }
        
        animateOpacity(to: 0, duration: 0.5)
    }
    
    private func addTitleLabel() {
        let titleLabelHeight = originalHeight
        let titleLabelY = originalHeight + (originalHeight / 2.0) - (titleLabelHeight / 2.0)
        let screenWidth = UIScreen.main.bounds.width
        
        let contentView = (topBar as? UIVisualEffectView)?.contentView
        
        let titleLabel = UILabel()
        titleLabel.text = "reCollect"
        titleLabel.textAlignment = .center
        titleLabel.frame = CGRect(x: 0, y: titleLabelY, width: screenWidth, height: titleLabelHeight)
        
        let fontSize = screenWidth * 0.06 // Adjust this factor as needed
        titleLabel.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        titleLabel.alpha = 0
        contentView?.addSubview(titleLabel)
        self.titleLabel = titleLabel
        
        UIView.animate(withDuration: 1) {
            self.titleLabel?.alpha = 1
        }
    }
    
    private func addHamburger() {
        let hamburgerImage = UIImage(named: "hamburger")
        let imageWidth = originalHeight * 0.6 // Adjust this factor as needed
        
        let contentView = (topBar as? UIVisualEffectView)?.contentView
        
        let hamburgerButton = UIButton(type: .custom) // change this to UIButton
        hamburgerButton.setImage(hamburgerImage, for: .normal)
        hamburgerButton.contentMode = .scaleAspectFit
        hamburgerButton.frame = CGRect(x: UIScreen.main.bounds.width - imageWidth - 10, y: titleLabel?.frame.minY ?? 0.0, width: imageWidth, height: originalHeight)
        hamburgerButton.alpha = 0
        
        // Add the desired behavior
        behavior.apply(to: hamburgerButton)
        
        hamburgerButton.addTarget(self, action: #selector(hamburgerTapped), for: .touchUpInside)
        
        contentView?.addSubview(hamburgerButton)
        self.hamburgerButton = hamburgerButton // update this to be a button
        
        UIView.animate(withDuration: 1) {
            self.hamburgerButton?.alpha = 1
        }
    }
    
    @objc private func hamburgerTapped() {
        if !barExpended {
            topBar.superview?.bringSubviewToFront(topBar)
            animateHeight(to: UIScreen.main.bounds.height)
            barExpended = true
        }
        else {
            let expandedHeight = originalHeight * 2.0
            animateHeight(to: expandedHeight)
            barExpended = false
        }
    }
    
}


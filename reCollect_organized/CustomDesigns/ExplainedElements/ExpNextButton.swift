//
//  ExplainElements.swift
//  reCollect_organized
//
//  Created by Daniel Pikovsky Yoffe on 03/08/2023.
//


import UIKit

class NextButton: UIButton {
    weak var actionTarget: AnyObject?
    var actionSelector: Selector?
    public var visualEffectView: UIVisualEffectView
    private var behavior: ButtonBehavior = ScaleBehavior()
    var arrowImageView: UIImageView!
    
    
    init() {
        // Create visual effect view with blur effect
        let blurEffect = UIBlurEffect(style: .light)
        visualEffectView = UIVisualEffectView(effect: blurEffect)
        
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        visualEffectView.isUserInteractionEnabled = false
        visualEffectView.clipsToBounds = true
        self.addSubview(visualEffectView)
        
        
                self.clipsToBounds = false
        //        self.setImage(UIImage(systemName: "arrow.right")?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(scale: .large)), for: .normal)
        //        self.tintColor = UIColor.black
        arrowImageView = UIImageView()
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.contentMode = .scaleAspectFit
        self.addSubview(arrowImageView)
        
        NSLayoutConstraint.activate([
                    arrowImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                    arrowImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                    arrowImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1),
                    arrowImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1)
                ])
        
        self.contentHorizontalAlignment = .center
        self.contentVerticalAlignment = .center
        
        self.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        behavior.apply(to: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTapAction(target: AnyObject, selector: Selector) {
        actionTarget = target
        actionSelector = selector
    }
    
    @objc func handleTap() {
        actionTarget?.perform(actionSelector)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageSize = CGSize(width: self.bounds.width * 0.7, height: self.bounds.width * 0.7)
        let image = UIImage(systemName: "arrow.right.circle.fill")?.withRenderingMode(.alwaysTemplate).scaled(to: imageSize)
        let tintedImage = image?.withTintColor(orangeGradient)
        arrowImageView.image = tintedImage
        arrowImageView.alpha = 0.75
        

        
        //visualEffectView.frame = self.bounds
       // visualEffectView.alpha = 1
       // visualEffectView.layer.cornerRadius = self.bounds.width / 2
        //self.layer.cornerRadius = self.bounds.width / 2
    }
}



extension UIImage {
    func scaled(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

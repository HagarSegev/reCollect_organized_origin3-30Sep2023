//
//  LogoAndTagline.swift
//  reCollect_organized
//
//  Created by Daniel Pikovsky Yoffe on 11/07/2023.
//

import UIKit

class LogoAndTagline: UIView {
    var taglineLabel: UILabel!
    var logoLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        // Configure taglineLabel
        taglineLabel = UILabel()
        taglineLabel.textColor = UIColor.black
        taglineLabel.font = UIFont.systemFont(ofSize: 16 * (UIScreen.main.bounds.width / 390))
        taglineLabel.attributedText = NSMutableAttributedString(string: "Explore Life's core Moments", attributes: [NSAttributedString.Key.kern: -0.32])
        self.addSubview(taglineLabel)
        taglineLabel.translatesAutoresizingMaskIntoConstraints = false

        // Configure logoLabel
//        logoLabel = UILabel()
//        logoLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
//        logoLabel.font = UIFont.systemFont(ofSize: 40 * (UIScreen.main.bounds.width / 390), weight: .bold )
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineHeightMultiple = 0
//        logoLabel.attributedText = NSMutableAttributedString(string: "reCollect", attributes: [NSAttributedString.Key.kern: 1.8, NSAttributedString.Key.paragraphStyle: paragraphStyle])
//        self.addSubview(logoLabel)
//        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        logoLabel = UILabel()
        logoLabel.text = "reCollect"
        logoLabel.font = UIFont.systemFont(ofSize: 50, weight: .bold)
        logoLabel.shadowOffset = CGSize(width: 5, height: 5)
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        logoLabel.textColor = .black

        self.addSubview(logoLabel)
        
        // Apply constraints
        NSLayoutConstraint.activate([
            logoLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//            logoLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            logoLabel.topAnchor.constraint(equalTo: self.topAnchor),

            taglineLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//            taglineLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            //taglineLabel.topAnchor.constraint(equalTo: logoLabel.bottomAnchor, constant: 0), // Adjust the constant value as needed
            taglineLabel.firstBaselineAnchor.constraint(equalTo: logoLabel.lastBaselineAnchor, constant: 20),

            taglineLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

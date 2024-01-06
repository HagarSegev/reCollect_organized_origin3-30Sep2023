//
//  ProgressMeter.swift
//  reCollect_organized
//
//  Created by Daniel Pikovsky Yoffe on 03/08/2023.
//

import UIKit

class ProgressMeter: UIView {
    private var circles = [UIView]()
    private let circleSize: CGFloat = UIScreen.main.bounds.width / 35
    private var currentStage = 0
    
    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        for _ in 0..<3 {
            let circle = UIView()
            circle.translatesAutoresizingMaskIntoConstraints = false
            circle.layer.borderWidth = 2
            circle.layer.borderColor = UIColor(red: 0.224, green: 0.306, blue: 0.294, alpha: 1).cgColor
            circle.backgroundColor = .clear
            circle.layer.cornerRadius = circleSize / 2
            circles.append(circle)
            self.addSubview(circle)
        }
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: circleSize),
            
            circles[0].leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -3 * circleSize),
            circles[0].centerYAnchor.constraint(equalTo: self.centerYAnchor),
            circles[0].widthAnchor.constraint(equalToConstant: circleSize),
            circles[0].heightAnchor.constraint(equalToConstant: circleSize),
            
            circles[1].centerXAnchor.constraint(equalTo: self.centerXAnchor),
            circles[1].centerYAnchor.constraint(equalTo: self.centerYAnchor),
            circles[1].widthAnchor.constraint(equalToConstant: circleSize),
            circles[1].heightAnchor.constraint(equalToConstant: circleSize),
            
            circles[2].trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 3 * circleSize),
            circles[2].centerYAnchor.constraint(equalTo: self.centerYAnchor),
            circles[2].widthAnchor.constraint(equalToConstant: circleSize),
            circles[2].heightAnchor.constraint(equalToConstant: circleSize)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clearLastColoredDot() {
        guard currentStage > 0 else {
            return // If already at the first stage, do nothing
        }

        let lastColoredIndex = currentStage - 1
        circles[lastColoredIndex].layer.borderWidth = 2
        circles[lastColoredIndex].backgroundColor = .clear
    
    }
    
    func nextStage() {
        guard currentStage < circles.count else { return }
        var delay: CGFloat = 0
        if currentStage == 0 {delay = 0.3}
        UIView.animate(withDuration: 1, delay: delay, options: .curveEaseIn) {
            self.circles[self.currentStage].layer.borderWidth = self.circleSize / 2
        }
        
        currentStage += 1
    }
    
    
    func prevStage() {
        guard currentStage > 0 else { return }
        currentStage -= 1
        UIView.animate(withDuration: 1) {
            self.circles[self.currentStage].layer.borderWidth = 2
        }
    }
}

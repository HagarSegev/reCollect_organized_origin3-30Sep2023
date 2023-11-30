//
//  TimeAndBatteryBar.swift
//  reCollect_organized
//
//  Created by Daniel Pikovsky Yoffe on 13/07/2023.
//


import UIKit

class TimeAndBatteryBar: UIView {

    // MARK: - Properties
    private var barLength: CGFloat = UIScreen.main.bounds.width

    // Shared instance
    static let shared: TimeAndBatteryBar = {
        let instance = TimeAndBatteryBar(barLength: UIScreen.main.bounds.width)
        // setup code
        return instance
    }()
    
    // MARK: - Initializers
    private init(barLength: CGFloat) {
        super.init(frame: .zero)
        self.barLength = barLength
        self.backgroundColor = UIColor(red: 0.941, green: 0.851, blue: 0.725, alpha: 0.97)
        self.frame = CGRect(x: 0, y: 0, width: self.barLength, height: 20)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods
    func updateFrame() {
        let screenSize = UIScreen.main.bounds
        self.frame = CGRect(x: 0,
                            y: 0,
                            width: self.barLength,
                            height: 20) // You can adjust the height as needed
    }

    func animateBarLength(to length: CGFloat) {
        UIView.animate(withDuration: 0.5) {
            self.barLength = length
            self.updateFrame()
        }
    }
}

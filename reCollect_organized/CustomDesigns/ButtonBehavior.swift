//
//  ButtonBehavior.swift
//  reCollect_organized
//
//  Created by Daniel Pikovsky Yoffe on 23/07/2023.
//

import UIKit


protocol ButtonBehavior {
    func apply(to button: UIButton)
}

class ScaleBehavior: ButtonBehavior {
    func apply(to button: UIButton) {
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }

    @objc private func buttonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1,
                       animations: {
                        sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                       },
                       completion: { _ in
                        UIView.animate(withDuration: 0.1) {
                            sender.transform = CGAffineTransform.identity
                        }
                       })
    }
}

class ScaleBehaviorBigObj: ButtonBehavior {
    func apply(to button: UIButton) {
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(buttonReleased(_:)), for: [.touchUpInside, .touchUpOutside])
    }

    @objc private func buttonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }

    @objc private func buttonReleased(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform.identity
        }
    }
}


class HighlightBehavior: ButtonBehavior {
    func apply(to button: UIButton) {
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }

    @objc private func buttonTapped(_ sender: UIButton) {
        sender.isHighlighted = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            sender.isHighlighted = false
        }
    }
}

class SpringBehavior: ButtonBehavior {
    func apply(to button: UIButton) {
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }

    @objc private func buttonTapped(_ sender: UIButton) {
        sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)

        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 6.0,
                       options: .allowUserInteraction,
                       animations: {
                        sender.transform = .identity
                       },
                       completion: nil)
    }
}

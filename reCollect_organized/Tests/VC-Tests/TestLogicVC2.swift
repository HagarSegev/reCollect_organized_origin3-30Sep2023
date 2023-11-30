//
//  TestLogicVC2.swift
//  reCollect_organized
//
//  Created by Daniel Pikovsky Yoffe on 21/06/2023.
//

import UIKit

class TestLogicVC2: ViewControllerHandler {
    weak var delegate: ViewControllerHandlerDelegate?
    let view: UIView
    var button: UIButton

    init(view: UIView) {
        self.view = view
        button = UIButton(type: .system)
        button.setTitle("Move to logic VC 3", for: .normal)
        button.alpha = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    func setupView() {
        view.addSubview(button)
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    func teardownView() {
        button.removeFromSuperview()
    }

    func executeLogic() {
        print("Starting logic of TestLogicVC2")
        Background.shared.changeZoom(newScale: 2.8, newX: 10, newY: -20, duration: 1)
        UIView.animate(withDuration: 1, animations: {
            self.button.alpha = 1
        })
        print("Finished logic of TestLogicVC2")
    }

    @objc func buttonTapped() {
        Background.shared.changeZoom(newScale: 2.2, newX: 200, newY: 130, duration: 1)
        UIView.animate(withDuration: 1, animations: {
            self.button.alpha = 0
        }) { _ in
            self.delegate?.handler(self, didFinishWithTransitionTo: TestLogicVC3.self)
        }
    }
    deinit {
        print("\(self) is being deallocated")
    }
}

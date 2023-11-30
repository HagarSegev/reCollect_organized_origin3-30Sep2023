//
//  LogoVC.swift
//  reCollect_organized
//
//  Created by Daniel Pikovsky Yoffe on 21/06/2023.
//


import UIKit

class StartVC: ViewControllerHandler {
    weak var delegate: ViewControllerHandlerDelegate?
    weak var viewController: UIViewController?
    let view: UIView
    var textLabel: UILabel
    var byLabel: UILabel
    var logoImageView: UIImageView

    init(view: UIView, viewController: UIViewController) {
        self.view = view
        self.viewController = viewController
        textLabel = UILabel()
        textLabel.text = "reCollect"
        textLabel.font = UIFont.systemFont(ofSize: 56, weight: .bold)
        textLabel.shadowOffset = CGSize(width: 5, height: 5)
        textLabel.alpha = 0
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textColor = .black

        byLabel = UILabel()
        byLabel.text = "by"
        byLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        byLabel.alpha = 0
        byLabel.translatesAutoresizingMaskIntoConstraints = false
        byLabel.textColor = .black

        logoImageView = UIImageView(image: UIImage(named: "cnp-lab-logo"))
        logoImageView.alpha = 0
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupView() {
        view.addSubview(textLabel)
        view.addSubview(byLabel)
        view.addSubview(logoImageView)

        textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30).isActive = true

        byLabel.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 2).isActive = true
        byLabel.leadingAnchor.constraint(equalTo: textLabel.leadingAnchor).isActive = true
        byLabel.bottomAnchor.constraint(equalTo: logoImageView.bottomAnchor).isActive = true

        logoImageView.leftAnchor.constraint(equalTo: byLabel.rightAnchor, constant: 6).isActive = true
        logoImageView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 2).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true // Adjust the height
        logoImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true // Adjust the width
        logoImageView.contentMode = .scaleAspectFit
    }


    func teardownView() {
        textLabel.removeFromSuperview()
        byLabel.removeFromSuperview()
        logoImageView.removeFromSuperview()
    }

    func executeLogic() {
        print("Starting logic of TestLogicVC1")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            Background.shared.changeOpacity(to: 1, duration: 7)
            Background.shared.changeZoom(newScale: 3, duration: 8)
            TopBarManager.shared.animateOpacity(to: 1 , duration: 7)
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            UIView.animate(withDuration: 2.5, animations: {
                self.textLabel.alpha = 1
            })
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            UIView.animate(withDuration: 2.5, animations: {
                self.byLabel.alpha = 1
                self.logoImageView.alpha = 1
            })
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {
            UIView.animate(withDuration: 2.5, animations: {
                self.textLabel.alpha = 0
            })
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
            UIView.animate(withDuration: 2.5, animations: {
                self.byLabel.alpha = 0
                self.logoImageView.alpha = 0
            }) { _ in
                print("TestLogicVC1 finished, transitioning to TestLogicVC2")
                self.delegate?.handler(self, didFinishWithTransitionTo: LoginVC.self)
//                self.delegate?.handler(self, didFinishWithTransitionTo: ChooseVC.self)
            }
        }
        
        print("Finished logic of TestLogicVC1")
    }


    deinit {
        print("\(self) is being deallocated")
    }
}

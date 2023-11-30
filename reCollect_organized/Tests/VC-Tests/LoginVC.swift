//
//  LoginVC.swift
//  reCollect_organized
//
//  Created by Daniel Pikovsky Yoffe on 09/07/2023.
//



import UIKit
import GoogleSignIn
import FirebaseAuth
import AuthenticationServices


class LoginVC: ViewControllerHandler {
    weak var delegate: ViewControllerHandlerDelegate?
    var view: UIView
    var googleButton: CustomSignInButton
    var appleButton: CustomSignInButton
    var facebookButton: CustomSignInButton
    var phoneButton: CustomSignInButton
    var viewController: UIViewController
    var welcomeLabel: UILabel!
    var privacyLabel: UILabel!
    var logoAndTagline: LogoAndTagline!
    
    // Relative font size
    let buttonHeight: CGFloat = 53 * (UIScreen.main.bounds.height / 844)
    let padding: CGFloat = 15 * (UIScreen.main.bounds.height / 844)
    let topPadding: CGFloat = 351 * (UIScreen.main.bounds.height / 844)
    let welcomeTxtSize: CGFloat = 24 * (UIScreen.main.bounds.width / 390)
    let privacyTxtSize: CGFloat = 10 * (UIScreen.main.bounds.width / 390)
    let welcomeTxtPositionY: CGFloat = 286 * (UIScreen.main.bounds.height / 844)
    let privacyTxtPositionY: CGFloat = 774 * (UIScreen.main.bounds.height / 844)

    private let appleSignInDelegate = AppleSignInDelegate()

    
    init(view: UIView, viewController: UIViewController) {
        self.view = view
        self.viewController = viewController
        self.googleButton = CustomSignInButton(title: "Sign in with Google", logoName: "googleLogoSVG")
        self.appleButton = CustomSignInButton(title: "Sign in with Apple", logoName: "appleLogoSVG")
        self.facebookButton = CustomSignInButton(title: "Sign in with Facebook", logoName: "facebookLogoSVG")
        self.phoneButton = CustomSignInButton(title: "Sign in with Phone", logoName: "phoneLogoSVG")
        
        // Initialize and configure the welcome label
        welcomeLabel = UILabel()
        welcomeLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        welcomeLabel.font =  UIFont.systemFont(ofSize: welcomeTxtSize, weight: .bold)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0
        welcomeLabel.attributedText = NSMutableAttributedString(string: "Welcome", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])

        // Initialize and configure the privacy label
        privacyLabel = UILabel()
        privacyLabel.textColor = UIColor(red: 0.522, green: 0.522, blue: 0.561, alpha: 1)
        privacyLabel.font =  UIFont.systemFont(ofSize: privacyTxtSize, weight: .light)
        privacyLabel.attributedText = NSMutableAttributedString(string: "By entering, you agree to the Privacy policy and the Terms of Use", attributes: [NSAttributedString.Key.kern: -0.32])
        
        // Initialize LogoAndTagline
        logoAndTagline = LogoAndTagline()
        logoAndTagline.alpha = 0
        
        appleSignInDelegate.loginVC = self

    }
    
    func setupView() {
        let buttons = [googleButton, appleButton, facebookButton, phoneButton]
        buttons.forEach { button in
            view.addSubview(button)
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            button.widthAnchor.constraint(equalToConstant: button.intrinsicContentSize.width).isActive = true
            button.heightAnchor.constraint(equalToConstant: button.intrinsicContentSize.height).isActive = true
            button.alpha = 0
            // Call sign in when the sign in button is tapped
            button.addTarget(self, action: #selector(didTapSignInButton(_:)), for: .touchUpInside)
        }
        
        // Setting up the constraints
        googleButton.topAnchor.constraint(equalTo: view.topAnchor, constant: topPadding).isActive = true
        appleButton.topAnchor.constraint(equalTo: googleButton.bottomAnchor, constant: padding).isActive = true
        facebookButton.topAnchor.constraint(equalTo: appleButton.bottomAnchor, constant: padding).isActive = true
        phoneButton.topAnchor.constraint(equalTo: facebookButton.bottomAnchor, constant: padding).isActive = true
        
        let labels = [welcomeLabel, privacyLabel]
            labels.forEach { label in
            view.addSubview(label!)
            label!.translatesAutoresizingMaskIntoConstraints = false
            label!.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            label!.alpha = 0
        }

        // Set up constraints for the labels
        welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: welcomeTxtPositionY).isActive = true
        privacyLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: privacyTxtPositionY).isActive = true
        
        
        // Adding LogoAndTagline to the view
        view.addSubview(logoAndTagline)
        logoAndTagline.translatesAutoresizingMaskIntoConstraints = false
        
        // Apply constraints to LogoAndTagline
        
        logoAndTagline.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoAndTagline.topAnchor.constraint(equalTo: view.topAnchor, constant: 150 * (UIScreen.main.bounds.height / 844)).isActive = true
    }
    
    func teardownView() {
        googleButton.removeFromSuperview()
        appleButton.removeFromSuperview()
        facebookButton.removeFromSuperview()
        phoneButton.removeFromSuperview()
        welcomeLabel.removeFromSuperview()
        privacyLabel.removeFromSuperview()
        logoAndTagline.removeFromSuperview()
    }
    
    func executeLogic() {
        print("Starting logic of SignInHandler")
        Background.shared.changeZoom(newScale: 2.6, newX: -10, newY: 40, duration: 1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            UIView.animate(withDuration: 1, animations: {
                self.googleButton.alpha = 0.9
                self.appleButton.alpha = 0.9
                self.facebookButton.alpha = 0.9
                self.phoneButton.alpha =  0.9
                self.welcomeLabel.alpha = 1
                self.privacyLabel.alpha = 1
                self.logoAndTagline.alpha = 1
            })
        }
                print("Finished logic of SignInHandler")
    }
    
    @objc func didTapSignInButton(_ sender: CustomSignInButton) {
        switch sender {
        case googleButton:
            print("Google button tapped.")
            didTapGoogleSignInButton()
        case appleButton:
            print("Apple button tapped.")
            didTapAppleSignInButton()

        case facebookButton:
            print("Facebook button tapped.")
            // handle Facebook sign in
        case phoneButton:
            print("Phone button tapped.")
            // handle Phone sign in
        default:
            break
        }
    }

    deinit {
        print("\(self) is being deallocated")
    }
    
    @objc func didTapAppleSignInButton() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = appleSignInDelegate
        authorizationController.presentationContextProvider = appleSignInDelegate
        authorizationController.performRequests()
    }
    
    @objc func didTapGoogleSignInButton() {
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { authentication, error in
            if let error = error {
                print("Failed to sign in with error: ", error)
                return
            }
            
            guard let user = authentication?.user, let idToken = user.idToken?.tokenString else {
                print("Failed to get user from Google Sign In")
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Failed to log in with Google: ", error)
                    return
                }
                
                print("Successfully logged in with Google")
                self.finishLogin()
            }
        }
    }
    /**
     Trigger transition to the next ViewControllerHandler
     */
    public func finishLogin(){
        UIView.animate(withDuration: 1, animations: {
            self.googleButton.alpha = 0
            self.appleButton.alpha = 0
            self.facebookButton.alpha = 0
            self.phoneButton.alpha = 0
            self.welcomeLabel.alpha = 0
            self.privacyLabel.alpha = 0
            self.logoAndTagline.alpha = 0
        }){ _ in
            // Animate the top bar height
            TopBarManager.shared.extendBar()
            self.delegate?.handler(self, didFinishWithTransitionTo: ExplainGeneralVC.self)
        }
    }
}

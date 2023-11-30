//
//  AppleSignInDelegate.swift
//  reCollect_organized
//
//  Created by Daniel Pikovsky Yoffe on 21/09/2023.
//

import AuthenticationServices

class AppleSignInDelegate: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    weak var loginVC: LoginVC?
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return loginVC!.viewController.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Handle the authorization and save user credentials here.
            // Note: You'll probably want to generate Firebase credentials from this and sign in.

            print("Successfully logged in with Apple")
            loginVC?.finishLogin()
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle any errors here.
        print("Apple Sign In Error: \(error)")
    }
}


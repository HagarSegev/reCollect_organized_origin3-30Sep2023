//
//  SignInMethods.swift
//  reCollect_organized
//
//  Created by Daniel Pikovsky Yoffe on 11/07/2023.
//

import GoogleSignIn

func didTapSignInButton() {
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
            // Trigger transition to the next ViewControllerHandler
            self.delegate?.handler(self, didFinishWithTransitionTo: TestLogicVC3.self)
        }
    }
}

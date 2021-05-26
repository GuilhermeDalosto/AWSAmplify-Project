//
//  AmplifyAuth.swift
//  CompleteiOSAWSDeveloper
//
//  Created by Guilherme Martins Dalosto de Oliveira on 26/05/21.
//

import Foundation
import Combine
import Amplify
import AWSCognitoAuthPlugin

class AmplifyAuth {
    
    func fetchCurrentSession() {
        _ = Amplify.Auth.fetchAuthSession { result in
            switch result {
            case .success(let session):
                print("Is user signed in - \(session.isSignedIn)")
            case .failure(let error):
                print("Fetch session failed with error \(error)")
            }
        }
    }
    
    func signUp(username: String, password: String, email: String) {
        let userAttributes = [AuthUserAttribute(.email,value: email)]
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
        
        Amplify.Auth.signUp(username: username, password: password, options: options) { result in
            switch result {
            case .success(let signUpResult):                
                if case let .confirmUser(deliveryDetails, _) = signUpResult.nextStep {
                    print("Delivery details \(String(describing: deliveryDetails))")
                } else {
                    print("SignUp Complete")
                }
            case .failure(let error):
                print("An error ocured while registering a user \(error)")
            }
        }
    }
    
    func confirmSignUp(for username: String, with confirmationCode: String) -> AnyCancellable {
        Amplify.Auth.confirmSignUp(for: username, confirmationCode: confirmationCode)
            .resultPublisher
            .sink {
                if case let .failure(authError) = $0 {
                    print("Error ocurred while conforming signup \(authError)")
                }
            }
            receiveValue: { _ in
                print("Confirm signup succeeded")
            }
    }
    
    func signIn(username: String, password: String) -> AnyCancellable {
        Amplify.Auth.signIn(username: username, password: password)
            .resultPublisher
            .sink {
                if case let .failure(authError) = $0 {
                    print("Sign in failed \(authError)")
                }
            }
            receiveValue: { _ in
                print("Sign in succeeded")
            }
        
        }
    
    func resetPassword(username: String) -> AnyCancellable {
        Amplify.Auth.resetPassword(for: username)
            .resultPublisher
            .sink {
                if case let .failure(authError) = $0 {
                    print("Reset password failed with error \(authError)")
                }
            }
            receiveValue: { resetResult in
                switch resetResult.nextStep {
                case .confirmResetPasswordWithCode(let deliveryDetails, let info):
                    print("Confirm reset password with code send to - \(deliveryDetails) \(String(describing: info))")
                case .done:
                    print("Reset completed")
                }
            }
    }
    
    func confirmResetPassword(username: String, newPassword: String, confirmationCode: String) -> AnyCancellable {
        Amplify.Auth.confirmResetPassword(for: username, with: newPassword, confirmationCode: confirmationCode
        )
        .resultPublisher
        .sink {
            if case let .failure(authError) = $0 {
                print("Reset password failed with error \(authError)")
            }
        }
        receiveValue: {
            print("Password reset confirmed")
        }
    }
    
    func changePassword(oldPassword: String, newPassword: String) -> AnyCancellable {
        Amplify.Auth.update(oldPassword: oldPassword, to: newPassword)
            .resultPublisher
            .sink {
                if case let .failure(authError) = $0 {
                    print("Change password failed with error \(authError)")
                }
            }
            receiveValue: {
                print("Change password succeeded")
            }
    }
    
    func signOutLocally() -> AnyCancellable {
        Amplify.Auth.signOut()
            .resultPublisher
            .sink {
                if case let .failure(authError) = $0 {
                    print("Sign out failed with error \(authError)")
                }
            }
            receiveValue: {
                print("Successfully signed out")
            }
    }
    
    func signOutGlobally() -> AnyCancellable {
        let sink = Amplify.Auth.signOut(options: .init(globalSignOut: true))
            .resultPublisher
            .sink {
                if case let .failure(authError) = $0 {
                    print("Sign out failed with error \(authError)")
                }
            }
            receiveValue: {
                print("Successfully signed out")
            }
        return sink
    }
}

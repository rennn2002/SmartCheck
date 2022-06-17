//
//  SignInWithApple.swift
//  Health Check
//
//  Created by Nomura Rentaro on 2022/06/17.
//
import SwiftUI
import AuthenticationServices
import CryptoKit
import FirebaseAuth
import FirebaseFirestore

struct SignInWithAppleButton: UIViewRepresentable {
    typealias UIViewType = ASAuthorizationAppleIDButton
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        return ASAuthorizationAppleIDButton(type: .signIn, style: .black)
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {}
}

public class SignInWithAppleObject: NSObject {
    private var currentNonce: String?
    
    public func signInWithApple() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.email, .fullName]
        let nonce = randomNonceString()
        currentNonce = nonce
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    //  https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
}

extension SignInWithAppleObject: ASAuthorizationControllerDelegate {
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        // Sign in With Firebase app
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                print("Invalid state: A login callback was received, but no login request was sent.")
                return
            }
            
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data")
                return
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            Auth.auth().signIn(with: credential) { result, error in
                if (result != nil) {
                    
                }
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                if let user = Auth.auth().currentUser {
                    let db = Firestore.firestore()
                    let ref = db.collection("users").document(user.uid)
                    ref.getDocument { (document, error) in
                        if let document = document, document.exists {
                            //                                                print("exist")
                            UserDefaults.standard.set(false, forKey: "isWaitingShow")
                            NotificationCenter.default.post(name: NSNotification.Name("isWaitingShow"), object: nil)
                            UserDefaults.standard.set(true, forKey: "isLoggedin")
                            NotificationCenter.default.post(name: NSNotification.Name("isLoggedin"), object: nil)
                        } else {
                            //                                                print("new")
                            UserDefaults.standard.set(false, forKey: "isWaitingShow")
                            NotificationCenter.default.post(name: NSNotification.Name("isWaitingShow"), object: nil)
                            UserDefaults.standard.set(true, forKey: "isSignedup")
                            NotificationCenter.default.post(name: NSNotification.Name("isSignedup"), object: nil)
                        }
                    }
                }
            }
        }
    }
}

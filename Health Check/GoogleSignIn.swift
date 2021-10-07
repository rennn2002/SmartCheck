//
//  GoogleSignIn.swift
//  Health Check
//
//  Created by Nomura Rentaro on 2021/09/29.
//
//import UIKit
//import GoogleSignIn
//import FirebaseAuth
//import SwiftUI
//
//class GoogleSignInViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        GIDSignIn.sharedInstance()?.presentingViewController = self
//        GIDSignIn.sharedInstance()?.delegate = self
//    }
//}
//
//extension GoogleSignInViewController: GIDSignInDelegate {
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//
//        if let error = error {
//            print(error.localizedDescription)
//            return
//        }
//
//        guard let auth = user.authentication else {
//            return
//        }
//
//        let credential = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
//
//        Auth.auth().signIn(with: credential) { authResult, error in
//            if let error = error {
//                print(error.localizedDescription)
//            }
//        }
//
//        let user = Auth.auth().currentUser
//        if let user = user {
//            let email = user.email
//            Auth.auth().fetchSignInMethods(forEmail: email!, completion: { (forEmail, error) in
//                // stop activity indicator
//
//                if let error = error {
//                    print("Email Error: \(error.localizedDescription)")
//                    print(error._code)
//                    UserDefaults.standard.set(true, forKey: "isSignedin")
//                    NotificationCenter.default.post(name: NSNotification.Name("isSignedin"), object: nil)
//
//                } else {
//                    print("Email is good")
//                    UserDefaults.standard.set(true, forKey: "isLoggedin")
//                    NotificationCenter.default.post(name: NSNotification.Name("isLoggedin"), object: nil)
//                }
//
//            })
//        }
//    }
//
//}
//
//
//struct GoogleSignInButtonViewController: UIViewControllerRepresentable {
//
//    func makeUIViewController(context: Context) -> UIViewController {
//        let gidSignInButton = GIDSignInButton()
//        gidSignInButton.style = .wide
//        gidSignInButton.frame = CGRect(x: gidSignInButton.frame.width / 2, y: gidSignInButton.frame.height / 2, width: 30, height: 30)
//
//        let viewController = GoogleSignInViewController()
//
//        viewController.view.addSubview(gidSignInButton)
//
//        return viewController
//    }
//
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//    }
//
//    static func attemptLoginGoogle(){
//        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.last?.rootViewController
//        GIDSignIn.sharedInstance()?.signIn()
//        UserDefaults.standard.set(true, forKey: "isSignedup")
//        NotificationCenter.default.post(name: NSNotification.Name("isSignedup"), object: nil)
//    }
//}
//
//// Not Used
//struct GoogleAuth: UIViewControllerRepresentable {
//
//    // func makeUIView(context: UIViewRepresentableContext<GoogleAuth>) ->
//    //     GIDSignInButton {
//    //     let button = GIDSignInButton()
//    //     button.style = .wide
//    //     button.isHidden = true
//
//    //     GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.last?.rootViewController
//
//    //     return button;
//    // }
//
//    func makeUIViewController(context: Context) -> UIViewController {
//        let viewController = GoogleSignInViewController()
//        return viewController
//    }
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//    }
//
//    func attemptLoginGoogleNew() {
//        GIDSignIn.sharedInstance()?.signIn()
//
//    }
//}


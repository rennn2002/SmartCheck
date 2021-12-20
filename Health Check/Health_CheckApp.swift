//
//  Health_CheckApp.swift
//  Health Check
//
//  Created by Nomura Rentaro on 2021/09/28.
//

//import SwiftUI
//import Firebase
//import GoogleSignIn
//
//@main
//struct Health_CheckApp: App {
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
//    var body: some Scene {
//        WindowGroup {
//            LaunchView()
//        }
//    }
//}
//
//class AppDelegate: UIResponder, UIApplicationDelegate {
//
//  var window: UIWindow?
//
//  func application(_ application: UIApplication,
//    didFinishLaunchingWithOptions launchOptions:
//        [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//    FirebaseApp.configure()
//    GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
//
//    return true
//  }
//}


import SwiftUI
import Firebase
import GoogleSignIn

@main
struct MedsalonApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            LaunchView()
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        //        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, _) in
        //            print("Permission granted: \(granted)")
        //            UIApplication.shared.applicationIconBadgeNumber = 1
        //        }
//        UNUserNotificationCenter.current().delegate = self
//        let appDomain = Bundle.main.bundleIdentifier
//        UserDefaults.standard.removePersistentDomain(forName: appDomain!)
        
        NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: nil) { _ in
            let notificationTimeHour: Int = UserDefaults.standard.value(forKey: "notificationTimeHour") as? Int ?? 8
            let notificationTimeMinute: Int = UserDefaults.standard.value(forKey: "notificationTimeMinute") as? Int ?? 0
            let notification: Notification = Notification() //make an instance here
            
            notification.makeNotificationOnSchedule(notificationTimeHour: notificationTimeHour, notificationTimeMinute: notificationTimeMinute)
        }
        FirebaseApp.configure()
        
        return true
    }
    
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//
//        if error != nil{
//
//            print(error.localizedDescription)
//            return
//        }
//        let credential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken, accessToken: user.authentication.accessToken)
//        UserDefaults.standard.set(true, forKey: "isWaitingShow")
//        NotificationCenter.default.post(name: NSNotification.Name("isWaitingShow"), object: nil)
//        UserDefaults.standard.set(false, forKey: "isGuidanceShow")
//        NotificationCenter.default.post(name: NSNotification.Name("isGuidanceShow"), object: nil)
//        Auth.auth().signIn(with: credential) { (res, err) in
//
//            if err != nil{
//
//                print((err?.localizedDescription)!)
//                return
//            }
//
//            if let user = Auth.auth().currentUser {
//                let db = Firestore.firestore()
//                let ref = db.collection("users").document(user.uid)
//                ref.getDocument { (document, error) in
//                    if let document = document, document.exists {
//                        print("exist")
//                        UserDefaults.standard.set(false, forKey: "isWaitingShow")
//                        NotificationCenter.default.post(name: NSNotification.Name("isWaitingShow"), object: nil)
//                        UserDefaults.standard.set(true, forKey: "isLoggedin")
//                        NotificationCenter.default.post(name: NSNotification.Name("isLoggedin"), object: nil)
//                    } else {
//                        print("new")
//                        UserDefaults.standard.set(false, forKey: "isWaitingShow")
//                        NotificationCenter.default.post(name: NSNotification.Name("isWaitingShow"), object: nil)
//                        UserDefaults.standard.set(true, forKey: "isSignedup")
//                        NotificationCenter.default.post(name: NSNotification.Name("isSignedup"), object: nil)
//                    }
//                }
//            }
//        }
//    }
    
}

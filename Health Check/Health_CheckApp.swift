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
    var notification: Notification = Notification()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        UNUserNotificationCenter.current()
//          .requestAuthorization(options: [.alert, .sound, .badge]) { (granted, _) in
//            print("Permission granted: \(granted)")
//          }
//        UNUserNotificationCenter.current().delegate = self
//        let appDomain = Bundle.main.bundleIdentifier
//        UserDefaults.standard.removePersistentDomain(forName: appDomain!)
        NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: nil) { _ in
            print("entered")
            self.notification.makeNotificationOnSchedule()
        }
        FirebaseApp.configure()

        return true
    }
}


//
//  SettingView.swift
//  Health Check
//
//  Created by Nomura Rentaro on 2021/10/07.
//

import SwiftUI
import UserNotifications
import FirebaseAuth
import GoogleSignIn

struct SettingView: View {
    var fireauth: FireAuth = FireAuth()
    @ObservedObject var firestore: FireStore = FireStore()
    @State var isEditOn: Bool = false
    
    @State var isNotificationOn: Bool = UserDefaults.standard.value(forKey: "isNotificationOn") as? Bool ?? false
    var notification: Notification = Notification()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("設定")
                    .font(.title)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .padding()
                
                VStack {
                    Form {
                        Section(header:Text("通知設定")) {
                            Toggle(isOn: self.$isNotificationOn) {
                                Text(self.isNotificationOn ? "通知オン":"通知オフ")
                                    .fontWeight(.bold)
                            }.onChange(of: self.isNotificationOn) { newValue in
                                if newValue {
                                    print("called")
                                    UNUserNotificationCenter.current()
                                        .requestAuthorization(options: [.alert, .sound, .badge]) { (granted, _) in
                                            print("Permission granted: \(granted)")
                                        }
                                    UserDefaults.standard.set(true, forKey: "isNotificationOn")
                                    NotificationCenter.default.post(name: NSNotification.Name("isNotificationOn"), object: nil)
                                } else {
                                    UserDefaults.standard.set(false, forKey: "isNotificationOn")
                                    NotificationCenter.default.post(name: NSNotification.Name("isNotificationOn"), object: nil)
                                }
                            }
                            Button(action:{
                                UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound, .badge]){
                                    (granted, _) in
                                    if granted {
                                        
                                        self.notification.makeNotificationOnDemand()
                                    }else {
                                        
                                    }
                                }
                            }) {
                                Text("通知送信")
                            }
                        }
                        Section(header: Text("アカウント設定")) {
                        NavigationLink(destination: ProfileEditView(isEditOn: self.$isEditOn), isActive: self.$isEditOn) {
                            Text("登録情報変更")
                                .foregroundColor(.blue)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            
                        }.navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
                        
                        Button(action:{
                            GIDSignIn.sharedInstance()?.signOut()
                            try! Auth.auth().signOut()
                            UserDefaults.standard.set(false, forKey: "isLoggedin")
                            NotificationCenter.default.post(name: NSNotification.Name("isLoggedin"), object: nil)
                            
                        }) {
                            Text("ログアウト")
                                .foregroundColor(.red)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        }
                            
                    }.navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)
                    
                }
                
                Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
            }.navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            fireauth.getData()
            NotificationCenter.default.addObserver(forName: NSNotification.Name("isNotificationOn"), object: nil, queue: .main) { (_) in
                self.isNotificationOn = UserDefaults.standard.value(forKey: "isNotificationOn") as? Bool ?? false
            }
        }
        }.navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}

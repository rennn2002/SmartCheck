//
//  SettingView.swift
//  Health Check
//
//  Created by Nomura Rentaro on 2021/10/07.
//

import SwiftUI
import UserNotifications
import FirebaseAuth

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
            
            Divider()
            
            VStack {
                Group {
                    HStack {
                        Text("通知設定")
                            .font(.title3)
                            .fontWeight(.bold)
                        Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                    }
                    Divider()
                    Toggle(isOn: self.$isNotificationOn) {
                        Text(self.isNotificationOn ? "通知オン":"通知オフ")
                            .fontWeight(.bold)
                    }.onChange(of: self.isNotificationOn) { newValue in
                        if newValue {
                            UNUserNotificationCenter.current()
                                .requestAuthorization(options: [.alert, .sound, .badge]) { (granted, _) in
                                    if granted {
                                        UserDefaults.standard.set(true, forKey: "isNotificationOn")
                                        NotificationCenter.default.post(name: NSNotification.Name("isNotificationOn"), object: nil)
                                    } else {
                                        self.isNotificationOn = false
                                        UserDefaults.standard.set(false, forKey: "isNotificationOn")
                                        NotificationCenter.default.post(name: NSNotification.Name("isNotificationOn"), object: nil)
                                    }
                                }
                        } else {
                            UserDefaults.standard.set(false, forKey: "isNotificationOn")
                            NotificationCenter.default.post(name: NSNotification.Name("isNotificationOn"), object: nil)
                        }
                    }
                    .padding(.vertical)
                    
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
                
                Spacer(minLength:  0)
                
                Group {
                    NavigationLink(destination: ProfileEditView(isEditOn: self.$isEditOn), isActive: self.$isEditOn) {
                        Text("登録情報変更")
                            .foregroundColor(.white)
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width - 50)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(.top, 5)
                        
                    }.navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)
                    
                    Button(action:{
                        try! Auth.auth().signOut()
                        UserDefaults.standard.set(false, forKey: "isLoggedin")
                        NotificationCenter.default.post(name: NSNotification.Name("isLoggedin"), object: nil)
                        
                    }) {
                        Text("ログアウト")
                            .foregroundColor(.white)
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width - 50)
                            .background(Color.red)
                            .cornerRadius(10)
                            .padding(.top, 5)
                    }
                }
            }.padding(25)
        }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            fireauth.getData()
            NotificationCenter.default.addObserver(forName: NSNotification.Name("isNotificationOn"), object: nil, queue: .main) { (_) in
                self.isNotificationOn = UserDefaults.standard.value(forKey: "isNotificationOn") as? Bool ?? false
            }
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}

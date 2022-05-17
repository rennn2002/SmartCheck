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
    var notification: Notification = Notification()
    
    @State var isEditOn: Bool = false
    
    @State var isNotificationOn: Bool = UserDefaults.standard.value(forKey: "isNotificationOn") as? Bool ?? false
    
    @State var notificationTime: Date = Date()
    @State var notificationTimeStr: String = ""
    
    @State var notificationTimeHour: Int = UserDefaults.standard.value(forKey: "notificationTimeHour") as? Int ?? 8
    @State var notificationTimeMinute: Int = UserDefaults.standard.value(forKey: "notificationTimeMinute") as? Int ?? 0
    
    @State private var showingAlert = false
    
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
                                
                                UNUserNotificationCenter.current()
                                    .requestAuthorization(options: [.alert, .sound, .badge]) { (granted, _) in
                                        
                                    }
                                UserDefaults.standard.set(true, forKey: "isNotificationOn")
                                NotificationCenter.default.post(name: NSNotification.Name("isNotificationOn"), object: nil)
                            } else {
                                UserDefaults.standard.set(false, forKey: "isNotificationOn")
                                NotificationCenter.default.post(name: NSNotification.Name("isNotificationOn"), object: nil)
                            }
                        }
                        //                            Button(action:{
                        //                                UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound, .badge]){
                        //                                    (granted, _) in
                        //                                    if granted {
                        //
                        //                                        self.notification.makeNotificationOnDemand()
                        //                                    }else {
                        //
                        //                                    }
                        //                                }
                        //                            }) {
                        //                                Text("通知送信テスト(アプリを閉じてください)")
                        //                            }
                        
                        DatePicker(selection: self.$notificationTime, displayedComponents: .hourAndMinute, label: {Text("通知時刻").fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/) })
                            .onChange(of: self.notificationTime) { newValue in
                                let dateFormatter = DateFormatter()
                                dateFormatter.locale = Locale(identifier: "ja_JP")
                                dateFormatter.dateStyle = .medium
                                dateFormatter.dateFormat = "H"
                                self.notificationTimeHour = Int(dateFormatter.string(from: newValue))!
                                dateFormatter.dateFormat = "m"
                                self.notificationTimeMinute = Int(dateFormatter.string(from: newValue))!
//                                print(String(self.notificationTimeHour))
//                                print(String(self.notificationTimeMinute))
                                UserDefaults.standard.set(self.notificationTimeHour, forKey: "notificationTimeHour")
                                NotificationCenter.default.post(name: NSNotification.Name("notificationTimeHour"), object: nil)
                                UserDefaults.standard.set(self.notificationTimeMinute, forKey: "notificationTimeMinute")
                                NotificationCenter.default.post(name: NSNotification.Name("notificationTimeMinute"), object: nil)
                            }
                    }
                    Section(header: Text("アカウント設定")) {
                        NavigationLink(destination: ProfileEditView(isEditOn: self.$isEditOn), isActive: self.$isEditOn) {
                            Text("登録情報変更")
                                .foregroundColor(.blue)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            
                        }.navigationBarHidden(true)
                            .navigationBarBackButtonHidden(true)
                            .navigationBarTitleDisplayMode(.inline)
                        
                        Button(action:{
                            self.showingAlert = true
                        }) {
                            HStack {
                                Image(systemName: "square.and.pencil")
                                    .foregroundColor(Color(red: 119/255, green: 140/255, blue: 236/255))
                                Text("ログアウト")
                                    .foregroundColor(Color(red: 119/255, green: 140/255, blue: 236/255))
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            }.alert(isPresented: self.$showingAlert) {
                                Alert(title: Text("確認"),
                                      message: Text("ログアウトしますか？"),
                                      primaryButton: .cancel(Text("キャンセル")),
                                      secondaryButton: .destructive(Text("ログアウト"), action: {
                                    GIDSignIn.sharedInstance.signOut()
                                    try! Auth.auth().signOut()
                                    UserDefaults.standard.set(false, forKey: "isLoggedin")
                                    NotificationCenter.default.post(name: NSNotification.Name("isLoggedin"), object: nil)}))
                            }
                        }
                        
                    }.navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
                    
                }
                
                Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
            }.navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
        }
        .onAppear {
            fireauth.getData { _, _ in
                
            }
            NotificationCenter.default.addObserver(forName: NSNotification.Name("isNotificationOn"), object: nil, queue: .main) { (_) in
                self.isNotificationOn = UserDefaults.standard.value(forKey: "isNotificationOn") as? Bool ?? false
            }
            NotificationCenter.default.addObserver(forName: NSNotification.Name("notificationTimeHour"), object: nil, queue: .main) { (_) in
                self.notificationTimeHour = UserDefaults.standard.value(forKey: "notificationTimeHour") as? Int ?? 8
            }
            NotificationCenter.default.addObserver(forName: NSNotification.Name("notificationTimeMinute"), object: nil, queue: .main) { (_) in
                self.notificationTimeMinute = UserDefaults.standard.value(forKey: "notificationTimeMinute") as? Int ?? 0
            }
            let notificationTimeStr = String(self.notificationTimeHour) + ":" + String(self.notificationTimeMinute)
            self.notificationTime = DateUtils.dateFromString(string: notificationTimeStr, format: "H:m")
        }
        }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}

class DateUtils {
    class func dateFromString(string: String, format: String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.date(from: string)!
    }
}

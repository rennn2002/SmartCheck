//
//  GuidanceView.swift
//  Health Check
//
//  Created by Nomura Rentaro on 2021/10/07.
//

import SwiftUI

struct GuidanceView: View {
    let backGroundColor = LinearGradient(gradient: Gradient(colors: [Color(red: 82/255, green: 178/255, blue: 245/255), Color(red: 158/255, green: 118/255, blue: 226/255)]), startPoint: .topLeading, endPoint: .bottom)
    var body: some View {
        ZStack {
            backGroundColor.edgesIgnoringSafeArea(.all)
            VStack {
                VStack {
                    Text("Health Checkへようこそ")
                        .foregroundColor(.white)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(25)
                    
                    Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                    
                    Image("notifications")
                        .resizable()
                        .frame(width: 300, height: 300)
                    
                    Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                    
                    Text("健康観察を忘れていませんか？Health Checkなら通知でお知らせします")
                        .foregroundColor(.white)
                        .font(.title2)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    
                }.padding(.horizontal, 25)
                Button(action:{
                    UserDefaults.standard.set(false, forKey: "isNotificationOn")
                    NotificationCenter.default.post(name: NSNotification.Name("isNotificationOn"), object: nil)
                    
                    UserDefaults.standard.set(false, forKey: "isSignedup")
                    NotificationCenter.default.post(name: NSNotification.Name("isSignedup"), object: nil)
                    UserDefaults.standard.set(true, forKey: "isLoggedin")
                    NotificationCenter.default.post(name: NSNotification.Name("isLoggedin"), object: nil)
                    UserDefaults.standard.set(false, forKey: "isGuidanceShow")
                    NotificationCenter.default.post(name: NSNotification.Name("isGuidanceShow"), object: nil)
                }) {
                    Text("また後で設定する")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding(.top, 25)
                }
                Button(action:{
                    UNUserNotificationCenter.current()
                        .requestAuthorization(options: [.alert, .sound, .badge]) { (granted, _) in
                            print("Permission granted: \(granted)")
                        }
                    UserDefaults.standard.set(true, forKey: "isNotificationOn")
                    NotificationCenter.default.post(name: NSNotification.Name("isNotificationOn"), object: nil)
                    
                    UserDefaults.standard.set(false, forKey: "isSignedup")
                    NotificationCenter.default.post(name: NSNotification.Name("isSignedup"), object: nil)
                    UserDefaults.standard.set(true, forKey: "isLoggedin")
                    NotificationCenter.default.post(name: NSNotification.Name("isLoggedin"), object: nil)
                    UserDefaults.standard.set(false, forKey: "isGuidanceShow")
                    NotificationCenter.default.post(name: NSNotification.Name("isGuidanceShow"), object: nil)
                }) {
                    Text("通知を許可する")
                        .foregroundColor(.white)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
        }
    }
}

struct GuidanceView_Previews: PreviewProvider {
    static var previews: some View {
        GuidanceView()
    }
}

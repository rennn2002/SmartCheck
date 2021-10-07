//
//  LaunchView.swift
//  Health Check
//
//  Created by Nomura Rentaro on 2021/09/28.
//

import SwiftUI

struct LaunchView: View {
    @State var showLogin = false
    @State var showSignup = false
    @State var isLoggedin = UserDefaults.standard.value(forKey: "isLoggedin") as? Bool ?? false
    @State var isSignedup = UserDefaults.standard.value(forKey: "isSignedup") as? Bool ?? false
    @State var isGuidanceShow = UserDefaults.standard.value(forKey: "isGuidanceShow") as? Bool ?? false
    
    //var googleauth: GoogleAuth = GoogleAuth()
    
    var body: some View {
        NavigationView {
            VStack {
                if self.isLoggedin {
                    HomeView()
                } else if self.isSignedup {
                    ProfileInitView()
                } else if self.isGuidanceShow {
                    GuidanceView()
                } else {
                    Text("健康観察入力アプリ")
                        .font(.largeTitle)
                        .fontWeight(.bold)
//                    Text("聖マリアンナ医科大学")
//                        .font(.title3)
//                        .foregroundColor(.gray)
//                        .fontWeight(.bold)
                    
                    Spacer(minLength: 30)
                        .fixedSize()
                    Image("health-check")
                        .resizable()
                        .frame(width:200, height:200)
                    
                    Spacer(minLength:80)
                        .fixedSize()
                    
                    NavigationLink(destination: LoginView(showLogin: self.$showLogin), isActive: self.$showLogin)  {
                        Text("ログイン")
                            .foregroundColor(.white)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.vertical)
                            .frame(width:UIScreen.main.bounds.width - 50)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(.top, 25)
                        
                    }
                    
                    NavigationLink(destination: SignupView(showSignup: self.$showSignup), isActive: self.$showSignup)  {
                        Text("新規登録")
                            .foregroundColor(.white)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.vertical)
                            .frame(width:UIScreen.main.bounds.width - 50)
                            .background(Color.green)
                            .cornerRadius(10)
                            .padding(.top, 25)
                    }
                   
   
                    //GoogleSignInButtonViewController()
                }
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }.navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            NotificationCenter.default.addObserver(forName: NSNotification.Name("isLoggedin"), object: nil, queue: .main) { (_) in
                self.isLoggedin = UserDefaults.standard.value(forKey: "isLoggedin") as? Bool ?? false
            }
            NotificationCenter.default.addObserver(forName: NSNotification.Name("isSignedup"), object: nil, queue: .main) { (_) in
                self.isSignedup = UserDefaults.standard.value(forKey: "isSignedup") as? Bool ?? false
            }
            NotificationCenter.default.addObserver(forName: NSNotification.Name("isGuidanceShow"), object: nil, queue: .main) { (_) in
                self.isGuidanceShow = UserDefaults.standard.value(forKey: "isGuidanceShow") as? Bool ?? false
            }
        }
    }
}

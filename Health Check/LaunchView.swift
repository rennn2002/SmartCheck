//
//  LaunchView.swift
//  Health Check
//
//  Created by Nomura Rentaro on 2021/09/28.
//

import SwiftUI
import GoogleSignIn
import FirebaseAuth

struct LaunchView: View {
    @State var showLogin = false
    @State var showSignup = false
    @State var isLoggedin = UserDefaults.standard.value(forKey: "isLoggedin") as? Bool ?? false
    @State var isSignedup = UserDefaults.standard.value(forKey: "isSignedup") as? Bool ?? false
    @State var isGuidanceShow = UserDefaults.standard.value(forKey: "isGuidanceShow") as? Bool ?? false
    @State var isWaitingShow = UserDefaults.standard.value(forKey: "isWaitingShow") as? Bool ?? false
    @State var isNotificationDerived = UserDefaults.standard.value(forKey: "isNotificationDerived") as? Int ?? 0
    
    //var googleauth: GoogleAuth = GoogleAuth()
    let backGroundColor = Color(red: 96/255, green: 123/255, blue: 184/255)
    
    var body: some View {
        NavigationView {
            ZStack {
                backGroundColor.edgesIgnoringSafeArea(.all)
                VStack {
                    if self.isLoggedin {
                        HomeView()
                    } else if self.isWaitingShow {
                        WaitingView()
                    } else if self.isSignedup {
                        ProfileInitView()
                    } else if self.isGuidanceShow {
                        GuidanceView()
                    } else {
                        Spacer(minLength:0)
                        Text("健康観察入力アプリ")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding()
                        //                    Text("聖マリアンナ医科大学")
                        //                        .font(.title3)
                        //                        .foregroundColor(.gray)
                        //                        .fontWeight(.bold)
                        Spacer(minLength:0)
                        
                        Image("health-check")
                            .resizable()
                            .frame(width:UIScreen.main.bounds.width*0.7, height:UIScreen.main.bounds.width*0.7)
                        
                        Spacer(minLength:0)
                        
                        NavigationLink(destination: SignupView(showSignup: self.$showSignup), isActive: self.$showSignup)  {
                            Text("新規登録")
                                .foregroundColor(.white)
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.vertical)
                                .frame(width:UIScreen.main.bounds.width - 50)
                                .background(Color(red: 119/255, green: 140/255, blue: 236/255))
                                .cornerRadius(50)
                                .padding(.top, 25)
                        }
                        
                        NavigationLink(destination: LoginView(showLogin: self.$showLogin), isActive: self.$showLogin)  {
                            Text("ログイン")
                                .foregroundColor(.white)
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.vertical)
                                .frame(width:UIScreen.main.bounds.width - 50)
                                .background(Color(red: 62/255, green: 74/255, blue: 141/255))
                                .cornerRadius(50)
                                .padding(.top, 25)
                            
                        }
                        
                        Button(action:{
                            GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.first?.rootViewController
                            GIDSignIn.sharedInstance()?.signIn()
                        }) {
                            HStack {
                                Image("google-color")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.white)
                                
                                Spacer(minLength: 25)
                                    .fixedSize()
                                Text("Google Sign-In")
                                    .foregroundColor(.gray)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .padding(.vertical)
                            }.frame(width:UIScreen.main.bounds.width - 60)
                            .clipShape(Capsule())
                            .background(Color.white)
                            .cornerRadius(50)
                            .padding(.top, 25)
                        }
                        Spacer(minLength:30)
                    }
                }
                
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
            }
        }.navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            UIApplication.shared.applicationIconBadgeNumber = 0 
            NotificationCenter.default.addObserver(forName: NSNotification.Name("isLoggedin"), object: nil, queue: .main) { (_) in
                self.isLoggedin = UserDefaults.standard.value(forKey: "isLoggedin") as? Bool ?? false
            }
            NotificationCenter.default.addObserver(forName: NSNotification.Name("isSignedup"), object: nil, queue: .main) { (_) in
                self.isSignedup = UserDefaults.standard.value(forKey: "isSignedup") as? Bool ?? false
            }
            NotificationCenter.default.addObserver(forName: NSNotification.Name("isGuidanceShow"), object: nil, queue: .main) { (_) in
                self.isGuidanceShow = UserDefaults.standard.value(forKey: "isGuidanceShow") as? Bool ?? false
            }
            NotificationCenter.default.addObserver(forName: NSNotification.Name("isWaitingShow"), object: nil, queue: .main) { (_) in
                self.isWaitingShow = UserDefaults.standard.value(forKey: "isWaitingShow") as? Bool ?? false
            }
            NotificationCenter.default.addObserver(forName: NSNotification.Name("isNotificationDerived"), object: nil, queue: .main) { (_) in
                self.isNotificationDerived = UserDefaults.standard.value(forKey: "isNotificationDerived") as? Int ?? 0
            }
        }
    }
}

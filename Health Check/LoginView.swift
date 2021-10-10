//
//  LoginView.swift
//  Health Check
//
//  Created by Nomura Rentaro on 2021/09/28.
//

import SwiftUI

struct LoginView: View {
    
    @Binding var showLogin: Bool
    @State var mail: String = ""
    @State var password: String = ""
    @State var visible: Bool = false
    var fireauth:FireAuth = FireAuth()
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack {
               Text("ログイン")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
                
                Spacer(minLength: 50)
                    .fixedSize()
                
                Group {
                    HStack {
                        Text("メールアドレス:")
                        Spacer(minLength: 0)
                    }.padding(.bottom, -20)
                    TextField("メールアドレス", text: self.$mail)
                    .autocapitalization(.none)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 4).stroke(self.mail != "" ? Color(red: 62/255, green: 74/255, blue: 141/255) : Color.gray ,lineWidth: 2))
                        .padding(.top, 25)
                }
                Spacer(minLength: 20)
                    .fixedSize()
                Group {
                    HStack {
                        Text("パスワード:")
                        Spacer(minLength: 0)
                    }.padding(.bottom, -20)
                    HStack(spacing:15) {
                        VStack{
                            
                            if self.visible{
                                
                                TextField("パスワード", text: self.$password)
                                .autocapitalization(.none)
                            } else {
                                
                                SecureField("パスワード", text: self.$password)
                                .autocapitalization(.none)
                            }
                        }
                        
                        Button(action: {    
                            self.visible.toggle()
                        }) {
                            Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(Color.gray)
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 4).stroke(self.password != "" ? Color(red: 62/255, green: 74/255, blue: 141/255) : Color.gray ,lineWidth: 2))
                    .padding(.top, 25)
                }
                Spacer(minLength: 20)
                    .fixedSize()
                
                Button(action:{
                    fireauth.login(mail: self.mail, password: self.password) { result in
                    }
                }
                ) {
                    Text("ログイン")
                        .foregroundColor(.white)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 50)
                        .background(Color(red: 62/255, green: 74/255, blue: 141/255))
                        .cornerRadius(10)
                        .padding(.top, 25)
                }
                Spacer(minLength: 0)
            }.padding(.horizontal, 25)
            
            Button(action: {self.showLogin.toggle()}) {
                Image(systemName: "chevron.left")
                    .font(.title)
                    .foregroundColor(.black)
            }.padding()
            
        }.navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

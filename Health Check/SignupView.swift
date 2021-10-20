//
//  SignupView.swift
//  Health Check
//
//  Created by Nomura Rentaro on 2021/09/28.
//

import SwiftUI

struct SignupView: View {
    
    @Binding var showSignup: Bool
    @State var mail: String = ""
    @State var visible: Bool = false
    @State var revisible: Bool = false
    @State var password: String = ""
    @State var rePassword: String = ""
    @State var alert: Bool = false
    @State var error: String = "NO ERROR"
    @State var buttonColor: Color = Color(red: 119/255, green: 140/255, blue: 236/255)
    
    var fireauth:FireAuth = FireAuth()
    
    var body: some View {
        ZStack(alignment: .center) {
            
            ZStack(alignment: .topLeading) {
                VStack {
                    Text("ユーザー登録")
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
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.mail != "" ? Color(red: 119/255, green: 140/255, blue: 236/255) : Color.gray ,lineWidth: 2))
                            .padding(.top, 25)
                        Spacer(minLength: 20)
                            .fixedSize()
                    }
                    
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
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.password != "" ? Color(red: 119/255, green: 140/255, blue: 236/255) : Color.gray ,lineWidth: 2))
                        .padding(.top, 25)
                        Spacer(minLength: 20)
                            .fixedSize()
                    }
                    
                    Group {
                        HStack {
                            Text("パスワード(確認):")
                            Spacer(minLength: 0)
                        }.padding(.bottom, -20)
                        HStack(spacing:15) {
                            VStack{
                                
                                if self.revisible{
                                    
                                    TextField("パスワード(確認)", text: self.$rePassword)
                                        .autocapitalization(.none)
                                } else {
                                    
                                    SecureField("パスワード(確認)", text: self.$rePassword)
                                        .autocapitalization(.none)
                                }
                            }
                            
                            Button(action: {
                                
                                self.revisible.toggle()
                                
                            }) {
                                
                                Image(systemName: self.revisible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(Color.gray)
                            }
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.rePassword != "" ? Color(red: 119/255, green: 140/255, blue: 236/255) : Color.gray ,lineWidth: 2))
                        .padding(.top, 25)
                        
                        Spacer(minLength: 20)
                            .fixedSize()
                    }
                    
                    Button(action:{
                        if self.mail != "" && self.password != "" && self.rePassword != "" {
                            if self.password == self.rePassword {
                                fireauth.signup(mail: self.mail, password: self.password) { result, error in
                                    if result {
                                        // NO ERROR
                                    } else {
                                        //SIGN UP ERROR
                                        self.alert.toggle()
                                        self.error = error
                                    }
                                }
                            }else {
                                //NOT MATCH
                                self.alert.toggle()
                                self.error = "NOT MATCH"
                            }
                        } else {
                            // NOT FILEED
                            self.alert.toggle()
                            self.error = "NOT FILLED"
                        }
                    }
                    ) {
                        Text("登録")
                            .foregroundColor(.white)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width - 50)
                            .background(Color(red: 119/255, green: 140/255, blue: 236/255))
                            .cornerRadius(10)
                            .padding(.top, 25)
                    }
                    Spacer(minLength: 0)
                }.padding(.horizontal, 25)
                
                Button(action: {self.showSignup.toggle()}) {
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .foregroundColor(.black)
                }.padding()
                
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            if self.alert {
                ErrorView(alert: self.$alert, error: self.$error, buttonColor: self.$buttonColor)
            }
        }
    }
}

//
//  ContentView.swift
//  Health Check
//
//  Created by Nomura Rentaro on 2021/09/29.
//

import SwiftUI
import GoogleSignIn
import Foundation

struct FormView: View {
    @State var bodyTemp: Double = UserDefaults.standard.object(forKey: "normalBodyTemp") as? Double ?? 36.5
    @State var bodyTempNum: Int = 0
    @State var bodyTempPoint: Int = 0
    @State var isPickerShow: Bool = false
    @State var symptom: Bool = false
    @State var term: Bool = false
    @State var isTermShow: Bool = false
    
    @State var isFormPosted: Bool = UserDefaults.standard.value(forKey: "isFormPosted") as? Bool ?? false
    
    @State var alert: Bool = false
    @State var error: String = "NO ERROR"
    @State var buttonColor: Color = Color.green
    
    @State var isLoading: Bool = false
    
    @State var firstname: String = ""
    @State var lastname: String = ""
    @State var schoolid: Int = 0
    @State var studentid: Int = 0
    
    @State var postTime: String = "not provided"
    @State var currentTime: String = "not provided"
    @State var postDay: Date = Date()
    
    @State var currentDay: String = ""
    @State var postDate: String = ""
    
    @Binding var isResend: Bool
    
    var fireauth: FireAuth = FireAuth()
    @ObservedObject var firestore: FireStore = FireStore()
    
    var body: some View {
        NavigationView {
            VStack {
                if self.isFormPosted {
                    CheckFormView(isResend: self.$isResend)
                } else {
                    ZStack() {
                        GeometryReader { geometry in
                            
                            VStack(alignment: .center) {
                                Text("入力フォーム")
                                    .font(.title)
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    .padding()
                                Divider()
                                
                                ScrollView {
                                    HStack {
                                        Text("体温")
                                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                            .padding(.vertical, 25)
                                        Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                                    }
                                    
                                    Text(String(Float(self.bodyTempNum + 35)+(Float(self.bodyTempPoint)/10)))
                                        .font(.largeTitle)
                                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                        .frame(width: UIScreen.main.bounds.width - 50, height: 50)
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            self.isPickerShow.toggle()
                                        }
                                    
                                    Spacer(minLength: 20)
                                        .fixedSize()
                                    
                                    if self.isPickerShow {
                                        HStack(spacing:0) {
                                            Picker(selection: self.$bodyTempNum, label: EmptyView()) {
                                                ForEach(35 ..< 41) {
                                                    Text("\($0)")
                                                }
                                            }.frame(maxWidth: geometry.size.width/2-25, maxHeight: 120)
                                                .clipped()
                                            
                                            Picker(selection: self.$bodyTempPoint, label: EmptyView()) {
                                                ForEach(0 ..< 10) {
                                                    Text("\($0)")
                                                }
                                            }.frame(maxWidth: geometry.size.width/2-25, maxHeight: 120)
                                                .clipped()
                                        }.onTapGesture {
                                            self.isPickerShow.toggle()
                                        }
                                        .pickerStyle(.wheel)    // set PickerStyle to wheel
                                    }
                                    Group {
                                        HStack {
                                            Text("自覚症状")
                                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                            
                                            Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                                        }.padding(.vertical)
                                        
                                        Picker("Gender", selection: self.$symptom) {
                                            Text("体温37.5未満で自覚症状なし").tag(false)
                                            Text("自覚症状がある").tag(true)
                                        }.pickerStyle(SegmentedPickerStyle())
                                        
                                    }
                                    Group {
                                        HStack {
                                            Text("規約")
                                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                                .padding(.vertical, 10)
                                            
                                            Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                                        }.padding(.vertical)
                                        Text("規約はこちら")
                                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                                            .onTapGesture {
                                                self.isTermShow.toggle()
                                            }.sheet(isPresented: self.$isTermShow) {
                                                ZStack(alignment: .topLeading) {
                                                    VStack {
                                                        ModalTermsView().padding(.vertical, 50)
                                                        Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                                                    }
                                                    Button(action: {self.isTermShow.toggle()}) {
                                                        Text("Close")
                                                            .fontWeight(.bold)
                                                    }
                                                }.padding(25)
                                            }
                                        
                                        Toggle(isOn: self.$term) {
                                            Text("上記個人情報の提供について同意し回答します")
                                                .font(.footnote)
                                                .fontWeight(.bold)
                                            
                                        }.padding(5)
                                        
                                    }
                                    if self.term {
                                        Button(action:{
                                            fireauth.getData() {_, _ in
                                                //obtain userdata from  fireauth
                                            }
                                            firestore.getUserData(uid: fireauth.uid, completion: { result in
                                                self.firstname = self.firestore.userdata.firstname
                                                self.lastname = self.firestore.userdata.lastname
                                                self.schoolid = self.firestore.userdata.schoolid
                                                self.studentid = self.firestore.userdata.studentid
                                                
                                                if result {
                                                    let dt = Date()
                                                    let dateFormatter = DateFormatter()
                                                    dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMMdHm", options: 0, locale: Locale(identifier: "ja_JP"))
                                                    // convert bodytemp from 2 integers to float value
                                                    self.bodyTemp = Double(Float(self.bodyTempNum + 35)+(Float(self.bodyTempPoint)/10))
                                                    UIApplication.shared.applicationIconBadgeNumber = 0
                                                    firestore.postForm(uid: fireauth.uid, firstname: self.firstname, lastname: self.lastname, schoolid: self.schoolid, studentid: self.studentid, bodytemp: Float(self.bodyTemp), symptom: self.symptom, posttime: dt, mail: self.fireauth.email!) { result, error in
                                                        if result {
                                                            //after submission complete
                                                            self.isLoading = false
                                                            
//                                                            print(self.bodyTemp)
                                                            UserDefaults.standard.set(true, forKey: "isFormPosted")
                                                            NotificationCenter.default.post(name: NSNotification.Name("isFormPosted"), object: nil)
                                                        } else {
                                                            self.isLoading = true
                                                            self.alert.toggle()
                                                            self.error = error
                                                        }
                                                    }
                                                } else {
//                                                    print("still waiting to obtain studentID and schoolID from the firestore")
                                                }
                                            })
                                        }) {
                                            Text("送信")
                                                .foregroundColor(.white)
                                                .font(.title3)
                                                .fontWeight(.bold)
                                                .padding(.vertical)
                                                .frame(width: UIScreen.main.bounds.width - 50, height: 40)
                                                .background(Color.green)
                                                .cornerRadius(10)
                                                .padding(.top, 25)
                                        }.padding(.vertical, 25)
                                    }
                                    
                                    Spacer(minLength: 0)
                                    
                                }
                            }.padding(.horizontal, 25)
                                .navigationBarHidden(true)
                                .navigationBarBackButtonHidden(true)
                            
                        }
                        if self.alert {
                            ErrorView(alert: self.$alert, error: self.$error, buttonColor: self.$buttonColor)
                        }
                    }
                }
            }
            .onAppear() {
                if self.isResend {
                    fireauth.getData() {_, _ in
                        //obtain userdata from  fireauth
                    }
                    firestore.getUserData(uid: fireauth.uid, completion: {result in
                        self.firstname = self.firestore.userdata.firstname
                        self.lastname = self.firestore.userdata.lastname
                        self.schoolid = self.firestore.userdata.schoolid
                        self.studentid = self.firestore.userdata.studentid
                    })
                    
                    NotificationCenter.default.addObserver(forName: NSNotification.Name("normalBodyTemp"), object: nil, queue: .main) { (_) in
                        self.bodyTemp = Double(UserDefaults.standard.value(forKey: "normalBodyTemp") as? Double ?? 36.5)
                    }
                    
                    self.bodyTempNum = Int(floor(self.bodyTemp))
                    self.bodyTemp = round(self.bodyTemp*10)/10
                    self.bodyTempPoint = Int((round((self.bodyTemp - Double(self.bodyTempNum))*10)/10)*10)
                    self.bodyTempNum = self.bodyTempNum - 35
                    
                } else {
                    fireauth.getData() {_, _ in
                        //obtain userdata from  fireauth
                    }
                    firestore.getUserData(uid: fireauth.uid, completion: {result in
                        self.firstname = self.firestore.userdata.firstname
                        self.lastname = self.firestore.userdata.lastname
                        self.schoolid = self.firestore.userdata.schoolid
                        self.studentid = self.firestore.userdata.studentid
                    })
                    
                    firestore.getForm(uid: fireauth.uid) { result in
                        if result {
                            self.isLoading = false
                            self.bodyTemp = firestore.tempdata.bodytemp
                            self.symptom = firestore.tempdata.symptom
                            
                            //convert timestamp to date
                            let date: Date = firestore.tempdata.posttime.dateValue()
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.locale = Locale(identifier: "ja_JP")
                            dateFormatter.dateStyle = .medium
                            dateFormatter.dateFormat = "yyyy/MM/d HH:mm"
                            
                            self.postTime = dateFormatter.string(from: date)
                            
                            dateFormatter.locale = Locale(identifier: "ja_JP")
                            dateFormatter.dateStyle = .medium
                            dateFormatter.dateFormat = "d"
                            self.postDate = dateFormatter.string(from: date)
                            
                            //obtain current time
                            let dt = Date()
                            dateFormatter.locale = Locale(identifier: "ja_JP")
                            dateFormatter.dateStyle = .medium
                            dateFormatter.dateFormat = "yyyy/MM/d HH:mm"
                            
                            self.currentTime = dateFormatter.string(from: dt)
                            dateFormatter.locale = Locale(identifier: "ja_JP")
                            dateFormatter.dateStyle = .medium
                            dateFormatter.dateFormat = "d"
                            self.currentDay = dateFormatter.string(from: dt)
                            
                            
                            //compare current time and post time
                            if self.postDate != self.currentDay {
                                UserDefaults.standard.set(false, forKey: "isFormPosted")
                                NotificationCenter.default.post(name: NSNotification.Name("isFormPosted"), object: nil)
                            } else {
                                UserDefaults.standard.set(true, forKey: "isFormPosted")
                                NotificationCenter.default.post(name: NSNotification.Name("isFormPosted"), object: nil)
                                
                                UIApplication.shared.applicationIconBadgeNumber = 0
                            }
                        } else {
                            self.isLoading = true
                        }
                    }
                    
                    
                    NotificationCenter.default.addObserver(forName: NSNotification.Name("normalBodyTemp"), object: nil, queue: .main) { (_) in
                        self.bodyTemp = Double(UserDefaults.standard.value(forKey: "normalBodyTemp") as? Double ?? 36.5)
                    }
                    NotificationCenter.default.addObserver(forName: NSNotification.Name("isFormPosted"), object: nil, queue: .main) { (_) in
                        self.isFormPosted = UserDefaults.standard.value(forKey:"isFormPosted") as? Bool ?? false
                    }
                    self.bodyTempNum = Int(floor(self.bodyTemp))
                    self.bodyTemp = round(self.bodyTemp*10)/10
                    self.bodyTempPoint = Int((round((self.bodyTemp - Double(self.bodyTempNum))*10)/10)*10)
                    self.bodyTempNum = self.bodyTempNum - 35
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ModalTermsView: View {
    var body: some View {
        VStack {
            Text("規約")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .padding(10)
            Divider()
            Text("これは、学生自身の体調を管理するための健康観察チェックです。毎日、朝の検温と健康状態の確認をしたうえで、登校前までに必ず入力をお願いいたします。なお、いただいた情報は業務以外の目的には使用いたしません。")
        }
        
    }
}

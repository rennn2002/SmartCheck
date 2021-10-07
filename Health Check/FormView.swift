//
//  ContentView.swift
//  Health Check
//
//  Created by Nomura Rentaro on 2021/09/29.
//

import SwiftUI

struct FormView: View {
    @State var bodyTemp: Float = UserDefaults.standard.object(forKey: "nomalBodyTemp") as? Float ?? 36.5
    @State var bodyTempNum: Int = 0
    @State var bodyTempPoint: Int = 0
    
    @State var isPickerShow: Bool = false
    @State var symptom: Bool = false
    @State var term: Bool = false
    @State var isTermShow: Bool = false
    
    @State var isFormPosted: Bool = UserDefaults.standard.value(forKey: "isFormPosted") as? Bool ?? false
    
    var fireauth: FireAuth = FireAuth()
    @ObservedObject var firestore: FireStore = FireStore()
    
    var body: some View {
        VStack {
            if self.isFormPosted {
                CheckFormView()
            } else {
                GeometryReader { geometry in
                    ScrollView {
                        VStack(alignment: .center) {
                            Text("入力フォーム")
                                .font(.title)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .padding()
                            Divider()
                            
                            
                            HStack {
                                Text("体温")
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    .padding(.vertical, 25)
                                Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                            }
                            
                            Text(String(Float(self.bodyTempNum + 35)+(Float(self.bodyTempPoint)/10)))
                                .font(.largeTitle)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
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
                                    }.frame(maxWidth: geometry.size.width/2-25)
                                    .clipped()
                                    Picker(selection: self.$bodyTempPoint, label: EmptyView()) {
                                        ForEach(0 ..< 10) {
                                            Text("\($0)")
                                        }
                                    }.frame(maxWidth: geometry.size.width/2-25)
                                    .clipped()
                                }
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
                                
                                HStack {
                                    Toggle(isOn: self.$term) {
                                        Text("上記個人情報の提供について同意し回答します")
                                            .font(.footnote)
                                    }
                                }.padding(.vertical, 20)
                            }
                            if self.term {
                                Button(action:{
                                    self.bodyTemp = Float(self.bodyTempNum + 35)+(Float(self.bodyTempPoint)/10)
                                    print(self.bodyTemp)
                                    UserDefaults.standard.set(true, forKey: "isFormPosted")
                                    NotificationCenter.default.post(name: NSNotification.Name("isFormPosted"), object: nil)
                                    fireauth.getData()
                                    let dt = Date()
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMMdHm", options: 0, locale: Locale(identifier: "ja_JP"))
                                    firestore.postForm(uid: fireauth.uid, bodytemp: self.bodyTemp ,symptom: self.symptom, posttime: dt)
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
                                }
                            }
                            Spacer(minLength: 0)
                        }.padding(.horizontal, 25)
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
                    }
                }
            }
        }
        .onAppear() {
            NotificationCenter.default.addObserver(forName: NSNotification.Name("nomalBodyTemp"), object: nil, queue: .main) { (_) in
                self.bodyTemp = UserDefaults.standard.value(forKey: "nomalBodyTemp") as? Float ?? 36.5
            }
            NotificationCenter.default.addObserver(forName: NSNotification.Name("isFormPosted"), object: nil, queue: .main) { (_) in
                self.isFormPosted = UserDefaults.standard.value(forKey:"isFormPosted") as? Bool ?? false
            }
            self.bodyTempNum = Int(floor(self.bodyTemp))
            print(Float(self.bodyTempNum))
            self.bodyTemp = round(self.bodyTemp*10)/10
            print(bodyTemp)
            self.bodyTempPoint = Int((round((self.bodyTemp - Float(self.bodyTempNum))*10)/10)*10)
            print(self.bodyTemp - Float(self.bodyTempNum))
            print(bodyTempPoint)
            self.bodyTempNum = self.bodyTempNum - 35
        }
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

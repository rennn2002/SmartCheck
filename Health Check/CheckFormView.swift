//
//  CheckFormView.swift
//  Health Check
//
//  Created by Nomura Rentaro on 2021/09/28.
//

import SwiftUI

struct CheckFormView: View {
    @State var bodyTemp: Float = 0.0
    @State var symptom: Bool = false
    @State var postTime: String = "not provided"
    @State var currentTime: String = "not provided"
    @State var postDay: Date = Date()
    
    @State var currentDay: String = ""
    @State var postDate: String = ""
    
    @State var isLoading: Bool = false
    
    @State var showingAlert: Bool = false
    
    @Binding var isResend: Bool
    
    var fireauth: FireAuth = FireAuth()
    @ObservedObject var firestore: FireStore = FireStore()
    
    //private var user = UIDocument.userActivityURLKey
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Image("check")
                        .resizable()
                        .frame(width:UIScreen.main.bounds.width*0.35, height: UIScreen.main.bounds.width*0.35)
                    
                    Text("送信されました")
                        .foregroundColor(.green)
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Spacer(minLength: 30)
                        .fixedSize()
                    
                    HStack {
                        Text("体温：")
                            .fontWeight(.bold)
                            .font(.title3)
                        Text(String(firestore.tempdata.bodytemp))
                            .fontWeight(.bold)
                            .font(.title3)
                    }.padding(2.5)
                    
                    HStack {
                        Text("自覚症状：")
                            .fontWeight(.bold)
                            .font(.title3)
                        Text(firestore.tempdata.symptom ? "あり":"なし")
                            .fontWeight(.bold)
                            .font(.title3)
                    }.padding(2.5)
                    
                    HStack {
                        Text("提出時間：")
                            .fontWeight(.bold)
                            .font(.title3)
                        Text(self.postTime)
                            .fontWeight(.bold)
                            .font(.title3)
                    }.padding(2.5)
                    
                    Spacer(minLength: 0)
                    
                    Button(action: {
                        self.showingAlert.toggle()
                        //                UserDefaults.standard.set(false, forKey: "isFormPosted")
                        //                NotificationCenter.default.post(name: NSNotification.Name("isFormPosted"), object: nil)
                    }) {
                        Text("再提出")
                            .font(.body)
                            .foregroundColor(.blue)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .alert(isPresented: self.$showingAlert) {
                                Alert(title: Text("確認"),
                                      message: Text("提出フォームを再開しますか？"),
                                      primaryButton: .cancel(Text("キャンセル")),
                                      secondaryButton: .destructive(Text("再開"), action: {
                                    self.isResend = true
                                    UserDefaults.standard.set(false, forKey: "isFormPosted")
                                    NotificationCenter.default.post(name: NSNotification.Name("isFormPosted"), object: nil)
                                })
                                )}
                    }.padding(25)
                }.onAppear {
                    fireauth.getData() { _, _ in
                        
                    }
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
                }
                
                if self.isLoading {
                    //   LoadingView(isLoading: self.$isLoading)
                }
            }
        }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .navigationViewStyle(StackNavigationViewStyle())
    }
}

//struct CheckFormView_Previews: PreviewProvider {
//    static var previews: some View {
//        CheckFormView()
//    }
//}

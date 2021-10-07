//
//  HomeView.swift
//  Health Check
//
//  Created by Nomura Rentaro on 2021/09/28.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct HomeView: View {

    @State var tabState: Int = 0
    
    var body: some View {
        TabView(selection: self.$tabState) {
            MainView().tabItem {
                    Image(systemName: "square.and.pencil")
                    Text("フォーム")
                }.tag(1)
            
            DetailView().tabItem {
                Image(systemName: "person.fill")
                Text("データ")
            }.tag(2)
            
            SettingView().tabItem {
                Image(systemName:"gear")
                Text("設定")
            }.tag(3)
        }
    }
}

struct DetailView: View {
    var fireauth: FireAuth = FireAuth()
    @ObservedObject var firestore: FireStore = FireStore()
    @State var isEditOn: Bool = false
    
    @State var firstname: String = ""
    @State var lastname: String = ""
    @State var studentid: Int = 0
    @State var schoolid: Int = 0
    @State var grade: Int = 1
    @State var nomalBodyTemp: Float = 36.5
    @State var genderStr: String = "男性"
    
    var body: some View {
        NavigationView {
            VStack {
                Text("登録情報")
                    .font(.title)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .padding()
                
                Divider()
                ScrollView {
                    VStack {
                    Group {
                        Text("氏名")
                            .font(.title3)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        Spacer(minLength: 10)
                            .fixedSize()
                        HStack {
                            Text(self.lastname)
                            .font(.title3)
                        
                        Text(self.firstname)
                            .font(.title3)
                        }
                        Spacer(minLength: 20)
                            .fixedSize()
                    }
                    Group {
                        Text("メール")
                            .font(.title3)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        Spacer(minLength: 10)
                            .fixedSize()
                        Text(String(firestore.userdata.mail))
                            .font(.title3)
                        Spacer(minLength: 20)
                            .fixedSize()
                    }
                    
                    Group {
                        Text("平熱")
                            .font(.title3)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        Spacer(minLength: 10)
                            .fixedSize()
                        Text(String(self.nomalBodyTemp))
                            .font(.title3)
                        Spacer(minLength: 20)
                            .fixedSize()
                    }
                    
                    Group {
                        Text("性別")
                            .font(.title3)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        Spacer(minLength: 10)
                            .fixedSize()
                        Text(self.genderStr)
                            .font(.title3)
                        Spacer(minLength: 20)
                            .fixedSize()
                    }
                    Group {
                        Group {
                            Text("学籍番号")
                                .font(.title3)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            Spacer(minLength: 10)
                                .fixedSize()
                            Text(String(self.schoolid))
                                .font(.title3)
                            Spacer(minLength: 20)
                                .fixedSize()
                        }
                        Group {
                            Text("学生番号")
                                .font(.title3)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            Spacer(minLength: 10)
                                .fixedSize()
                            Text(String(self.studentid))
                                .font(.title3)
                            Spacer(minLength: 20)
                                .fixedSize()
                        }
                    }
                }
                }
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                .padding()
                Spacer(minLength: 0)
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
                fireauth.getData()
            firestore.getUserData(uid: fireauth.uid) { result in
                self.firstname = self.firestore.userdata.firstname
                self.lastname = self.firestore.userdata.lastname
                self.nomalBodyTemp = self.firestore.userdata.nomalbodytemp
                self.genderStr = self.firestore.userdata.gender
                self.schoolid = self.firestore.userdata.schoolid
                self.studentid = self.firestore.userdata.studentid
            }
        }
    }
}

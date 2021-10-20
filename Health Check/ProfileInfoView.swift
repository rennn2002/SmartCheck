//
//  ProfileListView.swift
//  Health Check
//
//  Created by Nomura Rentaro on 2021/10/08.
//

import SwiftUI

struct ProfileInfoView: View {
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
    
    @State var isProfileShow: Bool = false
    
    var security: Security = Security()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("登録情報")
                    .font(.title)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .padding()
                    
                if isProfileShow {
                    VStack {
                        Form {
                            Section(header:Text("氏名")) {
                                Text("\(self.lastname) \(self.firstname)")
                            }
                            Section(header:Text("メールアドレス")) {
                                Text(firestore.userdata.mail)
                            }
                            Section(header:Text("平熱")) {
                                Text(String(self.nomalBodyTemp))
                            }
                            Section(header:Text("性別")) {
                                Text(self.genderStr)
                            }
                            Section(header:Text("学籍番号")) {
                                Text(String(self.schoolid))
                            }
                            Section(header:Text("学生番号")) {
                                Text(String(self.studentid))
                            }
                            
                            Section(header: Text("学年")) {
                                Text(String(self.grade))
                            }
                            
                            Button(action:{
                                self.isProfileShow.toggle()
                            }) {
                                Text("隠す")
                                    .foregroundColor(.red)
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                            }
                        }
                    }
                } else {
                    Divider()
                    Image(systemName: "lock.fill")
                        .font(.title)
                        .padding()
                    Text("パスワードで保護されています")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding()
                    Button(action: {
                        self.security.biometricsAuth() { result in
                            if result {
                                self.isProfileShow = true
                            } else {
                                self.isProfileShow = false
                            }
                        }
                    }) {
                        Text("表示")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }.padding()
                }
                Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            fireauth.getData() { _, _ in
                
            }
            firestore.getUserData(uid: fireauth.uid) { result in
                self.firstname = self.firestore.userdata.firstname
                self.lastname = self.firestore.userdata.lastname
                self.nomalBodyTemp = self.firestore.userdata.nomalbodytemp
                self.genderStr = self.firestore.userdata.gender
                self.schoolid = self.firestore.userdata.schoolid
                self.studentid = self.firestore.userdata.studentid
                self.grade = self.firestore.userdata.grade
            }
        }
    }
}

struct ProfileInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileInfoView()
    }
}

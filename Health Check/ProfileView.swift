import SwiftUI
import FirebaseUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import Combine

struct ProfileInitView: View {
    
    var fireauth: FireAuth = FireAuth()
    var firestore: FireStore = FireStore()
    
    @State var firstname: String = ""
    @State var lastname: String = ""
    @State var studentidstr: String = ""
    @State var schoolidstr: String = ""
    @State var studentid: Int = 0
    @State var schoolid: Int = 0
    @State var grade: Int = 1
    @State var nomalBodyTemp: Float = 36.5
    @State var nomalBodyTempNum: Int = 0
    @State var nomalBodyTempPoint: Int = 0
    @State var nomalBodyTempPointFloat: Float = 0.0
    
    @State var gender: Int = 0
    @State var genderStr: String = "男性"
    
    @State var showPicker: Bool = false
    
    @State var isNomalBodyTempPicker: Bool = false
    
    @State var alert: Bool = false
    @State var error: String = "NO ERROR"
    @State var buttonColor: Color = Color.green
    
    var genderOptions = ["🙍‍♂️ 男性", "🙍‍♀️ 女性", "その他"]
    
    func convertGender(gender:Int) -> (String) {
        
        var genderConverted:String = ""
        
        if gender == 0 {
            genderConverted = "male"
        } else if gender == 1 {
            genderConverted = "female"
        } else {
            genderConverted = "other"
        }
        return genderConverted
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            let backGroundColor = Color(.white)
            ZStack {
                backGroundColor.edgesIgnoringSafeArea(.all)
                VStack {
                    Text("プロフィール設定")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                    
                    ScrollView {
                        VStack {
                            Spacer(minLength: 50)
                                .fixedSize()
                            
                            Group {
                                VStack {
                                    Group {
                                        HStack {
                                            Text("氏名")
                                                .fontWeight(.bold)
                                            Spacer(minLength:0)
                                        }
                                        
                                        HStack {
                                            TextField("姓", text: self.$lastname)
                                            
                                            TextField("名", text: self.$firstname)
                                            
                                        }
                                        
                                        Divider()
                                        
                                        Spacer(minLength: 20)
                                            .fixedSize()
                                    }
                                    
                                    Group {
                                        HStack {
                                            Text("学年")
                                                .fontWeight(.bold)
                                            Spacer(minLength:0)
                                        }
                                        
                                        HStack {
                                            
                                            Text("第\(self.grade)学年")
                                            
                                        }
                                        .onTapGesture {
                                            self.showPicker.toggle()
                                        }
                                        .sheet(isPresented: self.$showPicker) {
                                            ZStack(alignment: .topLeading) {
                                                VStack {
                                                    Spacer(minLength: 0)
                                                    ModalView(grade: self.$grade).padding(.vertical)
                                                    Spacer(minLength: 0)
                                                }
                                                Button(action: {self.showPicker.toggle()}) {
                                                    Text("Close")
                                                        .fontWeight(.bold)
                                                }
                                            }.padding(25)
                                        }
                                        Divider()
                                        
                                        Spacer(minLength: 20)
                                            .fixedSize()
                                    }
                                    
                                    Group {
                                        HStack {
                                            Text("学籍番号")
                                                .fontWeight(.bold)
                                            Spacer(minLength:0)
                                        }
                                        
                                        HStack {
                                            TextField("8桁の学籍番号", text: self.$schoolidstr)
                                                .keyboardType(.numberPad)
                                        }
                                        
                                        Divider()
                                        
                                        Spacer(minLength: 20)
                                            .fixedSize()
                                    }
                                    
                                    Group {
                                        HStack {
                                            Text("学生番号")
                                                .fontWeight(.bold)
                                            Spacer(minLength:0)
                                        }
                                        
                                        HStack {
                                            TextField("4桁の学籍番号", text: self.$studentidstr)
                                                .keyboardType(.numberPad)
                                        }
                                        
                                        Divider()
                                        
                                        Spacer(minLength: 20)
                                            .fixedSize()
                                    }
                                    
                                    Group {
                                        HStack {
                                            Text("平熱")
                                                .fontWeight(.bold)
                                            Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                                        }
                                        
                                        HStack {
                                            Text(String(self.nomalBodyTemp))
                                                .font(.title2)
                                                .fontWeight(.bold)
                                                .onTapGesture {
                                                    self.isNomalBodyTempPicker.toggle()
                                                }
                                                .sheet(isPresented: self.$isNomalBodyTempPicker) {
                                                    ZStack(alignment: .topLeading) {
                                                        VStack {
                                                            Spacer(minLength: 50)
                                                                .fixedSize()
                                                            
                                                            HStack {
                                                                Text("平熱")
                                                                    .font(.title2)
                                                                    .fontWeight(.bold)
                                                                Text(String(Float(self.nomalBodyTempNum + 35)+(Float(self.nomalBodyTempPoint)/10)))
                                                                    .font(.title2)
                                                                    .fontWeight(.bold)
                                                            }
                                                            
                                                            ModalTempView(nomalBodyTemp: self.$nomalBodyTemp, nomalBodyTempNum: self.$nomalBodyTempNum, nomalBodyTempPoint: self.$nomalBodyTempPoint)
                                                                .padding(.vertical)
                                                            Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                                                        }
                                                        Button(action: {
                                                            self.nomalBodyTempNum = self.nomalBodyTempNum + 35
                                                            self.nomalBodyTempPointFloat = Float(self.nomalBodyTempPoint)/10
                                                            
                                                            self.nomalBodyTemp = Float(self.nomalBodyTempNum) +  self.nomalBodyTempPointFloat
                                                            self.isNomalBodyTempPicker.toggle()
                                                        }) {
                                                            Text("Close")
                                                                .fontWeight(.bold)
                                                        }
                                                    }.padding(25)
                                                }
                                            
                                            Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                                        }
                                        
                                    }
                                }.onTapGesture {
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                }
                                Divider()
                                
                                Spacer(minLength: 20)
                                    .fixedSize()
                                Group {
                                    HStack {
                                        Text("性別")
                                            .fontWeight(.bold)
                                        Spacer(minLength: 0)
                                    }
                                    Picker("Gender", selection: $gender) {
                                        ForEach(0..<genderOptions.count) {
                                            Text(self.genderOptions[$0])
                                        }
                                    }.pickerStyle(SegmentedPickerStyle())
                                        .onChange(of: gender) { (Int) -> (Void) in
                                            var genderConverted: String = ""
                                            if gender == 0 {
                                                genderConverted = "男性"
                                            } else if gender == 1 {
                                                genderConverted = "女性"
                                            } else {
                                                genderConverted = "その他"
                                            }
                                            self.genderStr = genderConverted
                                        }
                                    
                                    Spacer(minLength: 20)
                                        .fixedSize()
                                    Divider()
                                    
                                    Spacer(minLength: 20)
                                        .fixedSize()
                                }
                                
                                Button(action:{
                                    self.studentid = (self.studentidstr as NSString).integerValue
                                    self.schoolid = (self.schoolidstr as NSString).integerValue
                                    if self.firstname != "" && self.lastname != "" && self.schoolid != 0 && self.studentid != 0 {
                                        fireauth.getData() { result, error in
                                            if result {
                                                //NO ERROR
                                            } else {
                                                self.alert.toggle()
                                                self.error = error
                                            }
                                        }
                                        firestore.initUserData(uid: fireauth.uid, mail: fireauth.email!, firstname: self.firstname, lastname: self.lastname, gender: self.genderStr, schoolid: self.schoolid, studentid: self.studentid, grade: self.grade, nomalbodytemp: self.nomalBodyTemp) { result, error in
                                            if result {
                                                // NO ERROR
                                                UserDefaults.standard.set(false, forKey: "isSignedup")
                                                NotificationCenter.default.post(name: NSNotification.Name("isSignedup"), object: nil)
                                                UserDefaults.standard.set(false, forKey: "isLoggedin")
                                                NotificationCenter.default.post(name: NSNotification.Name("isLoggedin"), object: nil)
                                                UserDefaults.standard.set(true, forKey: "isGuidanceShow")
                                                NotificationCenter.default.post(name: NSNotification.Name("isGuidanceShow"), object: nil)
                                                
                                                UserDefaults.standard.set(self.nomalBodyTemp, forKey: "nomalBodyTemp")
                                                NotificationCenter.default.post(name: NSNotification.Name("nomalBodyTemp"), object: nil)
                                            } else {
                                                self.alert.toggle()
                                                self.error = error
                                            }
                                        }
                                    } else {
                                        self.alert.toggle()
                                        self.error = "NOT FILLED"
                                    }
                                }) {
                                    Text("登録")
                                        .foregroundColor(.white)
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .padding(.vertical)
                                        .frame(width: UIScreen.main.bounds.width - 50)
                                        .background(Color.green)
                                        .cornerRadius(10)
                                        .padding(.top, 25)
                                }
                            }
                            Spacer(minLength: 0)
                            
                        }.padding(.horizontal, 25)
                            .onAppear() {
                                fireauth.getData() {_, _ in
                                    
                                }
                            }
                    }
                }
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
            }
            
            if self.alert {
                ErrorView(alert: self.$alert, error: self.$error, buttonColor: self.$buttonColor)
            }
        }
    }
}

struct ProfileEditView: View {
    
    var fireauth: FireAuth = FireAuth()
    @ObservedObject var firestore: FireStore = FireStore()
    var security: Security = Security()
    
    @State var firstname: String = ""
    @State var lastname: String = ""
    @State var studentidstr: String = ""
    @State var schoolidstr: String = ""
    @State var studentid: Int = 0
    @State var schoolid: Int = 0
    @State var grade: Int = 1
    @State var nomalBodyTemp: Float = 36.5
    @State var nomalBodyTempNum: Int = 0
    @State var nomalBodyTempPoint: Int = 0
    @State var nomalBodyTempPointFloat: Float = 0.0
    
    @State var gender: Int = 0
    @State var genderStr: String = "男性"
    
    @State var showPicker: Bool = false
    
    @State var isNomalBodyTempPicker: Bool = false
    
    @Binding var isEditOn: Bool
    
    @State var isShowProfile: Bool = false
    var genderOptions = ["🙍‍♂️ 男性", "🙍‍♀️ 女性", "その他"]
    
    func convertGender(gender:Int) -> (String) {
        
        var genderConverted:String = ""
        
        if gender == 0 {
            genderConverted = "male"
        } else if gender == 1 {
            genderConverted = "female"
        } else {
            genderConverted = "other"
        }
        return genderConverted
    }
    
    var body: some View {
            ZStack(alignment: .topLeading) {
                VStack {
                    Text("プロフィール設定")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                   
                    Divider()
                    
                    Spacer(minLength: 20)
                        .fixedSize()
                    ScrollView {
                        if self.isShowProfile {
                            VStack {
                                Group {
                                    Group {
                                        HStack {
                                            Text("氏名")
                                                .fontWeight(.bold)
                                            Spacer(minLength:0)
                                        }
                                        
                                        HStack {
                                            TextField("姓", text: self.$lastname)
                                            
                                            TextField("名", text: self.$firstname)
                                            
                                        }
                                        
                                        Divider()
                                        
                                        Spacer(minLength: 20)
                                            .fixedSize()
                                    }
                                    
                                    Group {
                                        HStack {
                                            Text("学年")
                                                .fontWeight(.bold)
                                            Spacer(minLength:0)
                                        }
                                        
                                        HStack {
                                            
                                            Text("第\(self.grade)学年")
                                            
                                        }
                                        .onTapGesture {
                                            self.showPicker.toggle()
                                        }
                                        .sheet(isPresented: self.$showPicker) {
                                            ZStack(alignment: .topLeading) {
                                                VStack {
                                                    Spacer(minLength: 0)
                                                    ModalView(grade: self.$grade).padding(.vertical)
                                                    Spacer(minLength: 0)
                                                }
                                                Button(action: {self.showPicker.toggle()}) {
                                                    Text("Close")
                                                        .fontWeight(.bold)
                                                }
                                            }.padding(25)
                                        }
                                        Divider()
                                        
                                        Spacer(minLength: 20)
                                            .fixedSize()
                                    }
                                    
                                    Group {
                                        HStack {
                                            Text("学籍番号")
                                                .fontWeight(.bold)
                                            Spacer(minLength:0)
                                        }
                                        
                                        HStack {
                                            TextField("8桁の学籍番号", text: self.$schoolidstr)
                                                .keyboardType(.numberPad)
                                        }
                                        
                                        Divider()
                                        
                                        Spacer(minLength: 20)
                                            .fixedSize()
                                    }
                                    
                                    Group {
                                        HStack {
                                            Text("学生番号")
                                                .fontWeight(.bold)
                                            Spacer(minLength:0)
                                        }
                                        
                                        HStack {
                                            TextField("4桁の学籍番号", text: self.$studentidstr)
                                                .keyboardType(.numberPad)
                                        }
                                        
                                        Divider()
                                        
                                        Spacer(minLength: 20)
                                            .fixedSize()
                                    }
                                    
                                    Group {
                                        HStack {
                                            Text("平熱")
                                                .fontWeight(.bold)
                                            Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                                        }
                                        
                                        HStack {
                                            Text(String(self.nomalBodyTemp))
                                                .font(.title2)
                                                .fontWeight(.bold)
                                                .onTapGesture {
                                                    self.isNomalBodyTempPicker.toggle()
                                                }
                                                .sheet(isPresented: self.$isNomalBodyTempPicker) {
                                                    ZStack(alignment: .topLeading) {
                                                        VStack {
                                                            Spacer(minLength: 50)
                                                                .fixedSize()
                                                            
                                                            HStack {
                                                                Text("平熱")
                                                                    .font(.title2)
                                                                    .fontWeight(.bold)
                                                                Text(String(Float(self.nomalBodyTempNum + 35)+(Float(self.nomalBodyTempPoint)/10)))
                                                                    .font(.title2)
                                                                    .fontWeight(.bold)
                                                            }
                                                            
                                                            ModalTempView(nomalBodyTemp: self.$nomalBodyTemp, nomalBodyTempNum: self.$nomalBodyTempNum, nomalBodyTempPoint: self.$nomalBodyTempPoint)
                                                                .padding(.vertical)
                                                            Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                                                        }
                                                        Button(action: {
                                                            self.nomalBodyTempNum = self.nomalBodyTempNum + 35
                                                            self.nomalBodyTempPointFloat = round((Float(self.nomalBodyTempPoint)/10)*10)/10
                                                            
                                                            self.nomalBodyTemp = round((Float(self.nomalBodyTempNum))*10)/10 + self.nomalBodyTempPointFloat
                                                            
                                                            self.nomalBodyTemp = round(self.nomalBodyTemp*10)/10
                                                            
                                                            self.isNomalBodyTempPicker.toggle()
                                                        }) {
                                                            Text("Close")
                                                                .fontWeight(.bold)
                                                        }
                                                    }.padding(25)
                                                }
                                            
                                            Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                                        }
                                        
                                        
                                        Divider()
                                        
                                        Spacer(minLength: 20)
                                            .fixedSize()
                                    }
                                    
                                }.onTapGesture {
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                }
                                
                                Group {
                                    HStack {
                                        Text("性別")
                                            .fontWeight(.bold)
                                        Spacer(minLength: 0)
                                    }
                                    Picker("Gender", selection: $gender) {
                                        ForEach(0..<genderOptions.count) {
                                            Text(self.genderOptions[$0])
                                        }
                                    }.pickerStyle(SegmentedPickerStyle())
                                        .onChange(of: gender) { (Int) -> (Void) in
                                            var genderConverted: String = ""
                                            if gender == 0 {
                                                genderConverted = "男性"
                                            } else if gender == 1 {
                                                genderConverted = "女性"
                                            } else {
                                                genderConverted = "その他"
                                            }
                                            self.genderStr = genderConverted
                                        }
                                    
                                    Spacer(minLength: 20)
                                        .fixedSize()
                                    
                                    Divider()
                                    
                                    Spacer(minLength: 20)
                                        .fixedSize()
                                }
                                
                                Button(action:{
                                    self.studentid = (self.studentidstr as NSString).integerValue
                                    self.schoolid = (self.schoolidstr as NSString).integerValue
                                    firestore.updateUserData(uid: fireauth.uid, mail: fireauth.email!, firstname: self.firstname, lastname: self.lastname, gender: self.genderStr, schoolid: self.schoolid, studentid: self.studentid, grade: self.grade,  nomalbodytemp: self.nomalBodyTemp)
                                    UserDefaults.standard.set(self.nomalBodyTemp, forKey: "nomalBodyTemp")
                                    NotificationCenter.default.post(name: NSNotification.Name("nomalBodyTemp"), object: nil)
                                    self.isEditOn.toggle()
                                }) {
                                    Text("保存")
                                        .foregroundColor(.white)
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .padding(.vertical)
                                        .frame(width: UIScreen.main.bounds.width - 50)
                                        .background(Color.green)
                                        .cornerRadius(10)
                                        .padding(.top, 25)
                                }.onTapGesture {
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                }
                            }
                        } else {
                            Group {
                                Spacer(minLength: 50)
                                    .fixedSize()
                                Text("プロフィールはロックされています")
                                    .foregroundColor(.red)
                                    .fontWeight(.bold)
                                    .padding()
                            }.frame(maxWidth: .infinity)
                        }
                        Spacer(minLength: 0)
                        
                    }.padding(.horizontal, 25)
                }
                Button(action: {self.isEditOn.toggle()}) {
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .foregroundColor(.black)
                }.padding()
            }
            .onAppear() {
                self.security.biometricsAuth() { result in
                    if result {
                        self.isShowProfile = true
                    } else {
                        self.isEditOn = false
                    }
                }
                fireauth.getData() {_, _ in
                    
                }
                firestore.getUserData(uid: fireauth.uid) { result in
                    if result {
                        self.firstname = self.firestore.userdata.firstname
                        self.lastname = self.firestore.userdata.lastname
                        self.schoolidstr = String(self.firestore.userdata.schoolid)
                        self.studentidstr = String(self.firestore.userdata.studentid)
                        self.grade = self.firestore.userdata.grade
                        
                        self.nomalBodyTemp = self.firestore.userdata.nomalbodytemp
                        self.nomalBodyTempNum = Int(floor(self.nomalBodyTemp))
                        self.nomalBodyTempPoint = Int((self.nomalBodyTemp - Float(self.nomalBodyTempNum))*10)
                        self.nomalBodyTempNum = self.nomalBodyTempNum - 35
                        
                        self.genderStr = self.firestore.userdata.gender
                        if self.genderStr == "男性" {
                            self.gender = 0
                        } else if self.genderStr == "女性" {
                            self.gender = 1
                        } else {
                            self.gender = 2
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
}

struct ModalView: View {
    @Binding var grade: Int
    var body: some View {
        VStack {
            Text("第\(self.grade)学年")
                .font(.title2)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .padding()
            Picker(selection: self.$grade, label: Text("")) {
                Text("第1学年").tag(1)
                Text("第2学年").tag(2)
                Text("第3学年").tag(3)
                Text("第4学年").tag(4)
                Text("第5学年").tag(5)
                Text("第6学年").tag(6)
            }
        }
    }
}

struct ModalTempView: View {
    @Binding var nomalBodyTemp: Float
    @Binding var nomalBodyTempNum: Int
    @Binding var nomalBodyTempPoint: Int
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing:0) {
                Picker(selection: self.$nomalBodyTempNum, label: EmptyView()) {
                    ForEach(35 ..< 41) {
                        Text("\($0)")
                    }
                }.frame(maxWidth: geometry.size.width/2)
                    .clipped()
                Picker(selection: self.$nomalBodyTempPoint, label: EmptyView()) {
                    ForEach(0 ..< 10) {
                        Text("\($0)")
                    }
                }.frame(maxWidth: geometry.size.width/2)
                    .clipped()
            }
        }.onAppear() {
            self.nomalBodyTempNum = Int(floor(self.nomalBodyTemp))
            self.nomalBodyTempPoint = Int((self.nomalBodyTemp - Float(self.nomalBodyTempNum))*10)
            self.nomalBodyTempNum = self.nomalBodyTempNum - 35
        }
    }
}


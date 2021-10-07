//
//  Firebase.swift
//  Health Check
//
//  Created by Nomura Rentaro on 2021/09/28.
//
import SwiftUI
import FirebaseUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import Combine

class FireAuth {
    var uid:String = ""
    var email:String? = ""
    var name:String? = ""
    
    func login(mail: String, password: String, res: @escaping(Bool)->()) {
        Auth.auth().signIn(withEmail: mail, password: password) { authResult, error in
            if authResult?.user != nil {
                res(true)
                UserDefaults.standard.set(true, forKey: "isLoggedin")
                NotificationCenter.default.post(name: NSNotification.Name("isLoggedin"), object: nil)
            } else {
                res(false)
            }
        }
    }
    
    func signup(mail: String, password: String, res: @escaping(Bool)->()) {
        Auth.auth().createUser(withEmail: mail, password: password) { authResult, error in
            if let user = authResult?.user {
                dump(user)
                res(true)
                UserDefaults.standard.set(true, forKey: "isSignedup")
                NotificationCenter.default.post(name: NSNotification.Name("isSignedup"), object: nil)
            } else {
                dump(error)
                res(false)
            }
        }
    }
    
    func getData() {
        let user = Auth.auth().currentUser
        if let user = user {
            uid = user.uid
            email = user.email
            name = user.displayName
        }
    }
    //check email
    func checkEmail(mail: String) -> Bool {
        var mailState: Bool = false
        Auth.auth().fetchSignInMethods(forEmail:mail, completion: { (forEmail, error) in
            if let error = error {
                print("Email Error: \(error.localizedDescription)")
                print(error._code)
                mailState = false
                
            } else {
                print("Email is good")
                mailState = true
            }
        })
        return mailState
    }
}

class FireStore: ObservableObject {
    
    var db = Firestore.firestore()
    
    @Published var userdata = UserData(firstname: "", lastname: "", gender: "", mail: "", uid: "", schoolid: 0, studentid: 0, nomalbodytemp: 36.5)
    
    @Published var tempdata = TempData(bodytemp: 0.0, symptom: false, posttime: Timestamp())
    
    init() {
    }
    
    func updateUserData(uid:String, mail:String, firstname: String, lastname: String, gender:String, schoolid: Int, studentid: Int, nomalbodytemp: Float) {
        db.collection("users").document(uid).setData(["uid":uid, "mail":mail, "firstname":firstname, "lastname":lastname, "gender":gender, "schoolid": schoolid, "studentid": studentid, "nomalbodytemp": nomalbodytemp]) { error in
            if let error = error {
                print(error)
                return
            }
        }
    }
    
    func postForm(uid: String, bodytemp: Float, symptom: Bool, posttime: Date) {
        db.collection("data").document(uid).setData(["bodytemp": bodytemp, "symptom": symptom, "posttime": posttime]) { error in
            if let error = error {
                print(error)
                return
            }
        }
    }
    
    func getForm(uid: String) {
        db.collection("data").document(uid).getDocument { snapshot, error in
            guard let data = snapshot?.data() else { return }
            
            self.tempdata.bodytemp = data["bodytemp"] as! Float
            self.tempdata.symptom = data["symptom"] as! Bool
            self.tempdata.posttime = data["posttime"] as! Timestamp
        }
    }
    
    
    func getUserData(uid:String, completion: @escaping(Bool)->()) {
        let group = DispatchGroup()
        
        group.enter()
        db.collection("users").document(uid).getDocument { snapshot, error in
            guard let data = snapshot?.data() else { return }
   
            self.userdata.firstname = data["firstname"] as! String
            self.userdata.lastname = data["lastname"] as! String
            self.userdata.gender = data["gender"] as! String
            self.userdata.mail = data["mail"] as! String
            self.userdata.schoolid = data["schoolid"] as! Int
            self.userdata.studentid = data["studentid"] as! Int
            self.userdata.nomalbodytemp = data["nomalbodytemp"] as! Float
            group.leave()
        }
        group.notify(queue: DispatchQueue.global(qos: .background)) {
            completion(true)
        }
    }
    
    func initUserData(uid:String, mail:String, firstname: String, lastname: String, gender:String, schoolid: Int, studentid: Int, nomalbodytemp: Float) {
        db.collection("users").document(uid).setData(["uid":uid, "mail":mail, "firstname":firstname, "lastname":lastname, "gender":gender, "schoolid":schoolid, "studentid":studentid, "nomalbodytemp": nomalbodytemp]) { error in
            if let error = error {
                print(error)
                return
            }
        }
    }
}



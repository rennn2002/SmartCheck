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
import Foundation

class FireAuth {
    var uid:String = ""
    var email:String? = ""
    var name:String? = ""
    
    func login(mail: String, password: String, res: @escaping(Bool, String)->()) {
        Auth.auth().signIn(withEmail: mail, password: password) { authResult, error_msg in
            if authResult?.user != nil {
                res(true, "NO ERROR")
                UserDefaults.standard.set(true, forKey: "isLoggedin")
                NotificationCenter.default.post(name: NSNotification.Name("isLoggedin"), object: nil)
            } else {
                res(false, error_msg!.localizedDescription)
            }
        }
    }
    
    func signup(mail: String, password: String, res: @escaping(Bool, String)->()) {
        Auth.auth().createUser(withEmail: mail, password: password) { authResult, error_msg in
            if (authResult?.user) != nil {
                res(true, "NO ERROR")
                UserDefaults.standard.set(true, forKey: "isSignedup")
                NotificationCenter.default.post(name: NSNotification.Name("isSignedup"), object: nil)
            } else {
                res(false, error_msg!.localizedDescription)
            }
        }
    }
    
    func getData(res: @escaping(Bool, String)->()) {
        let user = Auth.auth().currentUser
        if let user = user {
            uid = user.uid
            email = user.email
            name = user.displayName
            res(true, "NO ERROR")
        } else {
            res(false, "予期せぬエラーが発生しました")
        }
    }
    //check email
    func checkEmail(mail: String) -> Bool {
        var mailState: Bool = false
        Auth.auth().fetchSignInMethods(forEmail:mail, completion: { (forEmail, error) in
            if let error = error {
//                print("Email Error: \(error.localizedDescription)")
                print(error._code)
                mailState = false
                
            } else {
//                print("Email is good")
                mailState = true
            }
        })
        return mailState
    }
}

class FireStore: ObservableObject {
    
    var db = Firestore.firestore()
    
    @Published var userdata = UserData(firstname: "", lastname: "", gender: "", mail: "", uid: "", schoolid: 0, studentid: 0, grade: 1, normalbodytemp: 36.5)
    
    @Published var tempdata = TempData(firstname:"", lastname:"", schoolid: 0, studentid: 0, bodytemp: 0.0, symptom: false, posttime: Timestamp(), mail:"")
    
    init() {
    }
    
    func updateUserData(uid:String, mail:String, firstname: String, lastname: String, gender:String, schoolid: Int, studentid: Int, grade: Int, normalbodytemp: Float) {
        db.collection("users").document(uid).setData(["uid":uid, "mail":mail, "firstname":firstname, "lastname":lastname, "gender":gender, "schoolid": schoolid, "studentid": studentid, "grade": grade, "normalbodytemp": normalbodytemp]) { error in
            if let error = error {
                print(error)
                return
            }
        }
    }
    
    func postForm(uid: String, firstname: String, lastname: String, schoolid: Int, studentid: Int, bodytemp: Float, symptom: Bool, posttime: Date, mail: String, completion: @escaping(Bool, String)->()) {
        let group = DispatchGroup()
        group.enter()
        db.collection("data").document(uid).setData(["firstname": firstname, "lastname": lastname, "schoolid": schoolid, "studentid": studentid, "bodytemp": bodytemp, "symptom": symptom, "posttime": posttime, "mail": mail]) { error in
            if let error = error {
//                print(error)
                completion(false, error.localizedDescription)
                return
            }
            group.leave()
            
            group.notify(queue: DispatchQueue.global(qos: .background)) {
                completion(true, "NO ERROR")
            }
        }
    }
        
        func getForm(uid: String, completion: @escaping(Bool)->()) {
            let group = DispatchGroup()
            
            group.enter()
            completion(false)
            db.collection("data").document(uid).getDocument { snapshot, error in
                guard let data = snapshot?.data() else { return }
                self.tempdata.bodytemp = data["bodytemp"] as! Double
                self.tempdata.symptom = data["symptom"] as! Bool
                self.tempdata.posttime = data["posttime"] as! Timestamp
                group.leave()
            }
            group.notify(queue: DispatchQueue.global(qos: .background)) {
                completion(true)
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
                self.userdata.grade = data["grade"] as! Int
                self.userdata.normalbodytemp = data["normalbodytemp"] as! Float
                group.leave()
            }
            group.notify(queue: DispatchQueue.global(qos: .background)) {
                completion(true)
            }
        }

    func initUserData(uid:String, mail:String, firstname: String, lastname: String, gender:String, schoolid: Int, studentid: Int, grade: Int, normalbodytemp: Float, res: @escaping(Bool, String)->()) {
            db.collection("users").document(uid).setData(["uid":uid, "mail":mail, "firstname":firstname, "lastname":lastname, "gender":gender, "schoolid":schoolid, "studentid":studentid, "grade": grade, "normalbodytemp": normalbodytemp]) { error in
                if let error = error {
                    //ERROR OCCURED
                    res(false, error.localizedDescription)
                    //RESET STATE
                    let appDomain = Bundle.main.bundleIdentifier
                    UserDefaults.standard.removePersistentDomain(forName: appDomain!)
                    return
                } else {
                    // NO ERROR
                    res(true, "NO ERROR")
                }
            }
        }
    }



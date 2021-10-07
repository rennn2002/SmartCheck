//
//  Userdata.swift
//  Health Check
//
//  Created by Nomura Rentaro on 2021/09/28.
//\

import Foundation
import Firebase

struct UserData: Hashable {
    var firstname: String
    var lastname: String
    var gender: String
    var mail: String
    var uid: String
    var schoolid: Int
    var studentid:Int
    var nomalbodytemp: Float
}

struct TempData {
    var bodytemp: Float
    var symptom: Bool
    var posttime: Timestamp
}


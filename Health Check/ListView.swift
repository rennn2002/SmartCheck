//
//  ListView.swift
//  Health Check
//
//  Created by Nomura Rentaro on 2021/10/05.
//

import SwiftUI

struct ListView: View {
    
    @State var bodyTemp: Float = 0.0
    @State var symptom: Bool = false
    @State var postTime: String = "not provided"
    
    var fireauth: FireAuth = FireAuth()
    @ObservedObject var firestore: FireStore = FireStore()
    
    var body: some View {
        VStack {
            
            Image("check")
                .resizable()
                .frame(width: 100, height:100)
            
            Text("送信されました")
                .foregroundColor(.green)
                .fontWeight(.bold)
            
            Spacer(minLength: 30)
                .fixedSize()
            HStack {
            Text("体温：")
                .fontWeight(.bold)
            Text(String(firestore.tempdata.bodytemp))
                .fontWeight(.bold)
            }.padding(2.5)
            HStack {
            Text("自覚症状：")
                .fontWeight(.bold)
                Text(self.symptom ? "あり":"なし")
                .fontWeight(.bold)
            }.padding(2.5)
            HStack {
                Text("提出時間：")
                    .fontWeight(.bold)
                Text(self.postTime)
                    .fontWeight(.bold)
            }.padding(2.5)
        }.onAppear {
//            fireauth.getData()
//            firestore.getForm(uid: fireauth.uid)
//
//            self.bodyTemp = firestore.tempdata.bodytemp
//            self.symptom = firestore.tempdata.symptom
//
//            //convert timestamp to date
//            let date: Date = firestore.tempdata.posttime.dateValue()
//
//            let dateFormatter = DateFormatter()
//            dateFormatter.locale = Locale(identifier: "ja_JP")
//            dateFormatter.dateStyle = .medium
//            dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
//
//            self.postTime = dateFormatter.string(from: date)
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
       ListView()
    }
}

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
    
    var fireauth: FireAuth = FireAuth()
    @ObservedObject var firestore: FireStore = FireStore()
    
    var body: some View {
        VStack {
            Image("check")
                .resizable()
                .frame(width:150, height:150)
            
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
                UserDefaults.standard.set(false, forKey: "isFormPosted")
                NotificationCenter.default.post(name: NSNotification.Name("isFormPosted"), object: nil)
            }) {
                Text("再提出")
                    .foregroundColor(.white)
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 50)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.top, 5)
            }.padding(25)
        }.onAppear {
            fireauth.getData()
            firestore.getForm(uid: fireauth.uid)
            
            self.bodyTemp = firestore.tempdata.bodytemp
            self.symptom = firestore.tempdata.symptom
            
            //convert timestamp to date
            let date: Date = firestore.tempdata.posttime.dateValue()
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateStyle = .medium
            dateFormatter.dateFormat = "yyyy/MM/d HH:mm"
            
            self.postTime = dateFormatter.string(from: date)
        }
    }
}

struct CheckFormView_Previews: PreviewProvider {
    static var previews: some View {
        CheckFormView()
    }
}

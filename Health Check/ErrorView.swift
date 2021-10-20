//
//  ErrorView.swift
//  Health Check
//
//  Created by Nomura Rentaro on 2021/10/15.
//

import Foundation
import SwiftUI

struct ErrorView : View {
    
    @State var color = Color.black.opacity(0.7)
    @Binding var alert : Bool
    @Binding var error : String
    @Binding var buttonColor: Color
    
    var body: some View{
        ZStack {
            GeometryReader {_ in
                
            }
            .background(Color.black.opacity(0.35)).edgesIgnoringSafeArea(.all)
            VStack(alignment:.center){
                HStack{
                    
                    Text("エラー")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(self.color)
                    
                    Spacer()
                }
                .padding(.horizontal, 25)
                
                if self.error == "NOT FILLED" {
                    Text("全ての項目に入力してください")
                        .foregroundColor(self.color)
                        .padding(.top)
                        .padding(.horizontal, 25)
                } else if self.error == "NOT MATCH" {
                    Text("パスワードが一致しません")
                        .foregroundColor(self.color)
                        .padding(.top)
                        .padding(.horizontal, 25)
                } else {
                    Text(self.error)
                        .foregroundColor(self.color)
                        .padding(.top)
                        .padding(.horizontal, 25)
                }
                
                Button(action: {
                    
                    self.alert.toggle()
                    
                }) {
                    Text("OK")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 120)
                }
                .background(self.buttonColor)
                .cornerRadius(10)
                .padding(.top, 25)
                
            }
            .padding(.vertical, 25)
            .frame(width: UIScreen.main.bounds.width - 70)
            .background(Color.white)
            .cornerRadius(15)
        }
    }
}


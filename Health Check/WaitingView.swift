//
//  WaitingView.swift
//  Health Check
//
//  Created by Nomura Rentaro on 2021/10/11.
//
import SwiftUI

struct WaitingView: View {
    let backGroundColor = Color(red: 96/255, green: 123/255, blue: 184/255)
    var body: some View {
        ZStack {
            backGroundColor.edgesIgnoringSafeArea(.all)
            VStack {
                Text("読み込み中...")
                    .foregroundColor(.white)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            }
        }
    }
}

struct WaitingView_Previews: PreviewProvider {
    static var previews: some View {
        WaitingView()
    }
}

struct LoadingView: View {
    @Binding var isLoading: Bool
    var body: some View {
        ZStack {
     
            Circle()
                .stroke(Color(.systemGray5), lineWidth: 14)
                .frame(width: 100, height: 100)
            
            Circle()
                .trim(from: 0, to: 0.2)
                .stroke(Color.green, lineWidth: 7)
                .frame(width: 100, height: 100)
                .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
        }
    }
}

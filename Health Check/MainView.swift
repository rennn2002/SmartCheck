//
//  MainView.swift
//  Health Check
//
//  Created by Nomura Rentaro on 2021/10/06.
//

import SwiftUI

struct MainView: View {
    @State var isFormPosted:Bool = UserDefaults.standard.value(forKey: "isFormPosted") as? Bool ?? false
    
    var body: some View {
        NavigationView {
            VStack {
                if self.isFormPosted {
                    CheckFormView()
                } else {
                    FormView()
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            NotificationCenter.default.addObserver(forName: NSNotification.Name("isFormPosted"), object: nil, queue: .main) { (_) in
                self.isFormPosted = UserDefaults.standard.value(forKey: "isFormPosted") as? Bool ?? false
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

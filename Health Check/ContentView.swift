//
//  ContentView.swift
//  Health Check
//
//  Created by Nomura Rentaro on 2021/09/28.
//

import SwiftUI

struct ContentView: View {
    @State var bodyTemp: Int = 0
    @State var bodyTempPoint: Int = 0
    
    @State var isPickerShow: Bool = false
    @State var symptom: Bool = false
    @State var term: Bool = false
    @State var isTermShow: Bool = false
    
    @State var isFormAvailable: Bool = true
    
    var body: some View {
        if self.isFormAvailable {
            FormView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

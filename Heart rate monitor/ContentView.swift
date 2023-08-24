//
//  ContentView.swift
//  Heart rate monitor
//
//  Created by OW on 2023/08/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var healthManager = HealthManager()
    
    var body: some View {
        VStack {
            HStack{
                Text("\(healthManager.value)")
                    .fontWeight(.regular)
                    .font(.system(size: 70))
                
                Text("BPM")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.red)
                    .padding(.bottom, 28.0)
                
                Spacer()
                
            }.padding()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

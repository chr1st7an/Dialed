//
//  ProfileView.swift
//  Dialed
//
//  Created by Christian Rodriguez on 12/2/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var navigation : Navigation

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct CurrentGrinderView: View{
    var grinder: Grinder
    
    var body: some View{
        VStack{
            VStack{
                    Image(grinder.type.rawValue)
                        .resizable()
                        .frame(width: 70, height: 70)
                Text(grinder.name).customFont(type: .regular, size: .subheader).multilineTextAlignment(.center)
            }
            .padding()
            .frame(minWidth: 100)
            .background(.primaryForeground)
    //        .overlay(content: {
    //            RoundedRectangle(cornerRadius: 5).stroke(.primaryText, lineWidth: 3)
    //        })
            .clipShape(RoundedRectangle(cornerRadius: 25))
        }

        
    }
}
#Preview {
    ContentView()
}

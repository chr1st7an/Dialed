//
//  BeanView.swift
//  Dialed
//
//  Created by Christian Rodriguez on 12/2/24.
//

import SwiftUI
import SwiftData

struct BeanView: View {
    @EnvironmentObject var navigation : Navigation
    var bean : CoffeeBean
    @Binding var showDetails: Bool
    @State private var animateGradient = true

    var body: some View {
        ZStack {
//            LinearGradient(colors: animateGradient ? [.primaryBackground, .primaryForeground] : [.primaryForeground, .primaryBackground], startPoint: .top, endPoint: animateGradient ? .bottom : . bottomTrailing).edgesIgnoringSafeArea(.all)
//                .onAppear {
//                                withAnimation(.easeInOut(duration: 10).repeatForever(autoreverses: true)) {
//                                    animateGradient.toggle()
//                                }
            Text("advanced details and shot history")
                }.ignoresSafeArea()
        .navigationBarBackButtonHidden(true)

    }
}



#Preview {
    ContentView()
}


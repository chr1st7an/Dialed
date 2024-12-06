//
//  ContentView.swift
//  Dialed
//
//  Created by Christian Rodriguez on 11/20/24.
//

import SwiftUI
import NavigationTransitions

struct ContentView: View {
    @StateObject var navigation = Navigation()

    @State private var animateGradient = true
    @State private var launch = true

    @State private var selectedBeans: Beans?
    
    @State private var isDialingIn: Bool = false
    @State private var hideDialing: (Bool, Bool) = (false, false)

    
    var body: some View {
        NavigationStack(path: $navigation.stack){
            ZStack{
                Launch()
                HomeView(selectedBeans: $selectedBeans, isDialingIn: $isDialingIn)
                    .environmentObject(navigation)
                    .opacity(launch ? 1 : 0)
                    .animation(.interactiveSpring(duration: 6), value: launch)
                ProgressView()
                    .opacity(launch ? 0 : 1)
                    .animation(.interactiveSpring(duration: 1), value: launch)
                    
            }
            .safeAreaPadding(.top, 90)
            
            .navigationDestination(for: Destination.self) { destination in
                switch destination{
                case .profile:
                    ProfileView()
                case .beans:
                    BeansView()
                case .dialing:
                    BeansView()
                    
                }
            }
            .navigationDestination(isPresented: $isDialingIn) {
                DialingView(selectedBeans: $selectedBeans, isDialing: $isDialingIn, hideView: $hideDialing)
            }
            
        }.overlayPreferenceValue(MAnchorKey.self, { value in
            LayerView(selectedBeans: selectedBeans, hideView: hideDialing, value: value, pushView: isDialingIn)
        })
        .navigationTransition(
            .fade(.in).animation(.easeInOut(duration: 0.75))
        )
    }
    
    @ViewBuilder
    func Launch() -> some View {
        LinearGradient(colors: animateGradient ? [.primaryBackground, .primaryForeground] : [.primaryForeground, .primaryBackground], startPoint: .top, endPoint: animateGradient ? .bottom : . bottomTrailing).edgesIgnoringSafeArea(.all)
            .onAppear {
                            withAnimation(.easeInOut(duration: 10).repeatForever(autoreverses: true)) {
                                animateGradient.toggle()
                            }
                        }
        
//        Color.primaryBackground.edgesIgnoringSafeArea(.all)
        Text(timeOfDayGreeting()).customFont(type: .regular, size: .header)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: launch ? .topLeading : .center)
                    .animation(.interactiveSpring(duration: 2), value: launch)
                    .padding(.leading, launch ? 15 : 0)
                    .offset(y: launch ? 0 : -50)
                    .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation(.easeOut){
                            launch = true
                        }
                    }
                }
    }
}

#Preview {
        ContentView()
}

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
    @State private var launch = false

    @State private var selectedBeans: Beans?
    
    @State private var isDialingIn: Bool = false
    @State private var hideDialing: (Bool, Bool) = (false, false)

    init() {
        // Customize the appearance of the navigation bar
        let appearance = UINavigationBarAppearance()
        let appearance1 = UINavigationBarAppearance()
        appearance1.configureWithTransparentBackground()
        appearance1.backgroundColor = UIColor(Color.primaryBackground.opacity(0.5))
        appearance1.shadowColor = UIColor(Color.primaryBackground.opacity(0.5))
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear  // Optional: removes the shadow line
        UIBarButtonItem.appearance().tintColor = UIColor(Color.secondaryForeground)
        UINavigationBar.appearance().standardAppearance = appearance1
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        NavigationStack(path: $navigation.stack){
            ZStack{
                Launch()
                HomeView(selectedBeans: $selectedBeans, isDialingIn: $isDialingIn)
                    .environmentObject(navigation)
                    .opacity(launch ? 1 : 0)
                    .animation(.interactiveSpring(
                        duration: 6), value: launch)
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
                case .newBeans:
                    AddBeansView()
                        .environmentObject(navigation)

                    
                }
            }
            .navigationDestination(isPresented: $isDialingIn) {
                DialingView(selectedBeans: $selectedBeans, isDialing: $isDialingIn, hideView: $hideDialing)
            }
            
        }.overlayPreferenceValue(MAnchorKey.self, { value in
            LayerView(selectedBeans: selectedBeans, hideView: hideDialing, value: value, pushView: isDialingIn)
        })
        .navigationTransition(
            .fade(.in).animation(.easeInOut(duration: 0.5))
        )
    }
    
    @ViewBuilder
    func Launch() -> some View {
        LinearGradient(colors: animateGradient ? [.primaryBackground, .primaryForeground] : [.primaryForeground, .primaryBackground], startPoint: .top, endPoint: animateGradient ? .bottom : . bottomTrailing).edgesIgnoringSafeArea(.all)
            .onAppear {
                            withAnimation(.easeInOut(duration: 10).repeatForever(autoreverses: true)) {
                                animateGradient.toggle()
                            }
            }.ignoresSafeArea()
        
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

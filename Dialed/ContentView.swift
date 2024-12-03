//
//  ContentView.swift
//  Dialed
//
//  Created by Christian Rodriguez on 11/20/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var navigation = Navigation()

    @State private var animateGradient: Bool = false
    @State private var launch = true

    
    var body: some View {
        NavigationStack(path: $navigation.stack){
            ZStack{
                Launch()
                    VStack{
                        Header()
                        Beans().padding(.vertical)
                        DialIn().padding(.vertical, 80)
                        Spacer()
                    }
                    .opacity(launch ? 1 : 0)
                    .animation(.interactiveSpring(duration: 6), value: launch)
                    ProgressView()
                    .opacity(launch ? 0 : 1)
                    .animation(.interactiveSpring(duration: 1), value: launch)
            }
        }
        .navigationDestination(for: Destination.self) { destination in
            switch destination{
            case .profile:
                ProfileView()
            case .beans:
                BeansView()
            case .dialing:
                DialingView()
            }
        }
    }
    
    @ViewBuilder
    func Header() -> some View {
        HStack{
            Text(timeOfDayGreeting()).customFont(type: .regular, size: .header).opacity(0)
            Spacer()
            Button {
                
            } label: {
                Image(systemName: "person.circle.fill").resizable().frame(width: UIScreen.main.bounds.height * 0.04, height: UIScreen.main.bounds.height * 0.04).foregroundStyle(.secondaryForeground)
            }.padding([.trailing])

        }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .padding(.bottom)
    }
    
    @ViewBuilder
    func Beans() -> some View {
        VStack(alignment:.leading, spacing:5){
            HStack{
                Text("Beans").customFont(type: .bold, size: .subheader).foregroundStyle(.primaryText)
                Image(systemName: "chevron.right").foregroundStyle(.secondaryForeground)
            }
            .padding(.horizontal)

            HStack{
                Image("beans").resizable().frame(width: UIScreen.main.bounds.height * 0.04, height:UIScreen.main.bounds.height * 0.04)
                Spacer()
                VStack(alignment:.leading){
                    VStack(alignment:.leading){
                        Text("Speed Dial").customFont(type: .regular, size: .body)
                        Text("Brooklyn Coffee Lab").customFont(type: .regular, size: .caption)
                    }
                    HStack(spacing: 0){
                        Text("Dark").customFont(type: .bold, size: .caption).foregroundStyle(.secondaryText)
                        Text("-").customFont(type: .light, size: .caption).foregroundStyle(.primaryText).padding(.horizontal, 5)
                        Text("roasted 12 days ago").customFont(type: .regular, size: .caption).foregroundStyle(.inverseText)

                        Spacer()
                    }
                    
                }
                .padding([.trailing])
                .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.15, alignment: .center)
                Spacer()
//                Image(systemName: "chevron.right")
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.1, alignment: .center)
            .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(.primaryForeground))                    .padding(.horizontal)
            
            HStack{
                Button {
                    //
                } label: {
                    Image(systemName: "book.pages.fill").foregroundStyle(.inverseText.gradient).frame( maxHeight: UIScreen.main.bounds.height * 0.04, alignment: .center).padding(.horizontal).background(RoundedRectangle(cornerRadius: 10).foregroundStyle(.gray))
                }
                Button {
                    //
                } label: {
                    Image(systemName: "plus").foregroundStyle(.inverseText.gradient).frame(maxHeight: UIScreen.main.bounds.height * 0.04, alignment: .center).padding(.horizontal).background(RoundedRectangle(cornerRadius: 10).foregroundStyle(.secondaryForeground))
                }

            }.padding(.horizontal)
        }

    }
    
    @ViewBuilder
    func DialIn() -> some View {
        ZStack{
            CircularTextView(title: "Dial In. Dial In. Dial In. Dial In. Dial In.".uppercased(), radius: 100)
            Button{
                
            }label: {                
                Image("bean").resizable().frame(width: 50, height: 50)
                   .padding(50).frame(width: 155, height: 155)
                   .background(.primaryForeground).clipShape(Circle())


                
            }
        }

    }
    
    @ViewBuilder
    func Launch() -> some View {
//        LinearGradient(colors: animateGradient ? [.primaryBackground, .primaryForeground] : [.primaryBackground, .secondaryForeground], startPoint: .top, endPoint: animateGradient ? .bottom : . bottomTrailing)
        Color.primaryBackground.edgesIgnoringSafeArea(.all)
            .onAppear {
                withAnimation(.easeInOut(duration: 10).repeatForever(autoreverses: true)) {
                    animateGradient.toggle()
                }
            }
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

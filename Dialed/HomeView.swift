//
//  HomeView.swift
//  Dialed
//
//  Created by Christian Rodriguez on 12/3/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var navigation : Navigation

    @Binding var selectedBeans : Beans?
    @Binding var isDialingIn: Bool
    @Binding var showBean: Bool
    @State var animateDial: Bool = false

    @State var mostRecentBean: Beans = testBeans
    
    var body: some View {
        ZStack{
            if animateDial {
                Color.secondaryForeground.edgesIgnoringSafeArea(.all)
            }
            VStack(alignment:.center){
                Spacer()
                ZStack{
                    CircularTextView(title: "".uppercased(), radius: 100).opacity(0)
                    Image("bean").resizable().frame(width: 50, height: 50)
                        .padding(animateDial ? UIScreen.main.bounds.height : 50).opacity(0)
                       .background(.secondaryForeground).clipShape(Circle())
                }.safeAreaPadding(.bottom, 100)
            }
            VStack{
                Header()
                Beans().padding(.vertical)
                Spacer()
                DialIn().safeAreaPadding(.bottom, 100)
            }.overlayPreferenceValue(MAnchorKey.self, { value in
                GeometryReader(content: { geometry in
                        /// Fetching Each Profile Image View using the Profile ID
                        /// Hiding the Currently Tapped View
                    if let anchor = value[mostRecentBean.id], selectedBeans?.id != mostRecentBean.id {
                            let rect = geometry[anchor]
                        ImageView(bean: mostRecentBean, size: rect.size)
                                .offset(x: rect.minX, y: rect.minY)
                                .allowsHitTesting(false)
                        }
                    
                })
            })
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }

    }
    
    @ViewBuilder
    func Header() -> some View {
        HStack{
            Text(timeOfDayGreeting()).customFont(type: .regular, size: .header).opacity(0)
            Spacer()
            Button {
                navigation.stack.append(.profile)
            } label: {
                Image(systemName: "person.circle.fill").resizable().frame(width: UIScreen.main.bounds.height * 0.04, height: UIScreen.main.bounds.height * 0.04).foregroundStyle(.secondaryForeground)
            }.padding([.trailing])

        }
            .frame(maxWidth: .infinity, alignment: .topLeading)
//            .padding(.bottom)
    }
    
    @ViewBuilder
    func Beans() -> some View {
        Button{
            selectedBeans = mostRecentBean
            showBean = true
        }label:{
            VStack(alignment:.leading, spacing:5){
                HStack{
                    Text("Beans").customFont(type: .bold, size: .subheader).foregroundStyle(.primaryText)
                    Image(systemName: "chevron.right").foregroundStyle(.secondaryForeground)
                }
                .padding(.horizontal)

                HStack(spacing: 15) {
                    Color.clear
                        .frame(width: UIScreen.main.bounds.height * 0.04, height:UIScreen.main.bounds.height * 0.04)
                        /// Source View Anchor
                        .anchorPreference(key: MAnchorKey.self, value: .bounds, transform: { anchor in
                            return [mostRecentBean.id: anchor]
                        })
                    
                    VStack(alignment: .leading, spacing: 2, content: {
                        VStack(alignment:.leading){
                            Text(mostRecentBean.name).customFont(type: .regular, size: .body).foregroundStyle(.primaryText)
                            Text(mostRecentBean.roaster).customFont(type: .regular, size: .caption).foregroundStyle(.primaryText)
                        }
                        HStack(spacing: 0){
                            Text("Dark").customFont(type: .bold, size: .caption).foregroundStyle(.secondaryText)
                            Text("-").customFont(type: .light, size: .caption).foregroundStyle(.primaryText).padding(.horizontal, 5)
                            Text("roasted 12 days ago").customFont(type: .regular, size: .caption).foregroundStyle(.primaryText)

                            Spacer()
                        }
                    })
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("x")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                .contentShape(.rect)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(.primaryForeground)).padding(.horizontal)

                
                
                HStack(spacing:5){
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

    }
    
    @ViewBuilder
    func DialIn() -> some View {
        ZStack{
            CircularTextView(title: "Dial In. Dial In. Dial In. Dial In. Dial In.".uppercased(), radius: 100).opacity(animateDial ? 0 : 1)
            Button{
                withAnimation(.bouncy(duration: 1.5, extraBounce: 0)) {
                                    animateDial.toggle()
                            }
            }label: {
                Image("bean").resizable().frame(width: 50, height: 50)
                    .padding(50).opacity(animateDial ? 0 : 1)
                   .background(.secondaryForeground).clipShape(Circle())
            }
            
        }.onChange(of: animateDial) { newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    selectedBeans = testBeans
                    isDialingIn.toggle()
                }
            }
        }

        .onChange(of: isDialingIn) { newValue in
            if !newValue {
                animateDial = newValue
            }
        }
        

    }
}

#Preview {
    ContentView()
}

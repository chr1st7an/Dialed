//
//  HomeView.swift
//  Dialed
//
//  Created by Christian Rodriguez on 12/3/24.
//

import SwiftUI
import AVFoundation
import SwiftData

struct HomeView: View {
    @EnvironmentObject var navigation : Navigation
    @Environment(\.modelContext) private var context
    @Query(sort: \CoffeeBean.lastUpdated, order: .reverse) private var allBeans: [CoffeeBean]

    @Binding var selectedBeans : CoffeeBean?
    @Binding var isDialingIn: Bool
    @State var animateDial: Bool = false
    @State var showBeanDetail: Bool = false
    @State var newBeans = false
    @State var mostRecentBean: CoffeeBean = .init(bean: .init(name: "empty", roaster: "", roast: .dark, roastedOn: Date(), preground: true, advanced: advancedBeans, shotHistory: [], lastUpdated: Date()))

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
                Beans()
                    .padding(.vertical)
                    .onAppear {
                        // Update the most recent bean when the view appears
                        if let mostRecent = allBeans.first {
                            mostRecentBean = mostRecent
                        }
                    }
                Spacer()
                DialIn().safeAreaPadding(.bottom, 100)
            }.overlayPreferenceValue(MAnchorKey.self, { value in
                GeometryReader(content: { geometry in
                        /// Fetching Each Profile Image View using the Profile ID
                        /// Hiding the Currently Tapped View
                    if let anchor = value[mostRecentBean.id.uuidString], selectedBeans?.id.uuidString != mostRecentBean.id.uuidString {
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
                Image(systemName: "gearshape.fill").resizable().frame(width: UIScreen.main.bounds.height * 0.03, height: UIScreen.main.bounds.height * 0.03).foregroundStyle(.secondaryForeground)
            }.padding([.trailing])

        }
            .frame(maxWidth: .infinity, alignment: .topLeading)
//            .padding(.bottom)
    }
    
    @ViewBuilder
    func Beans() -> some View {
        VStack(alignment:.leading, spacing:5){
            
            NavigationLink(value: Destination.beans){
                
                HStack{
                    Text("Beans").customFont(type: .bold, size: .subheader).foregroundStyle(.primaryText)
                    Image(systemName: "chevron.right").foregroundStyle(.secondaryForeground)
                }
                .padding(.horizontal)
            }
            Button{
                showBeanDetail.toggle()
            }label:{
                    HStack(spacing: 15) {
                        Color.clear
                            .frame(width: UIScreen.main.bounds.height * 0.04, height:UIScreen.main.bounds.height * 0.04)
                        /// Source View Anchor
                            .anchorPreference(key: MAnchorKey.self, value: .bounds, transform: { anchor in
                                return [mostRecentBean.id.uuidString: anchor]
                            })
                        
                        VStack(alignment: .leading, spacing: 2, content: {
                            VStack(alignment:.leading){
                                Text(mostRecentBean.name).customFont(type: .regular, size: .body).foregroundStyle(.primaryText)
                                Text(mostRecentBean.roaster).customFont(type: .regular, size: .caption).foregroundStyle(.primaryText)
                            }
                            HStack(spacing: 0){
                                Text("Dark").customFont(type: .bold, size: .caption).foregroundStyle(.secondaryForeground)
                                Text("-").customFont(type: .light, size: .caption).foregroundStyle(.primaryText).padding(.horizontal, 5)
                                Text("roasted \(daysAgo(from: mostRecentBean.roastedOn))").customFont(type: .regular, size: .caption).foregroundStyle(.primaryText)
                                
                                Spacer()
                            }
                        })
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .contentShape(.rect)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 5).foregroundStyle(.inverseText.opacity(0.5))).padding(.horizontal)
                }
            .sheet(isPresented: $showBeanDetail, content: {
                NavigationView{
                    BeanView(bean:mostRecentBean, showDetails: $showBeanDetail)
                }
                    .presentationDetents([.height(UIScreen.main.bounds.height * 0.5), .height(UIScreen.main.bounds.height * 0.75)])
                    .presentationBackground(.ultraThinMaterial)
                    .presentationCornerRadius(50)
            })
            
                

                
                
            Button{
                newBeans = true
            }label:{
                HStack(spacing:5){
                    Image(systemName: "plus").resizable().frame(maxWidth:UIScreen.main.bounds.height * 0.01 ,maxHeight: UIScreen.main.bounds.height * 0.01, alignment: .center).foregroundStyle(.inverseText.gradient)
                    Text("add new").customFont(type: .regular, size: .small).foregroundStyle(.inverseText)

                        }.padding(.horizontal).padding(.vertical, 2).background(Capsule().foregroundStyle(.secondaryForeground))
                    }

                .padding(.horizontal)
            }
        .sheet(isPresented: $newBeans, content: {
//            NavigationView{
                AddBeansView(show: $newBeans)
                    .presentationDetents([.medium, .large])
                    .presentationBackground(.thinMaterial)
                    .presentationCornerRadius(50)
//            }
        })
        

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
                    selectedBeans = mostRecentBean
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

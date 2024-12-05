//
//  DialingView.swift
//  Dialed
//
//  Created by Christian Rodriguez on 12/2/24.
//

import SwiftUI

struct DialingView: View {
    @EnvironmentObject var navigation : Navigation
    @Binding var selectedBeans: Beans?
    @Binding var isDialing: Bool
    @Binding var hideView: (Bool, Bool)
    
    
    @State var start : Bool = false
    @State private var isBeanSettled = false
    @Namespace private var beanAnimation
    @Namespace private var beanName
    @Namespace private var beanRoaster
    @Namespace private var beanIcon
    
    @State private var dosePickerConfig: WheelPicker.Config = .init(
        count: 30,
        steps: 10,
        spacing: 10,
        multiplier: 1
    )
    @State private var dose: CGFloat = 18

    
    var body: some View {
        ZStack{
            Color.secondaryForeground.ignoresSafeArea()
            if let selectedBeans{
                VStack {
                    GeometryReader(content: { geometry in
                        let size = geometry.size
                        
                        ZStack {
                            // transitionary animation is complete
                            if hideView.0 {
                                if isBeanSettled {
                                    VStack{
                                        Text("Select Dose").customFont(type: .regular, size: .header).foregroundStyle(.inverseText)
                                        collapsedBean(size: size, bean: selectedBeans)
                                        DosePicker().padding(.vertical)
                                        Spacer()
                                        Button {
                                            
                                        }label: {
                                            Text("continue").customFont(type: .regular, size: .button).foregroundStyle(.inverseText).padding(.horizontal, 50).padding(.vertical, 5).background(.primaryBackground.gradient).clipShape(Capsule())
                                        }.padding(.bottom)
                                    }.safeAreaPadding(.top, 100)
                                }
                                else{
                                    expandedBean(size: size, bean: selectedBeans)
                                }
                                
                                
                                
                            }
                            
                            Spacer()
                        }
                        .frame(width: size.width, height: size.height)
                        .overlay(alignment: .top) {
                            ZStack {
                                Button(action: {
                                    /// Closing the View with animation
                                    hideView.0 = false
                                    hideView.1 = false
                                    isDialing = false
                                    /// Average Navigation Pop takes 0.35s that's the reason I set the animation duration as 0.35s, after the view is popped out, making selectedProfile to nil
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.85) {
                                        self.selectedBeans = nil
                                    }
                                }, label: {
                                    Image(systemName: "xmark")
                                        .foregroundStyle(.white)
                                        .padding(10)
                                        .background(.black, in: .circle)
                                        .contentShape(.circle)
                                })
                                .padding(15)
                                .padding(.top, 40)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)

                            }
                            .opacity(hideView.1 ? 1 : 0)
                            .animation(.snappy, value: hideView.1)
                        }
                        .anchorPreference(key: MAnchorKey.self, value: .bounds, transform: { anchor in
                            return [selectedBeans.id: anchor]
                        })
                    })
                    .ignoresSafeArea()
                    
                }
                .toolbar(hideView.0 ? .hidden : .visible, for: .navigationBar)
                .onAppear(perform: {
                    /// Removing the Animated View once the Animation is Finished
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.smooth){
                            hideView.0 = true
                        }
                    }
                })
            }
        }.navigationBarBackButtonHidden(true)
    }
    
    @ViewBuilder
    func expandedBean(size: CGSize, bean: Beans) -> some View {
        VStack{
            ImageView(bean: bean, size: size)
                .matchedGeometryEffect(id: beanIcon, in: beanAnimation)

                .onAppear(perform: {
                    /// Removing the Animated View once the Animation is Finished
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        hideView.1 = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.spring){
                            start = true
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation(.linear(duration: 0.5)) {
                            isBeanSettled.toggle()
                        }
                    }
                    
                })
            if start{
                Text(bean.name)
                    .customFont(type: .regular, size: .button)
                    .foregroundStyle(.inverseText)
                    .multilineTextAlignment(.center)
                    .matchedGeometryEffect(id: beanName, in: beanAnimation)

                Text(bean.roaster)
                    .customFont(type: .light, size: .subheader)
                    .foregroundStyle(.inverseText)
                    .multilineTextAlignment(.center)
                    .matchedGeometryEffect(id: beanRoaster, in: beanAnimation)

            }
        }
    }
    
    @ViewBuilder
    func collapsedBean(size: CGSize, bean: Beans) -> some View {
        VStack{
            HStack{
                Image("beans")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .matchedGeometryEffect(id: beanIcon, in: beanAnimation)
                if start{
                    VStack(alignment:.leading){
                        Text(bean.name)
                            .customFont(type: .regular, size: .subheader)
                            .foregroundStyle(.primaryText)
                            .multilineTextAlignment(.center)
                            .matchedGeometryEffect(id: beanName, in: beanAnimation)

                        Text(bean.roaster)
                            .customFont(type: .light, size: .body)
                            .foregroundStyle(.primaryText)
                            .multilineTextAlignment(.center)
                            .matchedGeometryEffect(id: beanRoaster, in: beanAnimation)
                    }

                }
            }.padding().background(.primaryBackground.gradient).clipShape(RoundedRectangle(cornerRadius: 10))
            Button {
                
            } label: {
                Text("dial in new beans").customFont(type: .regular, size: .caption).foregroundStyle(.primaryBackground)
            }

        }
    }
    
    @ViewBuilder
    func DosePicker() -> some View {
        VStack{
            HStack(alignment: .lastTextBaseline, spacing: 5, content: {
                Text(verbatim: "\(dose)")
                    .customFont(type: .regular, size: .header)
                    .foregroundStyle(.inverseText)
                    .contentTransition(.numericText(value: dose))
                    .animation(.snappy, value: dose)
                
                Text("grams")
                    .customFont(type: .regular, size: .body)
                    .foregroundStyle(.inverseText)
            })
            .padding(.vertical, 30)
            .padding(.bottom, 50)
            
            WheelPicker(config: dosePickerConfig, value: $dose)
                .frame(height: 60)
        }
    }
}



#Preview {
    ContentView()
}


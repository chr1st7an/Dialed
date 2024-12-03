//
//  BeanView.swift
//  Dialed
//
//  Created by Christian Rodriguez on 12/2/24.
//

import SwiftUI

struct BeanView: View {
    @EnvironmentObject var navigation : Navigation
    @Binding var selectedBeans: Beans?
    @Binding var showBean: Bool
    @Binding var hideView: (Bool, Bool)
    
    var body: some View {
        ZStack{
            Color.secondaryForeground.ignoresSafeArea()
            if let selectedBeans{
                VStack {
                    GeometryReader(content: { geometry in
                        let size = geometry.size
                        
                        ZStack {
                            if hideView.0 {
                                
                                
                                VStack{
                                    ImageView(bean: selectedBeans, size: size)
                                            .onAppear(perform: {
                                                /// Removing the Animated View once the Animation is Finished
                                                DispatchQueue.main.asyncAfter(deadline: .now()) {
                                                    hideView.1 = true
                                                }
                                            })
                                    Text(selectedBeans.name)
                                        .customFont(type: .regular, size: .button)
                                        .foregroundStyle(.inverseText)
                                        .multilineTextAlignment(.center)
                                    Text(selectedBeans.roaster)
                                        .customFont(type: .light, size: .subheader)
                                        .foregroundStyle(.inverseText)
                                        .multilineTextAlignment(.center)
                                }
                                
                                
                            }
                            
                            Spacer()
                        }.frame(width: size.width, height: size.height)
                            .overlay(alignment: .top) {
                                ZStack {
                                    Button(action: {
                                        /// Closing the View with animation
                                        hideView.0 = false
                                        hideView.1 = false
                                        showBean = false
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

                        /// Destination View Anchor
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
                        hideView.0 = true
                    }
                })
            }
        }.navigationBarBackButtonHidden(true)

    }
}



#Preview {
    ContentView()
}


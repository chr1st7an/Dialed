//
//  LayerView.swift
//  Dialed
//
//  Created by Christian Rodriguez on 12/3/24.
//

import SwiftUI

struct LayerView: View {
    var selectedBeans: Beans?
    var hideView: (Bool, Bool)
    var value: [String: Anchor<CGRect>]
    var pushView: Bool
    /// Storing Source Rect
    @State private var sourceRect: CGRect = .zero
    var body: some View {
        GeometryReader(content: { geometry in
            if let selectedBeans, let anchor = value[selectedBeans.id] {
                let rect = pushView ? geometry[anchor] : sourceRect
                
                ImageView(bean: selectedBeans, size: rect.size)
                    .frame(width: rect.size.width , height: rect.size.height)                    .offset(x: rect.minX, y: rect.minY)
                    /// Simply Animating the rect will add the geometry Effect we needed
                    .animation(.snappy(duration: 0.75, extraBounce: 0), value: rect)
                    .transition(.identity)
                    .onAppear {
                        if sourceRect == .zero {
                            sourceRect = rect
                        }
                    }
                    .onDisappear {
                        sourceRect = .zero
                    }
                    .opacity(!hideView.0 ? 1 : 0)
//                Spacer()
            }
        })
    }
}

struct ImageView: View {
    var bean: Beans
    var size: CGSize
    var body: some View {
//        VStack{
            
            Image("beans")
                .resizable()
                .frame(width: size.width > 60 ? 100 : size.width, height: size.width > 60 ? 100 : size.height)
//            if size.width > 60 {
//                Group{
//                    Text(bean.name)
//                        .customFont(type: .regular, size: .button)
//                        .foregroundStyle(.inverseText)
//                        .multilineTextAlignment(.center)
//                    Text(bean.roaster)
//                        .customFont(type: .light, size: .subheader)
//                        .foregroundStyle(.inverseText)
//                        .multilineTextAlignment(.center)
//                }.opacity(0)
//            }
//            if size.width > 60 {
//                Text("test").transition(.opacity)
//            }
//            Spacer()
//        }
//            .frame(width: size.width , height: size.height)
//            / Linear Gradient at Bottom
//            .overlay(content: {
//                VStack(content: {
//                    Text(bean.name)
//                    Text(bean.roaster)
//
//                })
//                .opacity(size.width > 60 ? 1 : 0)
//            })
//            .clipShape(.rect(cornerRadius: size.width > 60 ? 0 : 30))
    }
}

#Preview {
    ContentView()
}

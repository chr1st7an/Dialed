//
//  LayerView.swift
//  Dialed
//
//  Created by Christian Rodriguez on 12/3/24.
//

import SwiftUI

struct LayerView: View {
    var selectedBeans: CoffeeBean?
    var hideView: (Bool, Bool)
    var value: [String: Anchor<CGRect>]
    var pushView: Bool
    /// Storing Source Rect
    @State private var sourceRect: CGRect = .zero
    var body: some View {
        GeometryReader(content: { geometry in
            if let selectedBeans, let anchor = value[selectedBeans.id.uuidString] {
                let rect = pushView ? geometry[anchor] : sourceRect
                
                ImageView(bean: selectedBeans, size: rect.size)
                    .frame(width: rect.size.width , height: rect.size.height)
                    .offset(x: rect.minX, y: rect.minY)
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
    var bean: CoffeeBean
    var size: CGSize
    var body: some View {
//        VStack{
            
            Image("beans")
                .resizable()
                .frame(width: size.width > 60 ? 100 : size.width, height: size.width > 60 ? 100 : size.height)
    }
}

struct PulsatingCirclesView: View {
    @State private var animate = false
    let size: CGFloat

    var body: some View {
        VStack {
            ZStack {
                Circle().fill(.primaryBackground.opacity(0.25))
                    .frame(width: size * 1.4, height: size * 1.4)
                    .scaleEffect(animate ? 1 : 0.85) // Adding scale effect for pulsating
                
                Circle().fill(.primaryBackground.opacity(0.35))
                    .frame(width: size * 1.3, height: size * 1.3)
                    .scaleEffect(animate ? 1 : 0.82) // Adding scale effect for pulsating

                Circle().fill(.primaryBackground.opacity(0.45))
                    .frame(width: size * 1.15, height: size * 1.15)
                    .scaleEffect(animate ? 1 : 0.80) // Adding scale effect for pulsating

                Circle().fill(.primaryBackground.opacity(0.75))
                    .frame(width: size, height: size)
                    .scaleEffect(animate ? 1 : 0.95) // Adding scale effect for pulsating
            }
            .onAppear {
                animate.toggle()
            }
            .animation(Animation.easeInOut(duration: 0.99).repeatForever(autoreverses: true), value: animate)
        }
    }
}

#Preview {
    ContentView()
}

//
//  DialingView.swift
//  Dialed
//
//  Created by Christian Rodriguez on 12/2/24.
//

import SwiftUI

struct DialingView: View {
    @EnvironmentObject var navigation : Navigation
    @StateObject var dialingVm = DialingViewModel()
    @Binding var selectedBeans: Beans?
    @Binding var isDialing: Bool
    @Binding var hideView: (Bool, Bool)
    
    
    @State var start : Bool = false
    @State var animateGradient = false

    @State private var isBeanSettled = false
    @Namespace private var beanAnimation
    @Namespace private var beanName
    @Namespace private var beanRoaster
    @Namespace private var beanIcon
    
    var body: some View {
        ZStack{
            LinearGradient(colors: animateGradient ? [.secondaryForeground, .secondaryForeground.opacity(0.7)] : [.secondaryForeground.opacity(0.7), .secondaryForeground], startPoint: .top, endPoint: animateGradient ? .bottom : . bottomTrailing).edgesIgnoringSafeArea(.all)
                .onAppear {
                                withAnimation(.easeInOut(duration: 5).repeatForever(autoreverses: true)) {
                                    animateGradient.toggle()
                                }
                            }
            if let selectedBeans{
                VStack {
                    GeometryReader(content: { geometry in
                        let size = geometry.size
                        
                        ZStack {
                            // transitionary animation is complete
                            if hideView.0 {
                                if isBeanSettled {
                                    ZStack{
                                        switch dialingVm.step {
                                        case .dose:
                                            DoseInput(size: size, bean: selectedBeans).transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .top)))
                                        case .extraction:
                                            TimeInput(size: size, bean: selectedBeans).transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .top)))
                                        case .yield:
                                            YieldInput(size: size, bean: selectedBeans).transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .top)))
                                        case .tastingNotes:
                                            TastingNotes(size: size, bean: selectedBeans).transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .top)))
                                        }
                                    }
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
                            .overlay(alignment: .bottom) {
                                VStack(spacing: 20){
                                    HStack(alignment: .center, spacing: 20){
                                        // step icons
                                        Image("beans").resizable().frame(width: 20, height: 20).scaleEffect(dialingVm.step == .dose ? 1.7 : 1)
                                        Image(systemName: "timer").resizable().frame(width: 20, height: 20).clipShape(Circle()).scaleEffect(dialingVm.step == .extraction ? 1.7 : 1).redacted(reason: dialingVm.step == .dose ? .placeholder : [])
                                        Image(systemName: "cup.and.heat.waves.fill")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .if(dialingVm.step == .dose || dialingVm.step == .extraction) { view in
                                                        view.clipShape(Circle())
                                                    }
                                            .scaleEffect(dialingVm.step == .yield ? 1.7 : 1).redacted(reason: dialingVm.step == .dose || dialingVm.step == .extraction ? .placeholder : [])
                                        Image(systemName: "checklist.rtl").resizable().frame(width: 20, height: 20)
                                            .if(dialingVm.step != .tastingNotes) { view in
                                                        view.clipShape(Circle())
                                                    }
                                            .scaleEffect(dialingVm.step == .tastingNotes ? 1.7 : 1).redacted(reason: dialingVm.step  != .tastingNotes ? .placeholder : [])
                                        

                                    }
                                    HStack(spacing:25){
                                        if dialingVm.step != .dose{
                                            Button {
                                                withAnimation{
                                                    switch dialingVm.step {
                                                    case .dose:
                                                        dialingVm.step = .dose
                                                    case .extraction:
                                                        dialingVm.step = .dose
                                                    case .yield:
                                                        dialingVm.step = .extraction
                                                    case .tastingNotes:
                                                        dialingVm.step = .yield
                                                    }
                                                }
                                            }label: {
                                                Text("← back").customFont(type: .light, size: .body).foregroundStyle(.primaryText)
                                                    
                                                .foregroundStyle(.primaryText)
                                            }.padding(.bottom)
                                        }
                                        Button {
                                            withAnimation{
                                                switch dialingVm.step {
                                                case .dose:
                                                    dialingVm.step = .extraction
                                                case .extraction:
                                                    dialingVm.step = .yield
                                                case .yield:
                                                    dialingVm.step = .tastingNotes
                                                case .tastingNotes:
                                                    dialingVm.step = .dose
                                                }                                            }
                                        }label: {
                                            Text("next →").customFont(type: .light, size: .body).foregroundStyle(.inverseText)
                                                
                                            .foregroundStyle(.primaryText)
                                        }
                                        .padding(.bottom)
                                        .if(( dialingVm.step == .extraction && !finalizeExtraction)) { button in
                                            button.disabled(true)
                                        }
                                    }
                                }.padding(.bottom, 10)
                            }
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
    
    // DOSE
    @State private var dosePickerConfig: WheelPicker.Config = .init(
        count: 50,
        steps: 10,
        spacing: 10,
        multiplier: 1
    )
    @State private var dose: CGFloat = 18
    
    @ViewBuilder
    func DoseInput(size: CGSize, bean: Beans) -> some View {
        VStack{
            Text("Select Dose").customFont(type: .regular, size: .header).foregroundStyle(.inverseText)
            collapsedBean(size: size, bean: bean)
            DosePicker().padding(.vertical)
            Spacer()
            
        }.safeAreaPadding(.top, 100)
    }
    
    // EXTRACTION
    @State var startTimer : Bool = false
    @State var finalizeExtraction : Bool = false

    @State private var extractionTime: CGFloat = 0
    @State private var timer: Timer? = nil
    
    private func startExtraction() {
            timer?.invalidate() // Stop any existing timer
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                extractionTime += 1
            }
        }
        
    private func stopExtraction() {
            timer?.invalidate()
            timer = nil
        }
    
    @State private var extractionPickerConfig: WheelPicker.Config = .init(
        count: 60,
        steps: 10,
        spacing: 10,
        multiplier: 1
    )
    
    @ViewBuilder
    func TimeInput(size: CGSize, bean: Beans) -> some View {
        VStack{
            Text("Record Extraction Time").customFont(type: .regular, size: .header).foregroundStyle(.inverseText).multilineTextAlignment(.center)
            VStack{
                if startTimer {
                    Text(verbatim: "\(extractionTime)")
                        .customFont(type: .regular, size: .header)
                        .foregroundStyle(.inverseText)
                        .contentTransition(.numericText(value: dose))
                        .animation(.snappy, value: extractionTime)
                        .if(!finalizeExtraction){ view in
                            view
                                .background(PulsatingCirclesView(size: 200))

                        }
                        .padding(.top, 170)
                }else{
                    Button{
                        withAnimation{
                            startTimer.toggle()
                            if startTimer {
                                startExtraction()
                            }
                        }
                    }label:{
                        Image(systemName: "play.circle.fill")
                            .resizable()
                            .frame(width: 200, height: 200)
                            .foregroundStyle(.primaryBackground)
                            .padding(100)
                    }
                }
                
                if finalizeExtraction {
                    Text("seconds").customFont(type: .light, size: .body)
                    WheelPicker(config: extractionPickerConfig, value: $extractionTime).padding(.bottom, 100)
                }
                
                if !finalizeExtraction{
                    if startTimer || extractionTime >= 1{
                        Button{
                            withAnimation{
                                finalizeExtraction.toggle()
                                stopExtraction()
                            }
                        }label:{
                            Text("complete")
                                .customFont(type: .regular, size: .body)
                                .foregroundStyle(.inverseText)
                        }
                        .padding(.vertical, 100)
                    }
                }
            }
            
            Spacer()
            
        }.safeAreaPadding(.top, 100)
    }
    
    // YIELD
    @State private var yieldPickerConfig: WheelPicker.Config = .init(
        count: 100,
        steps: 10,
        spacing: 10,
        multiplier: 1
    )
    @State private var yield: CGFloat = 18
    
    @ViewBuilder
    func YieldInput(size: CGSize, bean: Beans) -> some View {
        VStack{
            Text("Extraction Yield").customFont(type: .regular, size: .header).foregroundStyle(.inverseText)
            YieldPicker().padding(.vertical)
            Spacer()
            
        }.safeAreaPadding(.top, 100)
    }
    
    @ViewBuilder
    func TastingNotes(size: CGSize, bean: Beans) -> some View {
        VStack{
            Text("Tasting Notes").customFont(type: .regular, size: .header).foregroundStyle(.inverseText)
//            collapsedBean(size: size, bean: bean)
            Spacer()
        }.safeAreaPadding(.top, 100)
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
            }.padding().background(.ultraThinMaterial).clipShape(RoundedRectangle(cornerRadius: 5))
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
    
    @ViewBuilder
    func YieldPicker() -> some View {
        VStack{
            HStack(alignment: .lastTextBaseline, spacing: 5, content: {
                Text(verbatim: "\(yield)")
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
            
            WheelPicker(config: yieldPickerConfig, value: $yield)
                .frame(height: 60)
        }
    }
}



#Preview {
    ContentView()
}


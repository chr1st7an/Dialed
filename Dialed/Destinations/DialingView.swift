//
//  DialingView.swift
//  Dialed
//
//  Created by Christian Rodriguez on 12/2/24.
//

import SwiftUI
import Sliders

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
    
    @Namespace private var assesmentAnimation
    @Namespace private var dose
    @Namespace private var grind
    @Namespace private var extraction
    @Namespace private var yield
    @Namespace private var tastingNotes

    
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
                                        case .grind:
                                            GrindInput(size: size, bean: selectedBeans).transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .top)))
                                        case .extraction:
                                            TimeInput(size: size, bean: selectedBeans).transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .top)))
                                        case .yield:
                                            YieldInput(size: size, bean: selectedBeans).transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .top)))
                                        case .tastingNotes:
                                            TastingNotes(size: size, bean: selectedBeans).transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .top)))
                                        case .assessment:
                                            AssesmentView(size: size, bean: selectedBeans).transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .top)))
                                        
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
                            .opacity(0)
                            .animation(.snappy, value: hideView.1)
                            .overlay(alignment: .bottom) {
                                VStack(spacing: 20){
                                    if dialingVm.step != .assessment{
                                        HStack(alignment: .center, spacing: 20){
                                            // step icons
                                            Image("darkBean")
                                                .resizable()
                                                .frame(width: 20, height: 20)
                                                .scaleEffect(dialingVm.step == .dose ? 1.7 : 1)
                                                .matchedGeometryEffect(id: dose, in: assesmentAnimation)
                                            

                                            Image(systemName: "dial.medium.fill")
                                                .if(dialingVm.step == .dose) { view in
                                                            view.clipShape(Circle())
                                                }
                                                .clipShape(Circle())
                                                .foregroundStyle(.black)
                                                .scaleEffect(dialingVm.step == .grind ? 1.7 : 1)
                                                .redacted(reason: dialingVm.step == .dose ? .placeholder : [])
                                                .matchedGeometryEffect(id: grind, in: assesmentAnimation)
                                            Image(systemName: "timer")
                                                .clipShape(Circle())
                                                .foregroundStyle(.black)
                                                .scaleEffect(dialingVm.step == .extraction ? 1.7 : 1)
                                                .redacted(reason: dialingVm.step == .dose || dialingVm.step == .grind ? .placeholder : [])
                                                .matchedGeometryEffect(id: extraction, in: assesmentAnimation)
                                            Image(systemName: "cup.and.heat.waves.fill")
                                                .foregroundStyle(.black)
                                                .if(dialingVm.step == .dose || dialingVm.step == .extraction || dialingVm.step == .grind) { view in
                                                            view.clipShape(Circle())
                                                }
                                                .scaleEffect(dialingVm.step == .yield ? 1.7 : 1)
                                            
                                                .redacted(reason: dialingVm.step == .dose || dialingVm.step == .extraction || dialingVm.step == .grind ? .placeholder : [])
                                                .matchedGeometryEffect(id: yield, in: assesmentAnimation)
                                            Image(systemName: "checklist.rtl")
                                                .foregroundStyle(.black)
                                                .if(dialingVm.step == .dose || dialingVm.step == .extraction || dialingVm.step == .grind || dialingVm.step == .yield) { view in
                                                            view.clipShape(Circle())
                                                }
                                                .scaleEffect(dialingVm.step == .tastingNotes ? 1.7 : 1)
                                                .redacted(reason: dialingVm.step == .dose || dialingVm.step == .extraction || dialingVm.step == .grind || dialingVm.step == .yield ? .placeholder : [])
                                                .matchedGeometryEffect(id: tastingNotes, in: assesmentAnimation)
                                            
                                        }
                                    }

                                    if dialingVm.step != .assessment{
                                        HStack(spacing:25){
                                                Button {
                                                    withAnimation{
                                                        switch dialingVm.step {
                                                        case .dose:
                                                            /// Closing the View with animation
                                                            hideView.0 = false
                                                            hideView.1 = false
                                                            isDialing = false
                                                            /// Average Navigation Pop takes 0.35s that's the reason I set the animation duration as 0.35s, after the view is popped out, making selectedProfile to nil
                                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.85) {
                                                                self.selectedBeans = nil
                                                            }
                                                        case .grind:
                                                            dialingVm.step = .dose
                                                        case .extraction:
                                                            dialingVm.step = .grind
                                                        case .yield:
                                                            dialingVm.step = .extraction
                                                        case .tastingNotes:
                                                            dialingVm.step = .yield
                                                        case .assessment:
                                                            dialingVm.step = .tastingNotes
                                                            
                                                        }
                                                    }
                                                }label: {
                                                    Text("← back").customFont(type: .light, size: .body).foregroundStyle(.primaryText)
                                                        
                                                    .foregroundStyle(.primaryText)
                                                }.padding(.bottom)
                                            
                                            Button {
                                                withAnimation{
                                                    switch dialingVm.step {
                                                    case .dose:
                                                        dialingVm.step = .grind
                                                    case .grind:
                                                        dialingVm.step = .extraction
                                                    case .extraction:
                                                        dialingVm.step = .yield
                                                    case .yield:
                                                        dialingVm.step = .tastingNotes
                                                    case .tastingNotes:
                                                        withAnimation(.snappy(duration: 1)) {
                                                            hideTransition = false
                                                            dialingVm.step = .assessment
                                                        }
                                                    case .assessment:
                                                        dialingVm.step = .dose
                                                    }
                                                }
                                            }label: {
                                                Text("next →").customFont(type: .light, size: .body).foregroundStyle(.inverseText)
                                                    
                                                .foregroundStyle(.primaryText)
                                            }
                                            .padding(.bottom)
                                            .if(( dialingVm.step == .extraction && !finalizeExtraction)) { button in
                                                button.disabled(true)
                                            }
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
    @ViewBuilder
    func DoseInput(size: CGSize, bean: Beans) -> some View {
        VStack{
            Text("Select Dose").customFont(type: .regular, size: .header).foregroundStyle(.inverseText)
            collapsedBean(size: size, bean: bean)
            DosePicker().padding(.vertical)
            Spacer()
            
        }.safeAreaPadding(.top, 100)
    }
    
    // GRIND
    @FocusState private var isFocused: Bool // State to manage focus
    @ViewBuilder
    func GrindInput(size: CGSize, bean: Beans) -> some View {
        VStack{
            Text("Grind Settings").customFont(type: .regular, size: .header).foregroundStyle(.inverseText)
            CurrentGrinderView(grinder: grinderTest)
                .padding(.vertical)
            HStack {
                Image(systemName: "list.clipboard.fill").foregroundStyle(.inverseText.gradient)
                ZStack{
                    if dialingVm.currentShot.grind.notes.isEmpty{
                        HStack{
                            Text("enter specific machine setting").customFont(type: .regular, size: .body).foregroundStyle(.inverseText.opacity(0.4))
                            Spacer()
                        }
                    }
                    TextField("", text: $dialingVm.currentShot.grind.notes)
                        .tint(.inverseText)
                        .font(Font.custom("Parkinsans-Regular", fixedSize: 22))
//                        .focused($isFocused) // Attach focus state to the TextField
//                        .onAppear {
//                            if dialingVm.currentShot.grind.notes.isEmpty{
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                                        isFocused = true // Trigger the keyboard to show
//                                }
//                            }
//                        }
                }
            }.underlineTextField(color: .inverseText).padding(.top)
            Spacer()
            
        }.safeAreaPadding(.top, 100)
    }
    
    // EXTRACTION
    @State var startTimer : Bool = false
    @State var finalizeExtraction : Bool = false
    @State private var timer: Timer? = nil
    private func startExtraction() {
            timer?.invalidate() // Stop any existing timer
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                dialingVm.currentShot.extractionTime += 1
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
                    Text(verbatim: "\(dialingVm.currentShot.extractionTime)")
                        .customFont(type: .regular, size: .header)
                        .foregroundStyle(.white)
                        .contentTransition(.numericText(value: dialingVm.currentShot.extractionTime))
                        .animation(.snappy, value: dialingVm.currentShot.extractionTime)
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
                    }.disabled(startTimer)
                }
                
                if finalizeExtraction {
                    Text("seconds").customFont(type: .light, size: .body)
                    WheelPicker(config: extractionPickerConfig, value: $dialingVm.currentShot.extractionTime).padding(.bottom, 100)
                }
                
                if !finalizeExtraction{
                    if startTimer || dialingVm.currentShot.extractionTime >= 1{
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
                        .disabled(finalizeExtraction)
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
    @ViewBuilder
    func YieldInput(size: CGSize, bean: Beans) -> some View {
        VStack{
            Text("Extraction Yield").customFont(type: .regular, size: .header).foregroundStyle(.inverseText)
            YieldPicker().padding(.vertical)
            Spacer()
            
        }.safeAreaPadding(.top, 100)
    }
    
    @State var hideTransition: Bool = false
    @ViewBuilder
    func AssesmentView(size: CGSize, bean: Beans) -> some View {
        VStack{
//            Text("Dialed?").customFont(type: .regular, size: .header).foregroundStyle(.inverseText)
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
                }.padding().background(.primaryForeground).clipShape(RoundedRectangle(cornerRadius: 5))
                HStack{
                    HStack(spacing:0){
                        Image("Hand")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("Gaggia Classic Pro").customFont(type: .regular, size: .caption).multilineTextAlignment(.leading).foregroundStyle(.inverseText)
                    }
                    Spacer()
                    HStack(spacing:0){
                        Image(grinderTest.type.rawValue)
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text(grinderTest.name).customFont(type: .regular, size: .caption).multilineTextAlignment(.leading).foregroundStyle(.inverseText)
                    }
                }.padding(.horizontal, 35)
            }.padding(.vertical, 30)
            HStack(alignment:.center){
                VStack(alignment:.leading, spacing: 28){
                    Image("darkBean")
                        .resizable()
                        .frame(width: 33, height: 33)
                        .offset(x:-7)
                        .matchedGeometryEffect(id: dose, in: assesmentAnimation)
                    Image(systemName: "timer")
                        .foregroundStyle(.black)
                        .matchedGeometryEffect(id: extraction, in: assesmentAnimation)
                        .scaleEffect(2)
                    Image(systemName: "cup.and.heat.waves.fill")
                        .foregroundStyle(.black)
                        .matchedGeometryEffect(id: yield, in: assesmentAnimation)
                        .scaleEffect(2)
                }
                VStack(alignment:.leading, spacing: 25){
                    Text("\(String(format: "%.1f", dialingVm.currentShot.dose)) grams")
                        .customFont(type: .regular, size: .subheader).foregroundStyle(.inverseText)
                    Text("\(String(format: "%.1f", dialingVm.currentShot.extractionTime)) seconds")
                        .customFont(type: .regular, size: .subheader).foregroundStyle(.inverseText)
                    Text("\(String(format: "%.1f", dialingVm.currentShot.yield)) grams")
                        .customFont(type: .regular, size: .subheader).foregroundStyle(.inverseText)
                }.padding(.top, 10)
            }.padding().opacity(hideTransition ? 0 : 1)
            
            Spacer()
            VStack{
                Button {
                    /// Closing the View with animation
                    hideView.0 = false
                    hideView.1 = false
                    isDialing = false
                    /// Average Navigation Pop takes 0.35s that's the reason I set the animation duration as 0.35s, after the view is popped out, making selectedProfile to nil
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.85) {
                        self.selectedBeans = nil
                    }
                }label: {
                    Text("Dialed In").customFont(type: .regular, size: .subheader).foregroundStyle(.primaryText).padding(.horizontal, 75).padding(.vertical, 3).background(.primaryBackground.gradient).clipShape(Capsule())
                }
                Button{
                    withAnimation{
                        hideTransition = true
                    }
                    startTimer = false
                    finalizeExtraction = false
                    dialingVm.shots.append(dialingVm.currentShot)
                    dialingVm.currentShot = espressoShotShell
                    withAnimation {
                        dialingVm.step = .dose
                    }
                }label: {
                    Text("redo shot").customFont(type: .regular, size: .body).foregroundStyle(.inverseText)
                }
            }.padding(.bottom, 32)
        }.safeAreaPadding(.top, 100)
    }
    
    @ViewBuilder
    func TastingNotes(size: CGSize, bean: Beans) -> some View {
        VStack{
            Text("Tasting Notes").customFont(type: .regular, size: .header).foregroundStyle(.inverseText)
            VStack{
                HStack{
                    Text("Acidity").customFont(type: .bold, size: .body)
                    Button {
                        
                    } label: {
                        Image(systemName: "info.circle.fill").foregroundStyle(.primaryText.gradient)
                    }
                    Spacer()
                    Text(dialingVm.currentShot.tastingNotes.acidity < 0.2 ? "basic" : dialingVm.currentShot.tastingNotes.acidity < 0.5 ? "slightly" : dialingVm.currentShot.tastingNotes.acidity < 0.7 ? "moderate" : dialingVm.currentShot.tastingNotes.acidity < 0.9 ? "strong" : "extreme" ).customFont(type: .light, size: .body).foregroundStyle(.inverseText)

                }
                ValueSlider(value: $dialingVm.currentShot.tastingNotes.acidity)
                    .valueSliderStyle(HorizontalValueSliderStyle(track:  HorizontalRangeTrack(
                        view: Capsule().foregroundColor(.primaryBackground)
                    )
                    .frame(height: 20)))
                    .frame(height: 20)
            }.padding()
            VStack{
                HStack{
                    Text("Bitterness").customFont(type: .bold, size: .body)
                    Button {
                        
                    } label: {
                        Image(systemName: "info.circle.fill").foregroundStyle(.primaryText.gradient)
                    }
                    Spacer()
                    Text(dialingVm.currentShot.tastingNotes.bitterness < 0.2 ? "sweet" : dialingVm.currentShot.tastingNotes.bitterness < 0.5 ? "slightly" : dialingVm.currentShot.tastingNotes.bitterness < 0.7 ? "balanced" : dialingVm.currentShot.tastingNotes.bitterness < 0.9 ? "strong" : "tart" ).customFont(type: .light, size: .body).foregroundStyle(.inverseText)

                }
                ValueSlider(value: $dialingVm.currentShot.tastingNotes.bitterness)
                    .valueSliderStyle(HorizontalValueSliderStyle(track:  HorizontalRangeTrack(
                        view: Capsule().foregroundColor(.primaryBackground)
                    )
                    .frame(height: 20)))
                    .frame(height: 20)
            }.padding()
            VStack{
                HStack{
                    Text("Crema").customFont(type: .bold, size: .body)
                    Button {
                        
                    } label: {
                        Image(systemName: "info.circle.fill").foregroundStyle(.primaryText.gradient)
                    }
                    Spacer()
                    Text(dialingVm.currentShot.tastingNotes.crema < 0.2 ? "none" : dialingVm.currentShot.tastingNotes.crema < 0.5 ? "thin" : dialingVm.currentShot.tastingNotes.crema < 0.7 ? "decent" : dialingVm.currentShot.tastingNotes.crema < 0.9 ? "thick" : "rich" ).customFont(type: .light, size: .body).foregroundStyle(.inverseText)

                }
                ValueSlider(value: $dialingVm.currentShot.tastingNotes.crema)
                    .valueSliderStyle(HorizontalValueSliderStyle(track:  HorizontalRangeTrack(
                        view: Capsule().foregroundColor(.primaryBackground)
                    )
                    .frame(height: 20)))
                    .frame(height: 20)
            }.padding()
            VStack{
                HStack{
                    Text("Satisfaction").customFont(type: .bold, size: .body)
                    Button {
                        
                    } label: {
                        Image(systemName: "info.circle.fill").foregroundStyle(.primaryText.gradient)
                    }
                    Spacer()
                    Text(dialingVm.currentShot.tastingNotes.satisfaction < 0.2 ? "bad" : dialingVm.currentShot.tastingNotes.satisfaction < 0.5 ? "alright" : dialingVm.currentShot.tastingNotes.satisfaction < 0.7 ? "decent" : dialingVm.currentShot.tastingNotes.satisfaction < 0.9 ? "great" : "perfect" ).customFont(type: .light, size: .body).foregroundStyle(.inverseText)

                }
                ValueSlider(value: $dialingVm.currentShot.tastingNotes.satisfaction)
                    .valueSliderStyle(HorizontalValueSliderStyle(track:  HorizontalRangeTrack(
                        view: Capsule().foregroundColor(.primaryBackground)
                    )
                    .frame(height: 20)))
                    .frame(height: 20)
            }.padding()

            Spacer()
        }.safeAreaPadding(.top, 100)
    }
    
    @ViewBuilder
    func DosePicker() -> some View {
        VStack{
            HStack(alignment: .lastTextBaseline, spacing: 5, content: {
                Text(verbatim: "\(dialingVm.currentShot.dose)")
                    .customFont(type: .regular, size: .header)
                    .foregroundStyle(.inverseText)
                    .contentTransition(.numericText(value: dialingVm.currentShot.dose))
                    .animation(.snappy, value: dialingVm.currentShot.dose)
                
                Text("grams")
                    .customFont(type: .regular, size: .body)
                    .foregroundStyle(.inverseText)
            })
            .padding(.vertical, 30)
            .padding(.bottom, 50)
            
            WheelPicker(config: dosePickerConfig, value: $dialingVm.currentShot.dose)
                .frame(height: 60)
        }
    }
    
    @ViewBuilder
    func YieldPicker() -> some View {
        VStack{
            HStack(alignment: .lastTextBaseline, spacing: 5, content: {
                Text(verbatim: "\(dialingVm.currentShot.yield)")
                    .customFont(type: .regular, size: .header)
                    .foregroundStyle(.inverseText)
                    .contentTransition(.numericText(value: dialingVm.currentShot.yield))
                    .animation(.snappy, value: dialingVm.currentShot.yield)
                
                Text("grams")
                    .customFont(type: .regular, size: .body)
                    .foregroundStyle(.inverseText)
            })
            .padding(.vertical, 30)
            .padding(.bottom, 50)
            
            WheelPicker(config: yieldPickerConfig, value: $dialingVm.currentShot.yield)
                .frame(height: 60)
        }
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
            }.padding().background(.inverseText.opacity(0.5)).clipShape(RoundedRectangle(cornerRadius: 5))
            Button {
                
            } label: {
                Text("dial in new beans").customFont(type: .regular, size: .caption).foregroundStyle(.primaryBackground)
            }

        }
    }

}



#Preview {
    ContentView()
}


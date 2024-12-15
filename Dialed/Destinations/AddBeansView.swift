//
//  AddBeansView.swift
//  Dialed
//
//  Created by Christian Rodriguez on 12/15/24.
//

import SwiftUI
import CodeScanner
import CarBode
struct AddBeansView: View {
    @State private var isPresentingScanner = false
    @State private var scannedCode: String?
    @State private var animateGradient = true
    
    @State var bean : Beans = .init(name: "", roaster: "", roastedOn: Date(), preground: false)

    var body: some View {
        ZStack{
            LinearGradient(colors: animateGradient ? [.primaryBackground, .primaryForeground] : [.primaryForeground, .primaryBackground], startPoint: .top, endPoint: animateGradient ? .bottom : . bottomTrailing).edgesIgnoringSafeArea(.all)
                .onAppear {
                                withAnimation(.easeInOut(duration: 10).repeatForever(autoreverses: true)) {
                                    animateGradient.toggle()
                                }
                }.ignoresSafeArea()
            Form {
                Section{
                    TextField("Bean Name", text: $bean.name)
                    TextField("Roaster", text: $bean.roaster)

                    DatePicker(
                                   "Roasted On",
                                   selection: $bean.roastedOn,
                                   displayedComponents: [.date]
                               )
                }footer: {
                    HStack{
                        Spacer()
                        Button{
                            isPresentingScanner = true
                        }label:{
                            HStack{
                                Text("autofill with scanner").customFont(type: .light, size: .caption).foregroundStyle(.primaryText.opacity(0.7))
                                Image(systemName: "barcode.viewfinder").foregroundStyle(.primaryText.gradient)
                            }
                        }
                        Spacer()
                    }
                }
                .listRowBackground(Color.inverseText.opacity(0.5))
//                Section {
//                    Picker("Roast Strength", selection: $bean.) {
//                                        ForEach(strengths, id: \.self) {
//                                            Text($0)
//                                        }
//                                    }
//                                    .pickerStyle(.wheel)
//                                }

            }
            .foregroundStyle(.primaryText)
            .tint(.primaryBackground)
            .scrollContentBackground(.hidden)

        }
        .sheet(isPresented: $isPresentingScanner) {
            VStack{
                    CBScanner(
                        supportBarcode: .constant([.code39, .aztec, .aztec, .qr, .code128, .code93, .codabar, .ean8, .ean13, .code39Mod43,.upce, .catBody]), //Set type of barcode you want to scan
                            scanInterval: .constant(1.0) //Event will trigger every 5 seconds
                        ){
                            //When the scanner found a barcode
                            print("BarCodeType =",$0.type.rawValue, "Value =",$0.value)
                        }
                        onDraw: {
                            //line width
                            let lineWidth = 2

                            //line color
                            let lineColor = UIColor(Color.primaryBackground)

                            //Fill color with opacity
                            //You also can use UIColor.clear if you don't want to draw fill color
                            let fillColor = UIColor(.white.opacity(0.2))

                            //Draw box
                            $0.draw(lineWidth: CGFloat(lineWidth), lineColor: lineColor, fillColor: fillColor)
                        }
                }
//                CodeScannerView(codeTypes: ) { response in
//                            if case let .success(result) = response {
//                                print("Found code: \(result.string)")
//
//                                scannedCode = result.string
//                                isPresentingScanner = false
//                            }
//                        }
                }

        .navigationTitle("New Beans")
    }
}

#Preview {
    NavigationView{
        AddBeansView()
    }
}

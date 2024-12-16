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
    @EnvironmentObject var navigation: Navigation
    @Environment(\.modelContext) private var context
    @State private var isPresentingScanner = false
    @State private var scannedCode: String?
    @State private var animateGradient = true
    @State var bean : Beans = .init(name: "", roaster: "", roast: .medium, roastedOn: Date(), preground: false, advanced: advancedBeans)
    @State var showAdvanced : Bool = false
    @State var loading : Bool = false

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
                Section {
                    Picker("Roast", selection: $bean.roast) {
                        ForEach(Roast.allCases, id: \.self) { roast in
                            Text(roast.rawValue.capitalized) // Display raw value, assuming rawValue is a String
                        }
                    }
                    .pickerStyle(.wheel)
                    Toggle("Preground", isOn:$bean.preground)
                    if showAdvanced {
                        Picker("Varietal", selection: $bean.advanced.varietal) {
                            ForEach(Varietal.allCases, id: \.self) { varietal in
                                Text(varietal.rawValue.capitalized) // Display raw value, assuming rawValue is a String
                            }
                        }.pickerStyle(.segmented)
                        TextField("Origin", text: $bean.advanced.origin)
                        Picker("Processing Method", selection: $bean.advanced.process) {
                            ForEach(Process.allCases, id: \.self) { process in
                                Text(process.rawValue.capitalized) // Display raw value, assuming rawValue is a String
                            }
                        }
                        Picker("Altitude", selection: $bean.advanced.altitude) {
                            ForEach(Altitude.allCases, id: \.self) { altitude in
                                Text(altitude.rawValue.capitalized) // Display raw value, assuming rawValue is a String
                            }
                        }
                        ZStack(alignment: .topLeading) {
                                    // Placeholder Text
                            if bean.advanced.notes.isEmpty {
                                        Text("Enter your notes here...")
                                            .foregroundColor(.gray)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 12)
                                    }

                                    // TextEditor
                            TextEditor(text: $bean.advanced.notes)
                                .padding(2)
                                }
                    }

                }footer: {
                    HStack{
                        Spacer()
                        Button{
                            withAnimation(.spring){
                                showAdvanced.toggle()
                            }
                        }label:{
                            HStack{
                                Text("advanced settings").customFont(type: .light, size: .caption).foregroundStyle(.primaryText.opacity(0.7))
                                Image(systemName: showAdvanced ? "chevron.down" : "chevron.up").foregroundStyle(.primaryText.gradient)
                            }
                        }
                        Spacer()
                    }
                }
                .listRowBackground(Color.inverseText.opacity(0.5))
                .listRowBackground(Color.inverseText.opacity(0.5))


                HStack{
                    Spacer()
                    if loading {
                        ProgressView()
                    }else{
                        Button{
                            withAnimation{
                                loading = true
                            }
                            saveCoffeeBean(bean: CoffeeBean(bean: bean)) { result in
                                switch result {
                                case .success(_):
                                    withAnimation{
                                        loading = false
                                        navigation.stack = [.beans]
                                    }
                                case .failure(_):
                                    withAnimation{
                                        loading = false
                                        // show error message
                                    }
                                }
                            }
                        }label: {
                            Text("Save")
                                .customFont(type: .regular, size: .body)
                                .foregroundStyle(.inverseText)
                                .padding(.horizontal, 75)
                                .padding(.vertical, 3)
                                .background(.secondaryForeground)
                                .clipShape(Capsule())
                        }
                    }
                    Spacer()
                }
                .listRowBackground(Color.clear)

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
        .navigationBarTitleDisplayMode(.large)
    }
    
    // Save function that returns Result<Bool, Error>
       private func saveCoffeeBean(bean: CoffeeBean, completion: @escaping (Result<Bool, Error>) -> Void) {
           context.insert(bean)
           do {
               try context.save()
               completion(.success(true)) // Return success
           } catch {
               print("Error saving: \(error)") // Print the error
               completion(.failure(error)) // Return failure with the error
           }
       }
    
}

#Preview {
    NavigationView{
        AddBeansView()
    }
}

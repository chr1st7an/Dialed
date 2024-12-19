//
//  BeanView.swift
//  Dialed
//
//  Created by Christian Rodriguez on 12/2/24.
//

import SwiftUI
import SwiftData

struct BeanView: View {
    @EnvironmentObject var navigation: Navigation
    @Environment(\.modelContext) private var context
    
    var bean: CoffeeBean
    @Binding var showDetails: Bool
    @State private var animateGradient = true
    @State var showHistory = false
    @State var latestRecipe : EspressoShot?

    var body: some View {
        ZStack {
            VStack {
                List{
                   
                    Section{
                        Text(bean.roast).customFont(type: .bold, size: .caption).foregroundStyle(.secondaryForeground) + Text(" roasted by ").customFont(type: .regular, size: .caption).foregroundStyle(.primaryText) + Text(bean.roaster).customFont(type: .bold, size: .caption).foregroundStyle(.secondaryForeground) + Text(" on ").customFont(type: .regular, size: .caption).foregroundStyle(.primaryText) + Text(formatDate(bean.roastedOn)).customFont(type: .bold, size: .caption).foregroundStyle(.secondaryForeground)
                        Text("From ").customFont(type: .regular, size: .caption).foregroundStyle(.primaryText) + Text(bean.origin).customFont(type: .bold, size: .caption).foregroundStyle(.secondaryForeground) + Text(", this ").customFont(type: .regular, size: .caption).foregroundStyle(.primaryText) + Text(bean.varietal.lowercased()).customFont(type: .bold, size: .caption).foregroundStyle(.secondaryForeground) + Text(" bean is grown at ").customFont(type: .regular, size: .caption).foregroundStyle(.primaryText) + Text(bean.altitude.lowercased()).customFont(type: .bold, size: .caption).foregroundStyle(.secondaryForeground) + Text(" altitudes and ").customFont(type: .regular, size: .caption).foregroundStyle(.primaryText) + Text(bean.process.lowercased()).customFont(type: .bold, size: .caption).foregroundStyle(.secondaryForeground) + Text(" processed ").customFont(type: .regular, size: .caption).foregroundStyle(.primaryText)

                    }header:{
                        HStack{
                            Text("Details").customFont(type: .regular, size: .caption)
                            Spacer()
                        }
                    }.listRowBackground(Color.inverseText.opacity(0.5))
                    if bean.shotHistory == nil {
                        Text("No shots recorded yet.")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                            if let history = bean.shotHistory {
                                if let latest = self.latestRecipe {
                                    Section{
                                        HStack(alignment:.center, spacing: 22){
                                            Spacer()
                                            VStack(alignment:.center){
                                                Image("beans")
                                                    .resizable()
                                                    .frame(width: 33, height: 33)
                                                Text("\(String(format: "%.1f", latest.dose)) g")
                                                    .customFont(type: .regular, size: .caption)
                                            }
                                            Image(systemName: "arrowshape.right.fill").foregroundStyle(.secondaryForeground.gradient)
                                            VStack(alignment:.center){
                                                Image(systemName: "timer")
                                                    .resizable()
                                                    .frame(width: 33, height: 33)
                                                    .foregroundStyle(.primaryText)
                                                Text("\(String(format: "%.1f", latest.extractionTime)) s")
                                                    .customFont(type: .regular, size: .caption)
                                            }
                                            Image(systemName: "arrowshape.right.fill").foregroundStyle(.secondaryForeground.gradient)

                                            VStack(alignment:.center){
                                                Image(systemName: "cup.and.heat.waves.fill")
                                                    .resizable()
                                                    .frame(width: 33, height: 33)
                                                    .foregroundStyle(.primaryText)
                                                Text("\(String(format: "%.1f", latest.yield)) g")
                                                    .customFont(type: .regular, size: .caption)
                                            }
                                            Spacer()
                                        }.multilineTextAlignment(.center)
                                    }header:{
                                        HStack{
                                            Text("Recipe").customFont(type: .regular, size: .caption)
                                            Spacer()
                                        }
                                    }footer:{
                                        HStack{
                                            Text("as of  ".lowercased()).customFont(type: .light, size: .small) + Text(formatDateNumber(date: latest.pulledOn)).customFont(type: .regular, size: .small)
                                            Spacer()
                                        }
                                    }
                                    .listRowBackground(Color.inverseText.opacity(0.5))
                                }
                                Section {
                                    
                                    if showHistory {
                                        ForEach(history, id:\.self){ shot in
                                            
                                            VStack(alignment:.leading){
                                                HStack{
                                                    Text("\(formatDate(shot.pulledOn))")
                                                        .customFont(type: .regular, size: .small)

                                                    Spacer()
                                                    Text("Dialed: \(shot.dialed ? "Yes" : "No")")
                                                        .customFont(type: .regular, size: .small)
                                                        .foregroundColor(shot.dialed ? .green : .red)
                                                }
                                                HStack(alignment:.center, spacing: 22){
                                                    Spacer()
                                                    VStack(alignment:.center){
                                                        Image("beans")
                                                            .resizable()
                                                            .frame(width: 25, height: 25)
                                                        Text("\(String(format: "%.1f", shot.dose)) g")
                                                            .customFont(type: .regular, size: .small)
                                                    }
                                                    Image(systemName: "arrowshape.right.fill").foregroundStyle(.secondaryForeground.gradient)
                                                    VStack(alignment:.center){
                                                        Image(systemName: "timer")
                                                            .resizable()
                                                            .frame(width: 25, height: 25)
                                                            .foregroundStyle(.primaryText)
                                                        Text("\(String(format: "%.1f", shot.extractionTime)) s")
                                                            .customFont(type: .regular, size: .small)
                                                    }
                                                    Image(systemName: "arrowshape.right.fill").foregroundStyle(.secondaryForeground.gradient)

                                                    VStack(alignment:.center){
                                                        Image(systemName: "cup.and.heat.waves.fill")
                                                            .resizable()
                                                            .frame(width: 25, height: 25)
                                                            .foregroundStyle(.primaryText)
                                                        Text("\(String(format: "%.1f", shot.yield)) g")
                                                            .customFont(type: .regular, size: .small)
                                                    }
                                                    Spacer()
                                                }.multilineTextAlignment(.center)
                                            }
                                        }.transition(.asymmetric(insertion: .move(edge: .top), removal: .move(edge: .bottom)))
                                    }
                                } header: {
                                    HStack{
                                        Text("Shot History (\(bean.shotHistory!.count))").customFont(type: .regular, size: .caption)
                                        Spacer()
                                        Button{
                                            withAnimation{
                                                showHistory.toggle()
                                            }
                                        }label:{
                                            Image(systemName: showHistory ? "chevron.up" : "chevron.down").contentTransition(.symbolEffect(.automatic))
                                        }
                                    }
                                }
                                .listRowBackground(Color.inverseText.opacity(0.5))
                                if !bean.notes.isEmpty{
                                    Section{
                                        Text(bean.notes).customFont(type: .regular, size: .caption)
                                    }header:{
                                        HStack{
                                            Text("Notes").customFont(type: .regular, size: .caption)
                                            Spacer()
                                        }
                                    }.listRowBackground(Color.inverseText.opacity(0.5))
                                }
                            }
                            

                        
                        
                    }
                }
            .foregroundStyle(.primaryText)
            .tint(.primaryBackground)
            .scrollContentBackground(.hidden)
//            .listRowSpacing(10)
            .listSectionSpacing(10)
            }
            .onAppear {
                if let history = bean.shotHistory{
                    if let mostRecentDialedShot = history
                        .filter({ $0.dialed })
                        .sorted(by: { $0.pulledOn > $1.pulledOn })
                        .first {
                        self.latestRecipe = mostRecentDialedShot
                    }
                }
                
            }
        }
        .navigationTitle(bean.name)
        .navigationBarBackButtonHidden(true)
    }
}



#Preview {
    ContentView()
}


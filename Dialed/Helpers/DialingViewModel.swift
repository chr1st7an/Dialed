//
//  DialingViewModel.swift
//  Dialed
//
//  Created by Christian Rodriguez on 12/5/24.
//

import Foundation
import SwiftUI

class DialingViewModel: ObservableObject {
    @Published var step: DialingStep = .dose
    @Published var currentShot : Shot = .init(dose: 0, yield: 0, extractionTime: 0, metric: "", tastingNotes: .init(acidity: 0.5, bitterness: 0.5, crema: 0.5, satisfaction: 0.5), grind: .init(grinderId: "", notes: ""), pulledOn: Date(), dialed: false)
    @Published var shots : [Shot] = []
    
    @Published var latestSuggestion: String = ""
    private var dialAI : DialAI = .init()
    
    func analyzeLastShot(beans: Beans) {
        dialAI.fetchAISuggestions(shots: self.shots, bean: beans) { suggestion in
            print(suggestion)
            withAnimation{
                self.latestSuggestion = suggestion
            }
        }
    }
}



enum DialingStep : Hashable {
    case dose
    case grind
    case extraction
    case yield
    case tastingNotes
    case assessment
}

//
//  Objects.swift
//  Dialed
//
//  Created by Christian Rodriguez on 12/3/24.
//

import SwiftUI
import Foundation

/// Sample Bean Model
struct Beans: Identifiable {
    var id = UUID().uuidString
    var name: String
    var roaster: String
    var roastedOn: Date
}

var testBeans : Beans = .init(name: "Speed Dial", roaster: "Brooklyn Coffee Company", roastedOn: Date())

struct EspressoShot: Identifiable {
    var id = UUID().uuidString
    var dose: Double
    var yield: Double
    var time: Double
    var metric : String
    var TastingNotes : [String]
    var beans : Beans
}

var espressoShotShell = EspressoShot(dose: 0, yield: 0, time: 0, metric: "grams", TastingNotes: [], beans: testBeans)

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
    var preground: Bool
}
var testBeans : Beans = .init(name: "Speed Dial", roaster: "Brooklyn Coffee Company", roastedOn: Date(), preground: false)

struct EspressoShot: Identifiable {
    var id = UUID().uuidString
    var dose: Double
    var yield: Double
    var extractionTime: Double
    var metric : String
    var tastingNotes : TastingNotes
    var beans : Beans
    var grind: GrindSetting
}
var espressoShotShell = EspressoShot(dose: 0, yield: 0, extractionTime: 0, metric: "grams", tastingNotes: tastingNotesShell, beans: testBeans, grind: grindSettingShell)

struct TastingNotes {
    var acidity: Double
    var bitterness: Double
    var crema: Double
    var satisfaction: Double
}
var tastingNotesShell = TastingNotes(acidity: 0.5, bitterness: 0.5, crema: 0.5, satisfaction: 0.5)

struct Grinder: Identifiable {
    var id = UUID().uuidString
    var name : String
    var type: GrindType
    var sizeAdjustment: SizeAdjustment
    var burrType: BurrType
}
var grinderTest = Grinder(name: "Fellow Opus", type: .automatic, sizeAdjustment: .stepped, burrType: .conical)
struct GrindSetting: Identifiable {
    var id = UUID().uuidString
    var grinder : Grinder
    var notes: String
}
var grindSettingShell = GrindSetting(grinder: .init(name: "", type: .automatic, sizeAdjustment: .stepped, burrType: .conical), notes: "")

enum GrindType: String {
    case hand = "Hand"
    case automatic = "Automatic"
}
enum SizeAdjustment: String {
    case stepless = "Stepless"
    case stepped = "Stepped"
}
enum BurrType: String {
    case flat = "Flat"
    case conical = "Conical"
}

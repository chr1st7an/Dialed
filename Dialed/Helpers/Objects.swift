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
    var roast: Roast
    var roastedOn: Date
    var preground: Bool
    var advanced: BeansAdvanced
}
struct BeansAdvanced{
    var origin: String
    var process: Process
    var altitude: Altitude
    var varietal: Varietal
    var notes: String
}
var testBeans : Beans = .init(name: "Speed Dial", roaster: "Brooklyn Coffee Company", roast: .medium, roastedOn: Date(), preground: false, advanced: advancedBeans)
var advancedBeans : BeansAdvanced = .init(origin: "", process: .natural, altitude: .low, varietal: .arabica, notes: "")

enum Roast: String, CaseIterable{
    case light = "Light"
    case medium = "Medium"
    case dark = "Dark"
}
enum Process: String, CaseIterable{
    case washed = "Washed (Wet)"
    case natural = "Natural (Dry)"
    case honey = "Honey"
}
enum Altitude: String, CaseIterable{
    case high = "High (Above 1200m)"
    case low = "Low (Below 800m)"
}
enum Varietal: String, CaseIterable{
    case arabica = "Arabica"
    case robusta = "Robusta"
    case liberica = "Liberica"
}

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

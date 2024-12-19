//
//  Objects.swift
//  Dialed
//
//  Created by Christian Rodriguez on 12/3/24.
//

import SwiftUI
import Foundation
import SwiftData

struct Beans: Identifiable {
    var id = UUID().uuidString
    var name: String
    var roaster: String
    var roast: Roast
    var roastedOn: Date
    var preground: Bool
    var advanced: BeansAdvanced
    var shotHistory: [Shot]
    var lastUpdated: Date
}

struct BeansAdvanced{
    var origin: String
    var process: Process
    var altitude: Altitude
    var varietal: Varietal
    var notes: String
}

var testBeans : Beans = .init(name: "", roaster: "", roast: .medium, roastedOn: Date(), preground: false, advanced: advancedBeans, shotHistory: [], lastUpdated: Date())
var advancedBeans : BeansAdvanced = .init(origin: "", process: .natural, altitude: .low, varietal: .arabica, notes: "")

@Model
class CoffeeBean: Identifiable {
    @Attribute var id: UUID = UUID()
    @Attribute var name: String = ""
    @Attribute var roaster: String = ""
    @Attribute var roast: String = Roast.light.rawValue
    @Attribute var roastedOn: Date = Date()
    @Attribute var preground: Bool = false
    @Relationship var shotHistory: [EspressoShot]? = nil  // Optional relationship
    
    @Attribute var origin: String = ""
    @Attribute var process: String = Process.washed.rawValue
    @Attribute var altitude: String = Altitude.high.rawValue
    @Attribute var varietal: String = Varietal.arabica.rawValue
    @Attribute var notes: String = ""
    @Attribute var lastUpdated: Date = Date()
    
    init(bean: Beans) {
        self.id = UUID(uuidString: bean.id) ?? UUID()
        self.name = bean.name
        self.roaster = bean.roaster
        self.roast = bean.roast.rawValue
        self.roastedOn = bean.roastedOn
        self.preground = bean.preground
        
        // Map Shot structs to EspressoShot objects
        self.shotHistory = bean.shotHistory.map { EspressoShot(shot: $0) }
        
        self.origin = bean.advanced.origin
        self.process = bean.advanced.process.rawValue
        self.altitude = bean.advanced.altitude.rawValue
        self.varietal = bean.advanced.varietal.rawValue
        self.notes = bean.advanced.notes
        self.lastUpdated = Date()
    }
    
    func toBeans() -> Beans {
        let advanced = BeansAdvanced(
            origin: self.origin,
            process: Process(rawValue: self.process) ?? .washed,
            altitude: Altitude(rawValue: self.altitude) ?? .high,
            varietal: Varietal(rawValue: self.varietal) ?? .arabica,
            notes: self.notes
        )
        
        // Map EspressoShot objects back to Shot structs
        let shotHistory = self.shotHistory?.map { shot in
            Shot(
                id: shot.id.uuidString,
                dose: shot.dose,
                yield: shot.yield,
                extractionTime: shot.extractionTime,
                metric: shot.metric,
                tastingNotes: TastingNotes(
                    acidity: shot.acidity,
                    bitterness: shot.bitterness,
                    crema: shot.crema,
                    satisfaction: shot.satisfaction
                ),
                grind: GrindSetting(
                    grinderId: shot.grinderId,
                    notes: shot.grindNotes
                ),
                pulledOn: shot.pulledOn,
                dialed: shot.dialed
            )
        } ?? []
        
        return Beans(
            id: self.id.uuidString,
            name: self.name,
            roaster: self.roaster,
            roast: Roast(rawValue: self.roast) ?? .light,
            roastedOn: self.roastedOn,
            preground: self.preground,
            advanced: advanced,
            shotHistory: shotHistory, lastUpdated: self.lastUpdated
        )
    }
}





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

@Model
class EspressoShot: Identifiable {
    @Attribute var id: UUID = UUID()
    @Attribute var dose: Double = 0
    @Attribute var yield: Double = 0
    @Attribute var extractionTime: Double = 0
    @Attribute var metric: String = "grams"
    @Attribute var pulledOn: Date = Date()
    @Attribute var dialed: Bool = false

    @Attribute var acidity: Double = 0.5
    @Attribute var bitterness: Double = 0.5
    @Attribute var crema: Double = 0.5
    @Attribute var satisfaction: Double = 0.5

    @Attribute var grinderId: String = ""
    @Attribute var grindNotes: String = ""

    @Relationship(inverse: \CoffeeBean.shotHistory) var parentBean: CoffeeBean?  // Inverse relationship
    
    init(shot: Shot) {
        self.id = UUID(uuidString: shot.id) ?? UUID()
        self.dose = shot.dose
        self.yield = shot.yield
        self.extractionTime = shot.extractionTime
        self.metric = shot.metric
        self.pulledOn = shot.pulledOn
        self.dialed = shot.dialed

        // Populate tasting notes
        self.acidity = shot.tastingNotes.acidity
        self.bitterness = shot.tastingNotes.bitterness
        self.crema = shot.tastingNotes.crema
        self.satisfaction = shot.tastingNotes.satisfaction

        // Populate grinder settings
        self.grinderId = shot.grind.grinderId
        self.grindNotes = shot.grind.notes
    }
}


struct Shot: Identifiable {
    var id = UUID().uuidString
    var dose: Double
    var yield: Double
    var extractionTime: Double
    var metric : String
    var tastingNotes : TastingNotes
    var grind: GrindSetting
    var pulledOn: Date
    var dialed: Bool
}
var espressoShotShell = Shot(dose: 0, yield: 0, extractionTime: 0, metric: "grams", tastingNotes: tastingNotesShell, grind: grindSettingShell,pulledOn: Date(), dialed: false)

struct TastingNotes {
    var acidity: Double
    var bitterness: Double
    var crema: Double
    var satisfaction: Double
}
var tastingNotesShell = TastingNotes(acidity: 0.5, bitterness: 0.5, crema: 0.5, satisfaction: 0.5)

@Model
class Grinder: Identifiable {
    @Attribute var id: UUID = UUID()
    @Attribute var name: String = ""
    @Attribute var type: String = GrindType.automatic.rawValue
    @Attribute var sizeAdjustment: String = SizeAdjustment.stepped.rawValue
    @Attribute var burrType: String = BurrType.conical.rawValue
    
    init(
        id: UUID = UUID(),
        name: String,
        type: String,
        sizeAdjustment: String,
        burrType: String
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.sizeAdjustment = sizeAdjustment
        self.burrType = burrType
    }
}

var grinderTest = Grinder(name: "Fellow Opus", type: GrindType.automatic.rawValue, sizeAdjustment: SizeAdjustment.stepless.rawValue, burrType: BurrType.conical.rawValue)

struct GrindSetting {
    var grinderId : String
    var notes: String
}
var grindSettingShell = GrindSetting(grinderId: "", notes: "")

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

//
//  Objects.swift
//  Dialed
//
//  Created by Christian Rodriguez on 12/3/24.
//

import SwiftUI
import Foundation

/// Sample Profile Model
struct Beans: Identifiable {
    var id = UUID().uuidString
    var name: String
    var roaster: String
    var roastedOn: Date
}

var testBeans : Beans = .init(name: "Speed Dial", roaster: "Brooklyn Coffee Company", roastedOn: Date())

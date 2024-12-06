//
//  Navigation.swift
//  Dialed
//
//  Created by Christian Rodriguez on 12/2/24.
//

import Foundation
import SwiftUI

class Navigation: ObservableObject {
    @Published var stack: [Destination] = []
}



enum Destination : Hashable {
    case profile
    case beans
    case dialing
    
}

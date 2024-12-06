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
    @Published var currentShot : EspressoShot = espressoShotShell
    @Published var shots : [EspressoShot] = []
}



enum DialingStep : Hashable {
    case dose
    case time
    case yield
    case tastingNotes
}

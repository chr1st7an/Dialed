//
//  DialedApp.swift
//  Dialed
//
//  Created by Christian Rodriguez on 11/20/24.
//

import SwiftUI
import SwiftData

@main
struct DialedApp: App {
    var body: some Scene {
        WindowGroup {
                ContentView()
                .modelContainer(for: [CoffeeBean.self])
            
        }
    }
}

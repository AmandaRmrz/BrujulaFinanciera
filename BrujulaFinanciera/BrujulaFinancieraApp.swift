//
//  BrujulaFinancieraApp.swift
//  BrujulaFinanciera
//
//  Created by Andrea Amanda Ramirez Diaz on 8/11/26.
//

import SwiftUI
import TipKit

@main
struct BrujulaFinancieraApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    // Inicialización de TipKit
                    try? Tips.configure([
                        .displayFrequency(.immediate),
                        .datastoreLocation(.applicationDefault)
                    ])
                }
        }
    }
}

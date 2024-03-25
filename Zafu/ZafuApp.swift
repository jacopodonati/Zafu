//
//  ZafuApp.swift
//  Zafu
//
//  Created by Jacopo Donati on 17/02/24.
//

import SwiftUI
import SwiftData

@main
struct ZafuApp: App {
    @EnvironmentObject var timerData: TimerData
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView(timerData: TimerData())
        }
        .modelContainer(sharedModelContainer)
    }
}

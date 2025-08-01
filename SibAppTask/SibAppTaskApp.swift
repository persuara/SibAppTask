//
//  SibAppTaskApp.swift
//  SibAppTask
//
//  Created by AmirHossein EramAbadi on 8/1/25.
//

import SwiftUI
import DataLayer
import Logic
import SwiftData

@main
struct SibAppTaskApp: App {
    var sharedModelContainer: ModelContainer = {
        
        do {
            return try ContainerFactory.build()
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView(vm:
                            WordCardViewModel.init(
                                container: sharedModelContainer,
                                incrementaionPoint: 10
                            )
            )
        }
        .modelContainer(sharedModelContainer)
    }
}

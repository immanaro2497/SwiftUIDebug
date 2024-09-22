//
//  SwiftUIDebugApp.swift
//  SwiftUIDebug
//
//  Created by Immanuel on 07/05/24.
//

import SwiftUI
import TipKit

@main
struct SwiftUIDebugApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            NavigationStackMainView()
        }
    }
    
    init() {
        do {
            try setupTips()
        } catch {
            print("Error initializing tips: \(error)")
        }
    }
    
    private func setupTips() throws {
        // Show all defined tips in the app.
        // Tips.showAllTipsForTesting()

        // Show some tips, but not all.
        // Tips.showTipsForTesting([tip1, tip2, tip3])

        // Hide all tips defined in the app.
        // Tips.hideAllTipsForTesting()

        // Purge all TipKit-related data.
        try Tips.resetDatastore()

        // Configure and load all tips in the app.
        try Tips.configure()
    }
}

struct MyScene: Scene {
    
    @State private var appNotes: String = ""
    @Environment(\.scenePhase) private var scenePhase
    let money = Money(value: 1, notes: "")
    
    var body: some Scene {
        WindowGroup {
            MultiWindowView(money: money, appNotes: $appNotes)
        }
        .onChange(of: scenePhase) { oldValue, newValue in
            print("\(oldValue) - \(newValue)")
        }
        WindowGroup("Multi-one", id: "multi-window-one", for: Int.self) { $num in
            MultiWindowView(money: money, appNotes: $appNotes)
//            CounterViewWithHang(counterViewModel: CounterViewModel())
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .defaultSize(width: 800, height: 500)
        WindowGroup("Multi-two", id: "multi-window-two", for: Int.self) { $num in
            MultiWindowView(money: money, appNotes: $appNotes)
        }
    }
    
}

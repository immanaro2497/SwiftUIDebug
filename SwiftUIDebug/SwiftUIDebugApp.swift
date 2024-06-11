//
//  SwiftUIDebugApp.swift
//  SwiftUIDebug
//
//  Created by Immanuel on 07/05/24.
//

import SwiftUI

@main
struct SwiftUIDebugApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            DetailView()
        }
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

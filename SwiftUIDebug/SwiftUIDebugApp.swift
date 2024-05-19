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
            MusicDetailView()
//            CounterViewWithHang(counterViewModel: CounterViewModel())
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

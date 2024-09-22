//
//  PresentedView.swift
//  SwiftUIDebug
//
//  Created by Immanuel on 19/09/24.
//

import SwiftUI

struct PresentedView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.close) var close
    
    @State var isPushed = false
    
    let title: String
    
    var body: some View {
        VStack {
            Text(title)
            Button("Push") {
                isPushed = true
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            Button(title) {
                dismiss()
                close()
            }
            .tint(.pink)
        }
        .navigationDestination(isPresented: $isPushed) {
            Text("Pushed view")
        }
    }
}

final class NavRouter: ObservableObject {
    
    public enum Destination: Codable, Hashable {
        case TextView
    }
    
    @Published var navPath = NavigationPath()
    
//    init() {
//        navPath.append(Destination.login)
//        navPath.append(Destination.dashboardView)
//    }
    
    func navigate(to destination: Destination) {
        navPath.append(destination)
    }
    
    func navigateBack() {
        navPath.removeLast()
    }
    
    func navigateToRoot() {
        navPath.removeLast(navPath.count)
    }
}

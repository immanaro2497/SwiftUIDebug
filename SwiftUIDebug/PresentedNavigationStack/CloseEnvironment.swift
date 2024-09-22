//
//  CloseEnvironment.swift
//  SwiftUIDebug
//
//  Created by Immanuel on 19/09/24.
//

import SwiftUI

enum CloseEnvironmentKey: EnvironmentKey {
    static let defaultValue: CloseAction = CloseAction(isPresented: Binding(get: { false }, set: { _ in }))
}

public extension EnvironmentValues {
    var close: CloseAction {
        get { self[CloseEnvironmentKey.self] }
        set { self[CloseEnvironmentKey.self] = newValue }
    }
}

public struct CloseAction {
    @Binding var isPresented: Bool
    
    init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
    
    public func callAsFunction() {
        isPresented = false
    }
}

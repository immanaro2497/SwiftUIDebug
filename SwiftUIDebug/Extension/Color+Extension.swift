//
//  Color+Extension.swift
//  SwiftUIDebug
//
//  Created by Immanuel on 15/05/24.
//

import Foundation
import SwiftUI

extension Color {
    
    static func random(opacity: Double = 0.4) -> Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            opacity: opacity
        )
    }
    
}

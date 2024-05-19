//
//  DebugHelperViews.swift
//  SwiftUIDebug
//
//  Created by Immanuel on 15/05/24.
//

import Foundation
import SwiftUI

extension AnyTransition {
    
    static var customTransition: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .opacity,
            removal: .scale.combined(with: .move(edge: .top)).combined(with: .opacity)
        )
    }
    
}

struct TestAnimateViewAppear: ViewModifier {
    
    @State private var isVisible = false
    let width: CGFloat = 5
    
    func body(content: Content) -> some View {
        content
            .overlay(content: {
                Rectangle()
                    .stroke(lineWidth: width)
                    .phaseAnimator([Color.clear, Color.black, Color.white, Color.black], trigger: isVisible) { view, phase in
                        view.foregroundStyle(phase)
                    } animation: { _ in
                            .easeInOut.speed(2)
                    }
            })
            .onAppear {
                isVisible.toggle()
            }
    }
    
}

struct DebugViewChange: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .background(Color.random())
    }
    
}

struct DebugSize: ViewModifier {
    
    func body(content: Content) -> some View {
        content.overlay {
            GeometryReader { geometry in
                ZStack(alignment: .bottom) {
                    Rectangle()
                        .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [5]))
                        .foregroundStyle(.black)
                    Text("\(geometry.size.width) - \(geometry.size.height)")
                        .foregroundStyle(.black)
                        .font(.caption2)
                }
            }
        }
    }
    
}

extension View {
    
//    func debugViewChange() -> some View {
//        modifier(DebugViewChange())
//    }
    
    func debugViewChange() -> some View {
        background(Color.random())
    }
    
    func debugSize() -> some View {
        modifier(DebugSize())
    }
    
}

//
//  RainAnimationView.swift
//  SwiftUIDebug
//
//  Created by Immanuel on 12/10/24.
//

import SwiftUI

struct RainAnimationView: View {
    var rows = 17
    @State var textContent = Array("bokwormbokwormbokwormbokwormbokwormbokwormbokwormbokwormbokwormbokwormbokwormbokwormbokwormbokwormbokwormbokwormbokwormbokwormbokwormbokwormbokwormbokwormbokwormbokworm").map({ String($0) }).shuffled()
    var randomAnimationDuration = 15.0...20.5
    @State var animateRain: Bool = false
    
    func shuffleTextContent() {
        textContent.shuffle()
    }
    
    let animation = Animation.easeIn(duration: Double.random(in: 15.0...20.5)).repeatForever(autoreverses: false)
    
    @Binding var shareVar: Bool {
        didSet {
            withAnimation(.easeIn(duration: Double.random(in: randomAnimationDuration)).repeatForever(autoreverses: false)) {
                animateRain = true }
        }
    }
    
    @State private var opacity: Double = 0.0
    
    var body: some View {
        GeometryReader { geometry in
            HStack() {
                RainColumnsView(rows: rows, geometry: geometry, textContent: $textContent, animateRain: $animateRain)
            }
            .frame(width: geometry.size.width, height: geometry.size.height + 200)
            .clipped()
            .onAppear() { DispatchQueue.main.async { withAnimation(animation) {
                animateRain = false
                withAnimation(animation) {
                    animateRain = true
                }
            }}}
            .ignoresSafeArea(edges: .top)
        }
    }
}

struct RainColumnsView: View {
    let rows: Int
    let geometry: GeometryProxy
    @Binding var textContent: [String]
    @Binding var animateRain: Bool
    
    var body: some View {
        //                Spacer()
            ForEach(0..<rows, id: \.self) { _ in
                RainColumnView(geometry: geometry, textContent: $textContent, animateRain: $animateRain)
            }
    }
}

struct RainColumnView: View {
    let geometry: GeometryProxy
    @Binding var textContent: [String]
    @Binding var animateRain: Bool
    
    var randomAnimationDuration = 15.0...20.5
    
    var body: some View {
        VStack {
            //                        Spacer()
            ForEach(0..<textContent.count, id: \.self) { index in
                RainTextView(text: textContent[index])
            }
        }
        .opacity(animateRain ? 1.0 : 0.0)
        .offset(y: -geometry.size.height - 100)
        .offset(x: 0, y: animateRain ? 2*geometry.size.height : -geometry.size.height)
        .animation(Animation.easeInOut(duration: Double.random(in: randomAnimationDuration)).speed(2).repeatForever(autoreverses: true), value: animateRain)
        .rotation3DEffect(animateRain ? .degrees(49) : .degrees(1), axis: (x: 0, y: 1, z: 0))
        
    }
}

struct RainTextView: View {
    
    let text: String
    
    var body: some View {
        Text(text)
            .foregroundColor(Color.brown)
            .font(.custom("AmericanTypewriter", size: 17))
        //                            Spacer()
    }
    
}

#Preview {
    RainAnimationView(shareVar: .constant(true))
}

struct RainAnimationViewOptimized: View {
    let colWidth: CGFloat = 23
    let randomAnimationDuration = 15.0...20.5
    let textContent = Array( "bokwormbokwormbokwormbokwormbokwormbokwormbokwormbokwormbokwormbokwormbokwormbokwormbokwormbokwormbokwormbokwormbokwormbokwormbokwormbokwormbokwormbokwormbokwormbokworm")
        .map({ String($0) })
        .shuffled()
        .joined(separator: "\n")
    @State private var animateRain: Bool = false

    var body: some View {
        GeometryReader { geometry in
            let nCols = Int(geometry.size.width / colWidth)
            HStack(alignment: .top, spacing: 0) {
                ForEach(0..<nCols, id: \.self) { _ in
                    Text(textContent)
                        .frame(width: colWidth)
                        .offset(y: animateRain ? 0 : -2 * geometry.size.height)
                        .rotation3DEffect(animateRain ? .degrees(49) : .degrees(1), axis: (x: 0, y: 1, z: 0))
                        .opacity(animateRain ? 1.0 : 0.0)
                        .animation(
                            .easeInOut(duration: Double.random(in: randomAnimationDuration))
                            .repeatForever(autoreverses: true),
                            value: animateRain
                        )
                }
            }
            .fixedSize()
            .foregroundStyle(.brown)
            .font(.custom("AmericanTypewriter", size: 17))
            .lineSpacing(10)
            .onAppear { animateRain = true }
            .ignoresSafeArea(edges: .top)
        }
    }
}

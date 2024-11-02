//
//  ContentCircleView.swift
//  SwiftUIDebug
//
//  Created by Immanuel on 12/10/24.
//

import SwiftUI

struct ContentCircleView: View {
    @ObservedObject var someTimer = SomeTimer()
    
    var body: some View {
        AnimatedCircle(circleProgress: $someTimer.circleProgess, size: 100)
        AnimatedCircle(circleProgress: $someTimer.circleProgess, size: 400)
        
        Spacer()
        
        Button(action: someTimer.start, label: {
            Text("Start animation")
        })
        
        Spacer()
    }
}


class SomeTimer : ObservableObject {
    @Published var circleProgess = 1.0
    
    func start() {
        circleProgess = 1.0
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) {_ in
            self.circleProgess -= 0.001
        }
    }
}

struct AnimatedCircle: View {
    @Binding var circleProgress : Double
    var size : Int
    
    var body: some View {
//        Circle()
//            .trim(from: 0.0, to: CGFloat(circleProgress))
//            .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
//            .fill(Color.pink.gradient)
//            //.fill(Color.pink)
//            .rotationEffect(Angle(degrees: 270.0))
//            .animation(.default, value: CGFloat(circleProgress))
//            .frame(width: CGFloat(size), height: CGFloat(size))
        // MARK: This reduces CPU usage
        Circle()
            .fill(Color.pink.gradient)
            .frame(width: CGFloat(size), height: CGFloat(size))
            .mask {
                Circle()
                    .inset(by: 10) // half the line width
                    .trim(from: 0.0, to: CGFloat(circleProgress))
                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                    .rotationEffect(Angle(degrees: 270.0))
                    .animation(.default, value: CGFloat(circleProgress))
            }
    }
}

#Preview {
    ContentCircleView()
}

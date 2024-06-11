//
//  MultiWindowView.swift
//  SwiftUIDebug
//
//  Created by Immanuel on 22/05/24.
//

import Foundation
import SwiftUI

class Money: ObservableObject {
    
    @Published var value: Double
    @Published var notes: String
    
    init(value: Double, notes: String) {
        self.value = value
        self.notes = notes
        let classInstanceAddress = MemoryAddress(of: self)
        print("Money init - \(classInstanceAddress)")
    }
    
    deinit {
        let classInstanceAddress = MemoryAddress(of: self)
        print("Money deinit - \(classInstanceAddress)")
    }
    
}

//struct NavigationWindow: View {
//    
//    @StateObject var money: Money = Money(value: 1, notes: "")
//    
//    var body: some View {
//        NavigationStack {
//            NavigationLink("MultiWindowView") {
//                MultiWindowView(money: money)
//            }
//        }
//    }
//}

struct MultiWindowView: View {
    
    @ObservedObject var money: Money
    @State private var moneyValue: Double = 0
    @Environment(\.openWindow) private var openWindow
    
    @Binding var appNotes: String
    @State private var progress: CGFloat = 0
    let totalTime: CGFloat = 30
//    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    private let numberFormatter: NumberFormatter = {
        var nf = NumberFormatter()
        nf.numberStyle = .decimal
        return nf
    }()
    
    var body: some View {
        Text("Current money value - \(money.value)")
        TextField("Money value", value: $moneyValue, formatter: numberFormatter)
            .keyboardType(.decimalPad)
        Button {
//            print(isNumeric())
            money.value = moneyValue
        } label: {
            Text("Update money value")
        }
        Text("Current Notes - \(money.notes)")
        TextField("Notes", text: $money.notes)
        Text("Current app notes - \(appNotes)")
        TextField("App notes", text: $appNotes)
        
        Button {
            openWindow(id: "multi-window-one", value: 1)
        } label: {
            Text("Open new window one")
        }
        
        Button {
            openWindow(id: "multi-window-two", value: 2)
        } label: {
            Text("Open new window two")
        }
        
        ZStack{
            Circle()
                .stroke(lineWidth: 20)
                .foregroundStyle(.yellow)
            Circle()
                .trim(from: 0.0, to: CGFloat(progress / totalTime))
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .butt, lineJoin: .bevel, miterLimit: .zero, dash: [20, 5], dashPhase: 0))
                .rotationEffect(.degrees(-90))
                .foregroundStyle(.cyan)
            Text(progress, format: .number)
//                .onReceive(timer, perform: { _ in
//                    print(CGFloat(progress / totalTime), progress)
//                    if progress > (totalTime - 1) {
//                        progress = 0
//                        withAnimation(.linear(duration: 1)) {
//                            progress += 1
//                        }
//                    } else {
//                        withAnimation(.linear(duration: 1)) {
//                            progress += 1
//                        }
//                    }
//                })
//                .onReceive(timer, perform: { value in
//                    if time > 0 {
//                        withAnimation(.linear(duration: 1)) {
//                            time -= 1
//                            progress = CGFloat(CGFloat(num - time) / CGFloat(num))
//                        }
//                    } else {
//                        time = num
//                        progress = 0.0
//                    }
//                })
        }
        .frame(width: 200, height: 200)
            
    }
    
//    func isNumeric() -> Bool {
//        let numericCheck = NSPredicate(format: "SELF MATCHES %@", "^[0-9]{2}$")
//        print(moneyValue)
//        if numericCheck.evaluate(with: moneyValue) {
//            return true
//        } else {
//            return false
//        }
//    }
    
}

#Preview {
    MultiWindowView(money: Money(value: 1, notes: ""), appNotes: .constant(""))
}

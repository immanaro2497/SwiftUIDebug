//
//  CounterViewWithHang.swift
//  SwiftUIDebug
//
//  Created by Immanuel on 17/05/24.
//

import SwiftUI

struct CounterViewWithHang: View {
    
    var model: CounterViewModel
    
    init(counterViewModel: CounterViewModel) {
        self.model = counterViewModel
        print(Self.self, #function)
        print(_isPOD(ContentView.self))
        //po print(type(of: body))
    }
    
    var body: some View {
        let _ = Self._printChanges()
        VStack {
            //            Text("Counter: \(model.counter)")
            List {
                ForEach(model.values, id: \.self) {
                    Text(String($0))
                        .padding()
                        .background(Color.random())
                }
            }
            .listStyle(.plain)
            .frame(height: 200.0)
            Text("Counter: \(model.counter)")
            Button {
                model.counter += 1
            } label: {
                Text("Counter +1")
            }
            .buttonStyle(.borderedProminent)
        }
        .background(Color.random())
    }
}

#Preview {
    CounterViewWithHang(counterViewModel: CounterViewModel())
}

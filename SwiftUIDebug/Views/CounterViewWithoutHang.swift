//
//  CounterViewWithoutHang.swift
//  SwiftUIDebug
//
//  Created by Immanuel on 17/05/24.
//

import SwiftUI

@Observable
class CounterViewModel {
    
    var counter: Int = 99 {
        didSet {
            print(counter)
        }
    }
    
    var values: [Int] = Array(1...200000)
    
}

class CounterViewModelOO: ObservableObject {
    
    @Published var counter: Int = 99 {
        didSet {
            print(counter)
        }
    }
    
    var values: [Int] = Array(1...200000)
    
}

struct CounterViewWithoutHang: View {
    
    var model: CounterViewModel
    
    init(counterViewModel: CounterViewModel) {
        self.model = counterViewModel
        print(Self.self, #function)
        print(_isPOD(ContentView.self))
        // po print(type(of: body))
    }
    
    var body: some View {
        let _ = Self._printChanges()
        VStack {
            //            Text("Counter: \(model.counter)")
            ContentListView(values: model.values)
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

struct ContentListView: View, Equatable {
    
    let values: [Int]
    
    init(values: [Int]) {
        self.values = values
        print(Self.self, #function)
        print(_isPOD(ContentListView.self))
    }
    
    var body: some View {
        let _ = Self._printChanges()
        List {
            ForEach(values, id: \.self) {
                Text(String($0))
                    .padding()
                    .background(Color.random())
            }
        }
        .listStyle(.plain)
        .frame(height: 200.0)
        .background(Color.random())
    }
}

#Preview {
    CounterViewWithoutHang(counterViewModel: CounterViewModel())
}

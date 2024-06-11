//
//  DetailView.swift
//  SwiftUIDebug
//
//  Created by Immanuel on 08/05/24.
//

import SwiftUI

struct TestStruct {
    let test: Test
    var name: String
    
    init(test: Test, name: String) {
        self.test = test
        self.name = name
    }
}

struct DetailView: View {
    @State private var text: String = ""
    @Environment(\.dismiss) private var dismiss
    @State private var testStruct = TestStruct(test: Test(name: "one"), name: "one")
    
    var body: some View {
        NavigationStack {
            TextField("Text", text: $testStruct.name)
            MusicDetailView(testStruct: $testStruct)
            NavigationLink("reaction") {
                ReactionView(text: $text)
            }
        }
        .onAppear {
//            let structInstanceAddress = MemoryAddress(of: &testStruct)
//            print(String(format: "%018p", structInstanceAddress.intValue))
//            print(structInstanceAddress)
            withUnsafePointer(to: testStruct) {
                print(String(format: "%p", $0))
            }
            let classInstanceAddress = MemoryAddress(of: testStruct.test)
            print("TestStruct test - \(classInstanceAddress)")
        }
        Button("dismiss") {
            dismiss()
        }
    }
}

extension DetailView: Equatable {
    static func == (lhs: DetailView, rhs: DetailView) -> Bool {
        return true
    }
}

#Preview {
    DetailView()
}

//
//  DetailView.swift
//  SwiftUIDebug
//
//  Created by Immanuel on 08/05/24.
//

import SwiftUI

struct TestStruct {
    let test: Test
}

struct DetailView: View {
    @State private var text: String = ""
    
    var body: some View {
        NavigationStack {
            TextField("Text", text: $text)
            MusicDetailView()
            NavigationLink("reaction") {
                ReactionView(text: $text)
            }
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

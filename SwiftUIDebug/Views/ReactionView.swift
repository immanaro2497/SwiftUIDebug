//
//  ReactionView.swift
//  SwiftUIDebug
//
//  Created by Immanuel on 16/05/24.
//

import SwiftUI

enum Reaction: CaseIterable, Identifiable {
    case like, dislike, love

    var id: Self { self }

    var systemImageName: String {
        switch self {
            case .like: "hand.thumbsup"
            case .dislike: "hand.thumbsdown"
            case .love: "heart"
        }
    }
    var selectedSystemImageName: String {
        systemImageName + ".fill"
    }
}

@Observable
class ViewModel {
    var reaction: Reaction?

    func set(_ newReaction: Reaction) async {
        // Here goes a DB update
        reaction = newReaction == reaction ? nil : newReaction
    }
    
    init() {
        let classInstanceAddress = MemoryAddress(of: self)
        print("reaction init \(reaction) - \(classInstanceAddress)")
    }
    
    deinit {
        let classInstanceAddress = MemoryAddress(of: self)
        print("reaction deinit \(reaction) - \(classInstanceAddress)")
    }
}

struct ReactionView: View {
    @State private var viewModel: ViewModel = ViewModel()
    @Binding var text: String

        var body: some View {
            VStack {
                TextField("text", text: $text)
                    .background(Color.random())
                HStack(spacing: 40) {
                    ForEach(Reaction.allCases) { reaction in
                        Image(systemName: viewModel.reaction != reaction ? reaction.selectedSystemImageName : reaction.systemImageName)
                            .font(.largeTitle)
                            .onTapGesture {
                                Task {
                                    await viewModel.set(reaction)
                                }
                            }

                    }
                }
            }
//            .task {
//                viewModel = ViewModel()
//            }
        }
}

#Preview {
    ReactionView(text: .constant(""))
}

//
//  MusicDetailView.swift
//  SwiftUIDebug
//
//  Created by Immanuel on 15/05/24.
//

import SwiftUI

class Music: ObservableObject {
    
    @Published var name = "Music one"
    var author = "Unknown"
    
    init() {
        let classInstanceAddress = MemoryAddress(of: self)
        print("Music init \(name) - \(classInstanceAddress)")
    }
    
    deinit {
        let classInstanceAddress = MemoryAddress(of: self)
        print("Music deinit \(name) - \(classInstanceAddress)")
    }
    
}

struct MusicDetailView: View {
    @State private var isPlaying: Bool = false
//    @Binding var text: String
    @StateObject private var music: Music = Music()
    
    init() {
        print(Self.self, #function)
        print(_isPOD(MusicDetailView.self))
//        print(type(of: body))
    }

    var body: some View {
        VStack(spacing: 24) {
//            Text(text)
//                .font(.title)
//                .background(Color.random())
            
//            TextField("Binding text", text: $text.animation(.spring))
//                .background(Color.random())
            
            MusicTitleView(music: $music.name)
                .debugViewChange()
            
            MusicAuthorView(music: $music.author)
            
            PlayButton(isPlaying: $isPlaying)
            
        }
//        .task {
//            music = Music()
//        }
    }
}

struct MusicTitleView: View {
//    static func == (lhs: MusicTitleView, rhs: MusicTitleView) -> Bool {
//        lhs.music.name == rhs.music.name
//    }
    
    @Binding var music: String
    
    var body: some View {
        Text(music)
            .font(.title)
            .debugSize()
        
        TextField("music name", text: $music)
            .modifier(CustomTextField(title: "music name"))
            .debugSize()
    }
}

struct MusicAuthorView: View {
//    static func == (lhs: MusicAuthorView, rhs: MusicAuthorView) -> Bool {
//        lhs.music.author == rhs.music.author
//    }
    
    @Binding var music: String
    
    var body: some View {
        Text("Music author - \(music ?? "")")
            .background(Color.random())
        
        TextField("music author", text: $music)
            .modifier(CustomTextField(title: "music author"))
            .background(Color.random())
    }
}

struct PlayButton: View {
    @Binding var isPlaying: Bool
    
    var body: some View {
        Button(isPlaying ? "Pause" : "Play") {
            withAnimation {
                isPlaying.toggle()
            }
        }
        .scaleEffect(isPlaying ? 2 : 1)
        .background(Color.random())
    }
}

#Preview {
    MusicDetailView()
}

struct CustomTextField: ViewModifier {
    let title: LocalizedStringKey
    
    func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(Fonts.scaledFont17Bold)
            content
                .tint(.black)
                .frame(height: 54)
                .padding([.leading, .trailing])
                .font(Fonts.scaledFont17Bold)
                .foregroundStyle(.black)
                .background(.yellow)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .overlay {
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(lineWidth: 5)
                }
        }
        .foregroundStyle(.black)
    }
    
}

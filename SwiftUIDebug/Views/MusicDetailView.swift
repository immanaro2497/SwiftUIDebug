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
    @Binding var testStruct: TestStruct
    
//    init() {
//        print(Self.self, #function)
//        print(_isPOD(MusicDetailView.self))
//        print(type(of: body))
//    }

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
            
            
//            Text(music.name)
//                .font(.title)
//                .background(Color.random())
//            TextField("music name", text: $music.name)
//                .modifier(CustomTextField(title: "music name"))
//                .background(Color.random())
//
//            
//            Text("Music author - \(music.author ?? "")")
//                .background(Color.random())
//            TextField("music author", text: $music.author)
//                .modifier(CustomTextField(title: "music author"))
//                .background(Color.random())
//            
//            Button(isPlaying ? "Pause" : "Play") {
//                withAnimation {
//                    isPlaying.toggle()
//                }
//            }
//            .scaleEffect(isPlaying ? 2 : 1)
//            .background(Color.random())
            
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
    MusicDetailView(testStruct: .constant(TestStruct(test: Test(name: "test"), name: "test")))
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

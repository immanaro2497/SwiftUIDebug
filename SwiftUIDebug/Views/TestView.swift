//
//  TestView.swift
//  SwiftUIDebug
//
//  Created by Immanuel on 27/05/24.
//

import SwiftUI

struct TestView: View {
    
    @State private var offset: CGFloat = 0
    
    var body: some View {
        
        GeometryReader { geometry in
            
            let minY = geometry.frame(in: .global).minY
            let _ = print("minY - ", minY)
            let refreshHeight: CGFloat = 100
            
            ScrollView {
                
                ZStack(alignment: .top) {
                    
                    if abs(minY - offset) > refreshHeight / 2 {
                        Rectangle()
                            .frame(width: refreshHeight, height: refreshHeight)
                            .offset(y: minY - offset)
                    }
                    
                    TestScrollContent()
                        .overlay {
                            GeometryReader(content: { geometry in
                                Color.clear
                                    .preference(key: CustomPreferenceKey.self, value: geometry.frame(in: .global).minY)
                            })
                        }
                    
                }
                
                
            }
            .onPreferenceChange(CustomPreferenceKey.self, perform: { value in
                print("value - ", value)
                offset = value
            })
            
            
        }
        
    }
    
}

//struct RefreshOverlayScroll: View {
//    var body: some View {
//        ScrollView {
//            
//            ZStack(alignment: .top) {
//                
//                TestScrollContent()
//                    .overlay {
//                        GeometryReader(content: { geometry in
//                            Color.clear
//                                .preference(key: CustomPreferenceKey.self, value: geometry.frame(in: .global).minY)
//                        })
//                    }
//                
//                Rectangle()
//                    .frame(width: 100, height: 100)
//                    .offset(y: -100)
//            }
//            
//            
//        }
//    }
//}

struct TestScrollContent: View {
    var body: some View {
        ScrollView {
            VStack {
                ForEach(0...20, id: \.self) { index in
                    Text("row \(index)")
                        .padding()
                        .frame(width: .infinity)
                        .onTapGesture {
                            print(index)
                        }
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color.random())
        }
    }
}

struct AnimationTestView: View {
    @State private var scale = 0.5
    
    var body: some View {
        VStack {
            Circle()
                .scaleEffect(scale)
                .animation(.interactiveSpring, value: scale)
            HStack {
                Button("+") {
//                    withAnimation(.easeIn.repeatCount(3)) {
                        scale += 0.1
//                    }
                }
                Button("-") {
                    scale -= 0.1
                }
            }
        }
        .padding()
    }
}

struct SampleData: Identifiable {
    
    let id: String
    let name: String
    
}

struct ListGrid: View {
    
    @State private var data: [SampleData] = {
        var sampleData: [SampleData] = []
        for num in 1...50 {
            sampleData.append(
                SampleData(
                    id: "\(num)",
                    name: "name - \(num)"
                )
            )
        }
        return sampleData
    }()
    @State private var columns = 2
//    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    @State private var isList: Bool = false
    
    var body: some View {
        Button(action: {
            isList.toggle()
            withAnimation {
                if columns == 1 {
                    columns = 2
                } else {
                    columns = 1
                }
            }
        }, label: {
            Text("Toggle list")
        })
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: columns), content: {
                ForEach(data) { value in
                    Text(value.name)
                        .font(.largeTitle)
                        .padding(12)
                        .overlay {
                            Rectangle()
                                .stroke(lineWidth: 2)
                        }
                }
            })
        }
    }
}

struct StoryViewMain: View {
    var body: some View {
        TabView {
            Image(systemName: "square.and.arrow.up.fill")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .background(.red)
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .background(.black)
    }
}

struct ContentView22: View {
    @State private var offset: CGSize = .zero
    @State private var startOfDragLocation: CGPoint = .zero
    @State private var circleSize: CGFloat = .zero
    @State var backOpac = 1.0

    var body: some View {
        GeometryReader { proxy in
            let h = proxy.size.height
            ZStack {
                VStack {
                    StoryViewMain()
                        .frame(width: widthOrHeight(width: true))
                        .offset(y: -10)
                }
                .padding(.top, 10)
                .padding(.bottom, 10)
                .frame(width: widthOrHeight(width: true), height: widthOrHeight(width: false) - 10)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                Color.black.padding(-h)
            }
            .mask(alignment: .topLeading) {
                if offset == .zero {
                    Rectangle().ignoresSafeArea()
                } else {
                    Circle()
                        .position(startOfDragLocation)
                        .frame(width: circleSize, height: circleSize)
                }
            }
            .offset(offset)
            .background(content: {
                Color.black.opacity(backOpac).ignoresSafeArea()
            })
            .simultaneousGesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged { value in
                        if value.translation.height >= 0 {
                            if startOfDragLocation != value.startLocation {
                                startOfDragLocation = value.startLocation
                            }
                            offset = value.translation
                            let newH = h * 1.5
                            circleSize = max(100, newH - (newH * (value.translation.height / 300.0)))
                            backOpac = max(0.0, min(1.0, 1.0 - (value.translation.height / 500.0)))
                        }
                    }
                    .onEnded({ value in
                        withAnimation(.easeIn(duration: 0.15)){
                            circleSize = h + h
                            offset = CGSize(width: 0, height: 0.001)
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            offset = .zero
                        }
                    })
            )
        }
    }
}

func widthOrHeight(width: Bool) -> CGFloat {
    let scenes = UIApplication.shared.connectedScenes
    let windowScene = scenes.first as? UIWindowScene
    let window = windowScene?.windows.first
    
    if width {
        return window?.screen.bounds.width ?? 0
    } else {
        return window?.screen.bounds.height ?? 0
    }
}

#Preview(body: {
    GeometryReader { _ in
        ContentView22()
    }
})


/*
 
 
 GeometryReader { geometry in
     let frame = geometry.frame(in: .local)
     Path { path in
         path.move(to: CGPoint(x: frame.minX + 10, y: frame.minY + 10))
         withAnimation {
             path.addLine(to: CGPoint(x: frame.minX + 10, y: frame.minY + 150))
         }
         withAnimation(.linear(duration: 2)) {
             path.addLine(to: CGPoint(x: frame.minX + 150, y: frame.minY + 150))
         }
     }
     .trim(from: 0, to: 0.7)
     .stroke()
 }
 
 
 */

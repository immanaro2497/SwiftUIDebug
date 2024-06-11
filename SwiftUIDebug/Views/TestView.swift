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

#Preview {
    TestView()
}

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

//
//  CustomRefreshView.swift
//  SwiftUIDebug
//
//  Created by Immanuel on 03/06/24.
//

import SwiftUI

struct LogoView: View {
    
    let progress: CGFloat
    
    var body: some View {
        Circle()
            .foregroundStyle(.gray.opacity(0.1))
            .overlay {
                RightLogo()
                    .trim(from: 0, to: progress)
                    .stroke(lineWidth: 1)
                    .foregroundStyle(.logoOrange)
                    .overlay {
                        RightLogo()
                            .foregroundStyle(progress >= 1 ? .orange : .clear)
                        
                    }
                LeftLogo()
                    .trim(from: 0, to: progress)
                    .stroke(lineWidth: 1)
                    .overlay {
                        LeftLogo()
                            .foregroundStyle(progress >= 1 ? .black : .clear)
                    }
            }
    }
    
}

struct RightLogo: Shape {
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        path.move(to: CGPoint(x: width * 0.47, y: height * 0.18))
        path.addLine(to: CGPoint(x: width * 0.73, y: height * 0.18))
        
        path.addLine(to: CGPoint(x: width * 0.61, y: height * 0.38))
        path.addLine(to: CGPoint(x: width * 0.81, y: height * 0.38))
        
        path.addLine(to: CGPoint(x: width * 0.7, y: height * 0.55))
        path.addLine(to: CGPoint(x: width * 0.5, y: height * 0.55))
        
        path.addLine(to: CGPoint(x: width * 0.60, y: height * 0.38))
        path.addLine(to: CGPoint(x: width * 0.34, y: height * 0.38))
        
        path.closeSubpath()
        
        return path
    }
    
}

struct LeftLogo: Shape {
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        path.move(to: CGPoint(x: width * 0.52, y: height * 0.82))
        path.addLine(to: CGPoint(x: width * 0.26, y: height * 0.82))
        
        path.addLine(to: CGPoint(x: width * 0.38, y: height * 0.62))
        path.addLine(to: CGPoint(x: width * 0.18, y: height * 0.62))
        
        path.addLine(to: CGPoint(x: width * 0.28, y: height * 0.45))
        path.addLine(to: CGPoint(x: width * 0.48, y: height * 0.45))
        
        path.addLine(to: CGPoint(x: width * 0.39, y: height * 0.62))
        path.addLine(to: CGPoint(x: width * 0.65, y: height * 0.62))
        
        path.closeSubpath()
        
        return path
    }
    
}

struct CustomRefreshView: View {
    
    var body: some View {
        
            ScrollView {
                
                    VStack {
                        ForEach(0...20, id: \.self) { index in
                            Text("row \(index)")
                                .padding()
                                .frame(width: .infinity)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.random())
                
            }
            .customRefreshable()
    }
    
}

struct CustomRefreshViewModifier: ViewModifier {
    
    @State private var offset: CGFloat = 0
    @State private var isRefreshing: Bool = false
    private let amountToPullBeforeRefreshing: CGFloat = 200
    
    func body(content: Content) -> some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .global).minY
//            let refreshOffset: CGFloat = (minY + 50 - offset) > 50 ? 0 : (minY + 50 - offset)
            let refreshOffset: CGFloat = minY - offset
            let refreshHeight: CGFloat = 50
            let _ = print(refreshOffset, refreshOffset < 40, offset)
            ScrollView {
    //            if isRefreshing {
    //                ProgressView()
    //            }
                ZStack(alignment: .top) {
                    if isRefreshing || abs(minY - offset) > refreshHeight / 2 {
                        LogoView(progress: isRefreshing ? 1 : (offset - minY - refreshHeight) / (amountToPullBeforeRefreshing - minY))
                            .frame(width: refreshHeight, height: refreshHeight)
                            .offset(y: refreshOffset)
                    }
                    content
                        .overlay {
                            GeometryReader { geo in
        //                            let _ = print(geo.frame(in: .global).minY)
                                Color.clear
                                    .preference(key: CustomPreferenceKey.self, value: geo.frame(in: .global).minY)
                            }
                        }
                        .offset(y: isRefreshing ? 50 : 0)
                        .padding(.bottom, isRefreshing ? 50 : 0)
                }
            }
        }
        .background(.white)
        .onPreferenceChange(CustomPreferenceKey.self, perform: { value in
//            print(value > amountToPullBeforeRefreshing, value, amountToPullBeforeRefreshing)
            offset = value
            if value > amountToPullBeforeRefreshing && !isRefreshing {
                withAnimation {
                    isRefreshing = true
                }
                print("Refreshing")
                Task {
                    try? await Task.sleep(nanoseconds: 2000000000)
                    withAnimation {
                        isRefreshing = false
                    }
                }
            }
        })
    }
    
}

public extension View {
    func customRefreshable() -> some View {
        modifier(CustomRefreshViewModifier())
    }
}

struct CustomPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

public extension View {
    func customRefreshableTest(onRefresh: @escaping RefreshAction) -> some View {
        ScrollWithRefreshView(content: { self },
                              onRefresh: onRefresh)
    }
}

public typealias RefreshAction = () async -> ()

struct RefreshViewOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

struct RefreshTestView: View {
    var body: some View {
        ScrollView {
            VStack {
                ForEach(0...100, id: \.self) { index in
                    Text("row \(index)")
                        .padding()
                        .frame(width: .infinity)
                }
                
            }
            .frame(maxWidth: .infinity)
        }
            .background(.blue)
        .customRefreshableTest {
            // asyncronously refresh your data here
            try? await Task.sleep(nanoseconds: 4000000000)
            print("refreshed")
        }
    }
}

public struct ScrollWithRefreshView<Content: View>: View {
    
    let content: Content
    let onRefresh: RefreshAction
    @State private var isRefreshing: Bool = false

    public init(@ViewBuilder content: () -> Content,
                onRefresh: @escaping RefreshAction) {
        self.onRefresh = onRefresh
        self.content = content()
    }
    
    private let amountToPullBeforeRefreshing: CGFloat = 180
    
    public var body: some View {
//        VStack {
            
            ScrollView {
                if isRefreshing {
                    
                    // PUT YOUR CUSTOM VIEW HERE
                    ProgressView()
                    Spacer()

                }
                content
                .background(.green)
                .overlay(GeometryReader { geo in
                    let currentScrollViewPosition = -geo.frame(in: .global).origin.y
                    if currentScrollViewPosition < -amountToPullBeforeRefreshing && !isRefreshing {
                        Color.brown.preference(key: RefreshViewOffsetKey.self, value: -geo.frame(in: .global).origin.y)
                    }
                })
            }
            .onPreferenceChange(RefreshViewOffsetKey.self) { scrollPosition in
                if scrollPosition < -amountToPullBeforeRefreshing && !isRefreshing {
                    isRefreshing = true
                    Task {
                        await onRefresh()
                        isRefreshing = false
                    }
                }
            }
//        }
        .background(.red)
    }
}

#Preview {
    CustomRefreshView()
}

//
//  StackedView.swift
//  SwiftUIDebug
//
//  Created by Immanuel on 17/07/24.
//

import SwiftUI

struct StackedView: View {
    var body: some View {
        StackedCardsNew(items: itemsC, stackedDisplayCount: 1, opacityDisplayCount: 1, itemHeight: 70) { item in
            Button {
                print(item.title)
            } label: {
                Text(item.title)
                RoundedRectangle(cornerRadius: 25.0)
                    .foregroundStyle(.blue)
            }
        }
        .safeAreaPadding(.bottom, 80)
        .safeAreaPadding(15)
    }
}

struct StackedCardsNew<Content: View, Data: RandomAccessCollection>: View where Data.Element: Identifiable {
    var items: Data
    var stackedDisplayCount: Int = 2
    var opacityDisplayCount: Int = 2
    var disablesOpacityEffect: Bool = false
    var spacing: CGFloat = 5
    var itemHeight: CGFloat
    @ViewBuilder var content: (Data.Element) -> Content
    var body: some View {
        GeometryReader {
            let size = $0.size
            let topPadding: CGFloat = size.height - itemHeight
            
            ScrollView(.vertical) {
                VStack(spacing: spacing) {
                    ForEach(items) { item in
                        content(item)
                            .frame(height: itemHeight)
                            .visualEffect { content, geometryProxy in
                                content
                                    .opacity(disablesOpacityEffect ? 1 : opacity(geometryProxy))
                                    .scaleEffect(scale(geometryProxy), anchor: .bottom)
                                    .offset(y: offset(geometryProxy)  + topPadding)
                            }
                            .zIndex(zIndex(item))
                    }
                }
                .scrollTargetLayout()
                Color.clear
                    .frame(height: topPadding)
            }
            .scrollIndicators(.hidden)
        }
    }

    func headerOffset(_ proxy: GeometryProxy, _ topPadding: CGFloat) -> CGFloat {
        let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
        let viewSize = proxy.size.height - itemHeight
        
        return -minY > (topPadding - viewSize) ? -viewSize : -minY - topPadding
    }
    func zIndex(_ item: Data.Element) -> Double {
        if let index = items.firstIndex(where: { $0.id == item.id }) as? Int {
            return Double(items.count) - Double(index)
        }
        
        return 0
    }
    func offset(_ proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
        let progress = minY / itemHeight
        let maxOffset = CGFloat(stackedDisplayCount) * offsetForEachItem
        let offset = max(min(progress * offsetForEachItem, maxOffset), 0)
        
        return minY < 0 ? 0 : -minY + offset
    }
    func scale(_ proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
        let progress = minY / itemHeight
        let maxScale = CGFloat(stackedDisplayCount) * scaleForEachItem
        let scale = max(min(progress * scaleForEachItem, maxScale), 0)
        
        return 1 - scale
    }
    func opacity(_ proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
        let progress = minY / itemHeight
        let opacityForItem = 1 / CGFloat(opacityDisplayCount + 1)
        
        let maxOpacity = CGFloat(opacityForItem) * CGFloat(opacityDisplayCount + 1)
        let opacity = max(min(progress * opacityForItem, maxOpacity), 0)
        
        return progress < CGFloat(opacityDisplayCount + 1) ? 1 - opacity : 0
    }
    var offsetForEachItem: CGFloat { return 8 }
    var scaleForEachItem: CGFloat { return 0.08 }
}

struct ItemC: Identifiable{
    var id: UUID = .init()
    var logo: String
    var title: String
    var description: String = "Lorem Ipsum is simply dummy text of the printing and typesetting industry."
}

var itemsC: [ItemC] = [
//    ItemC(logo: "", title: ""),
    ItemC(logo: "Amazon", title: "Amazon"),
    ItemC(logo: "Youtube", title: "Youtube"),
    ItemC(logo: "Dribbble", title: "Dribbble"),
    ItemC(logo: "Apple", title: "Apple"),
    ItemC(logo: "Patreon", title: "Patreon"),
    ItemC(logo: "Instagram", title: "Instagram"),
    ItemC(logo: "Netflix", title: "Netflix"),
    ItemC(logo: "Photoshop", title: "Photoshop"),
    ItemC(logo: "Figma", title: "Figma")
]

#Preview {
    StackedView()
}

//
//  ParallaxView.swift
//  SwiftUIDebug
//
//  Created by Immanuel on 21/06/24.
//

import SwiftUI

struct ParallaxView: View {
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width

            ScrollView(.horizontal) {
                LazyHStack(spacing: 22) {
                    ForEach(1...10, id: \.self) { index in
                        ZStack {
                            Image(systemName: ((index % 2) != 0) ? "house" : "paperplane")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: width, height: 450)
                                .scrollTransition(
                                    axis: .horizontal
                                ) { content, phase in
                                    content.offset(x: phase.value * -(width/2))
                                }
                        }
                        .containerRelativeFrame(.horizontal)
                        .clipShape(RoundedRectangle(cornerRadius: 32))
                        .overlay {
                            RoundedRectangle(cornerRadius: 32)
                                .stroke(lineWidth: 2)
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .contentMargins(.horizontal, 44)
            .scrollTargetBehavior(.paging)
        }
    }
}

#Preview {
    ParallaxView()
}

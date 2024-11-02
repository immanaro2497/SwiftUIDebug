//
//  MatchedGeometryTabBar.swift
//  SwiftUIDebug
//
//  Created by Immanuel on 17/10/24.
//

import SwiftUI

struct MatchedGeometryTabBar: View {
    @State private var currentTab = 0
    
    var body: some View {
        VStack {
            TabBarView(currentTab: $currentTab)
        }
    }
}

struct TabBarView: View {
    @Binding var currentTab: Int
    @Namespace var namespace

    var tabBarOptions: [String] = ["shield", "house", "hands.clap"]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(tabBarOptions.enumerated()), id: \.offset) { id, name in
                TabBarTabView(
                    currentTab: $currentTab,
                    namespace: namespace,
                    icon: name,
                    title: name,
                    tab: id
                )
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 14)
                .fill(.white)
                .shadow(color: .black.opacity(0.04), radius: 0.5, x: 0, y: 3)
                .shadow(color: .black.opacity(0.12), radius: 4, x: 0, y: 3)
                .matchedGeometryEffect(
                    id: currentTab,
                    in: namespace,
                    isSource: false
                )
        }
        .padding(2)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(.gray.opacity(0.2))
        }
        .padding(.horizontal, 16)
        .animation(.easeInOut, value: currentTab)
    }
}

struct TabBarTabView: View {
    @Binding var currentTab: Int
    let namespace: Namespace.ID
    let icon: String
    let title: String
    let tab: Int

    var body: some View {
        Button {
            currentTab = tab
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                Text(title)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .font(.body.weight(.medium))
            .foregroundStyle(tab == currentTab ? .black : .gray)
            .frame(height: 60)
        }
        .matchedGeometryEffect(
            id: tab,
            in: namespace,
            isSource: true
        )
    }
}

#Preview {
    MatchedGeometryTabBar()
}

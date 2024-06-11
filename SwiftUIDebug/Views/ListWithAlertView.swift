//
//  ListWithAlertView.swift
//  SwiftUIDebug
//
//  Created by Immanuel on 27/05/24.
//

import SwiftUI

struct ListWithAlertView: View {
    
    @State private var showingAlert = false
    @State private var rowWithSwipeActions: UUID?
    @State private var rowId = UUID()
    @Namespace private var ns
    
    let messages = [
        "message1",
        "message2",
        "message3",
        "message4",
        "message5",
        "message6",
        "message7",
        "message8",
        "message9",
        "message10",
    ]
    
    var body: some View {
        ZStack {
            List(messages, id: \.self) { message in
                Text(message)
                    .id(rowId)
                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                        Button {} label: {
                            Image(systemName: "archivebox.fill")
                        }
                        .tint(.yellow)
                    }
                    .listRowBackground(
                        GeometryReader { proxy in
                            let minX = proxy.frame(in: .global).minX
                            HStack(spacing: 0) {
                                Color(.secondarySystemGroupedBackground)
                                    .frame(width: proxy.size.width)
                                if minX < 0 {
                                    Color.clear
                                        .frame(minWidth: 74)
                                        .matchedGeometryEffect(id: rowId, in: ns, isSource: true)
                                        .onAppear { rowWithSwipeActions = rowId }
                                        .onDisappear { rowWithSwipeActions = nil }
                                }
                            }
                        }
                    )
            }
            .alert("Archive?", isPresented: $showingAlert) {
                Button("Archive") {
                    withAnimation { rowId = UUID() }
                }
                Button("Cancel", role: .cancel) {
                    withAnimation { rowId = UUID() }
                }
            } message: {
                Text("Some message")
            }
            if let rowWithSwipeActions {
                Color.black
                    .opacity(0.1)
                    .onTapGesture {
                        showingAlert = true
                    }
                    .matchedGeometryEffect(id: rowWithSwipeActions, in: ns, isSource: false)
            }
        }
    }
}

struct CustomAlert: ViewModifier {
    
    @Binding var showingAlert: Bool
    @Binding var selectedMessage: String?
    
    func body(content: Content) -> some View {
        content
            .alert("Archive?", isPresented: $showingAlert) {
                Button("Archive") {
                    showingAlert = true
                    selectedMessage = nil
                }
                Button("Cancel", role: .cancel) {
                    showingAlert = false
                    selectedMessage = nil
                }
            } message: {
                Text(selectedMessage ?? "")
            }
        
    }
    
}

#Preview {
    ListWithAlertView()
}

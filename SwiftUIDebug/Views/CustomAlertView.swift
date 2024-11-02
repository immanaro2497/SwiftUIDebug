//
//  CustomAlertView.swift
//  SwiftUIDebug
//
//  Created by Immanuel on 18/10/24.
//

import SwiftUI

struct CustomAlertView: View {
    @State private var showingAlert = false
    @State private var progress = 0

    private var progressAlert: some View {
        VStack(spacing: 0) {
            VStack(spacing: 6) {
                Text("Downloading...")
                    .font(.headline)
                Text("Progress: \(progress)")
                    .font(.footnote)
            }
            .padding()
            .frame(minHeight: 80)

            Divider()

            HStack(spacing: 0) {
                Button("Cancel", role: .cancel) {
                    // ...
                    showingAlert = false
                }
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                Divider()
                Button("Start again", role: .none) {
                    // ...
                    showingAlert = false
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderless)
            .frame(maxHeight: 44)
        }
        .frame(maxWidth: 270)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(.background)
        }
    }

    var body: some View {
        ZStack {

            Button("show Alert") {
                showingAlert = true
            }

            if showingAlert {
                Color.black
                    .opacity(0.2)
                    .ignoresSafeArea()
                    .onTapGesture { showingAlert = false }
//                    .transition(.opacity.animation(.easeInOut(duration: 0.2)))
                progressAlert
                    .transition(
                        .blurReplace
                        .animation(.spring(duration: 1))
                    )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

}

#Preview {
    CustomAlertView()
}

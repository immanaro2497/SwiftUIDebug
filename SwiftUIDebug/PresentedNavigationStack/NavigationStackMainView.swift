//
//  NavigationStackMainView.swift
//  SwiftUIDebug
//
//  Created by Immanuel on 19/09/24.
//

import SwiftUI
import Combine

struct NavigationStackMainView: View {
    @State var isPresentedSheet = false
    @State var isPresentedCustom = false
//    @State var isPresentedCustomNavPresentation = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Button("Present sheet") {
                    isPresentedSheet = true
                }
                Button("Present custom") {
                    isPresentedCustom = true
                }
                CustomPresentationView(isPresented: $isPresentedCustom) {
                    NavigationStack {
                        PresentedView(title: "Presented custom")
                    }
                }
                .frame(width: 150, height: 80)
                .onChange(of: isPresentedCustom, { oldValue, newValue in
                    print(isPresentedCustom)
                })
            }
            .navigationTitle("Some title")
            .sheet(isPresented: $isPresentedSheet) {
                NavigationStack {
                    PresentedView(title: "Presented sheet")
                }
            }
            .onChange(of: isPresentedSheet, { oldValue, newValue in
                print(isPresentedSheet)
            })
            .customPresentation(isPresented: $isPresentedCustom) {
                NavigationStack {
                    PresentedView(title: "Presented custom")
                }
            }
        }
    }
}

/*
 CustomPresentationView(isPresented: $isPresentedCustomNavPresentation) {
     NavigationStack {
         PresentedView(title: "Presented custom")
     }
 }
 .frame(width: 150, height: 80)
 */

#Preview {
    NavigationStackMainView()
}

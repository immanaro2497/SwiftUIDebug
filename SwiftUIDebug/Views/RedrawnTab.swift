//
//  RedrawnTab.swift
//  SwiftUIDebug
//
//  Created by Immanuel on 21/09/24.
//

import SwiftUI

struct RedrawnTab: View {
    
    @State private var someText: String = "Hello"
    @State private var page: Int = 0
    
    var body: some View {
        let _ = Self._printChanges()
        VStack {
            HStack {
                Text(page, format: .number)
                TextField("Enter text", text: $someText)
            }
            
            CustomTabView(page: $page)
        }
    }
}

struct CustomTabView: View {
    @Binding var page: Int
    let text: String = "Text"
    
    init(page: Binding<Int>) {
        print("custom tab view init")
        self._page = page
    }
    
    var body: some View {
        let _ = Self._printChanges()
        NavigationStack {
            TabView(selection: $page) {
                ViewOne()
                    .tag(0)
                
                ViewTwo()
                    .tag(1)
                
                ViewThree()
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Hello")
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        
                    } label: {
                        Image(systemName: "star")
                    }
                }
            }
        }
    }
}

struct ViewOne: View {
    
    init() {
        print("View one init")
    }
    
    var body: some View {
        let _ = Self._printChanges()
        Text("View one")
    }
}

struct ViewTwo: View {
    
    init() {
        print("View two init")
    }
    
    var body: some View {
        let _ = Self._printChanges()
        Text("View two")
    }
}

struct ViewThree: View {
    
    init() {
        print("View three init")
    }
    
    var body: some View {
        let _ = Self._printChanges()
        Text("View three")
    }
}

#Preview {
    RedrawnTab()
}

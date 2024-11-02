//
//  ViewDebug.swift
//  SwiftUIDebug
//
//  Created by Immanuel on 01/10/24.
//

import SwiftUI

/* Scenarios
 State in second view - value type, assign state value in init
 State in second view - struct, assign state value in init
 StateObject in second view - class, assign state value in init
 State in second view - class, assign state value in init

 Binding in second view - value type, assign binding value in init
 Binding in second view - struct, assign binding value in init
 ObservedObject in second view - class, assign object in init
 Bindable in second view - class, assign object in init
 */

struct TextValue {
    var text: String
//    var isOn: Bool = false
    
    init(text: String) {
        print("TextValue initialized")
        self.text = text
    }
    
//    deinit {
//        print("TextValue deinitialized")
//    }
}

struct ViewDebug: View {
    @State private var isOn = false
//    @State private var appNotes: TextValue = TextValue(text: "")
    
    init() {
        print("ViewDebug initialized")
    }
    
    var body: some View {
        let _ = Self._printChanges()
        Button("Toggle") {
            isOn.toggle()
        }
        ViewDebugOne()
        ViewDebugTwo(isOn: $isOn)
        Text(isOn ? "Off" : "On")
        TextView()
            .onAppear {
                print("textView onAppear")
            }
            .onDisappear {
                print("textView onDisappear")
            }
    }
}

struct ViewDebugOne: View {
    
    init() {
        print("ViewDebugOne initialized")
    }
    
    var body: some View {
        let _ = Self._printChanges()
        Text("ViewDebugOne")
    }
}

struct ViewDebugTwo: View {
    @Binding var isOn: Bool
    
    init(isOn: Binding<Bool>) {
        self._isOn = isOn
        print("ViewDebugTwo initialized")
    }
    
    var body: some View {
        let _ = Self._printChanges()
        Text("ViewDebugTwo - \(isOn)")
    }
}

struct TextView: View {
    @State private var appNotes: TextValue = TextValue(text: "")
//    @Bindable var appNotes: TextValue
//    @Binding var appNotes: TextValue
    let text: String = {
        print("computedText")
        return "text"
    }()
//    @Binding var appNotes: String
//    @Binding var toggle: Bool
//    @State private var appNotes: String = ""
    
    init() {
        print("TextView initialized")
//        self._appNotes = appNotes
//        self._toggle = toggle
//        self.appNotes = appNotes
        // TODO: check class init memory address multiple times
        // TODO: check why TextField @self changes only if text changed, compare with toggle or dynamic text
//        let structInstanceAddress = MemoryAddress(of: appNotes)
//        print(String(format: "%018p", structInstanceAddress.intValue))
    }
    
    var body: some View {
        let _ = Self._printChanges()
//        Toggle("test", isOn: $toggle)
        TextField("App Notes", text: $appNotes.text)
            .onAppear {
                print("textfield onAppear")
            }
            .onDisappear {
                print("textfield onDisappear")
            }
    }
}

#Preview {
    ViewDebug()
}

//
//  LoginView.swift
//  SwiftUIDebug
//
//  Created by Immanuel on 07/05/24.
//

import SwiftUI
import Combine

enum UserNameError: LocalizedError {
    case empty
    case duplicate
    
    var errorDescription: String? {
        switch self {
        case .empty:
            return "Username cannot be empty"
        case .duplicate:
            return "Username taken. Please use another name"
        }
    }
}

@Observable
class ObservedTest {
    
    let name: String
    
    init(name: String) {
        self.name = name
        let classInstanceAddress = MemoryAddress(of: self)
        print("ObservedTest init \(name) - \(classInstanceAddress)")
    }
    
    deinit {
        let classInstanceAddress = MemoryAddress(of: self)
        print("ObservedTest deinit \(name) - \(classInstanceAddress)")
    }
}

class Test: ObservableObject {
    
    let name: String
    
    init(name: String) {
        self.name = name
        let classInstanceAddress = MemoryAddress(of: self)
        print("Test init \(name) - \(classInstanceAddress)")
    }
    
    deinit {
        let classInstanceAddress = MemoryAddress(of: self)
        print("Test deinit \(name) - \(classInstanceAddress)")
    }
}

struct LoginView: View {
    
    @State private var observedTest = ObservedTest(name: "Login view")
    private var test = Test(name: "Login view")
    @State private var name: String = ""
    @State private var nameError: UserNameError?
    var namePublisher = PassthroughSubject<String, Never>()
    
    var body: some View {
        NavigationStack {
            TextField("Name", text: $name, prompt: Text(""))
                .accessibilityElement(children: .ignore)
                .modifier(LoginTextField(title: "Name", error: nameError))
                .onChange(of: name) { _, newName in
                    namePublisher.send(newName)
                    
                    let observedTestAddress = MemoryAddress(of: observedTest)
                    print("on change observedTest trigger - \(observedTestAddress)")
                    
                    let testAddress = MemoryAddress(of: test)
                    print("on change test trigger - \(testAddress)")
    //                test = Test()
                }
                .onReceive(namePublisher
                    .debounce(for: 0.6, scheduler: DispatchQueue.main)
                ) { text in
                    withAnimation {
                        if text.trimmingCharacters(in: .whitespaces).isEmpty {
                            nameError = .empty
                        } else if name == "User1" {
                            nameError = .duplicate
                        } else {
                            nameError = nil
                        }
                    }
                }
                .accessibilityElement(children: .combine)
            NavigationLink("Detail view") {
                DetailView()
            }
        }
    }
}

struct LoginTextField: ViewModifier {
    let title: LocalizedStringKey
    let error: Error?
    
    func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(Fonts.scaledFont17Bold)
            content
                .tint(.black)
                .frame(height: 54)
                .padding([.leading, .trailing])
                .font(Fonts.scaledFont17Bold)
                .foregroundStyle(.black)
                .background(.yellow)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .overlay {
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(lineWidth: 5)
                }
            if let error {
                Text(error.localizedDescription)
                    .font(Fonts.scaledFont15Bold)
                    .accessibilityLabel("Error. \(error.localizedDescription)")

            }
        }
        .foregroundStyle(error == nil ? .black : .red)
    }
    
}

struct Fonts {
    
    private static func title1FontMetrics(_ size: CGFloat) -> CGFloat {
        UIFontMetrics(forTextStyle: .title1).scaledValue(for: size)
    }
    
    static let scaledFont17Bold: Font = {
        return Font.system(size: title1FontMetrics(17), weight: .bold)
    }()
    
    static let scaledFont15Bold: Font = {
        return Font.system(size: title1FontMetrics(15), weight: .bold)
    }()
    
}

#Preview {
    LoginView()
}

//
//  CustomPresentationView.swift
//  SwiftUIDebug
//
//  Created by Immanuel on 19/09/24.
//

import SwiftUI

struct CustomPresentationView<ViewContent: View>: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UIViewController
    
    @Binding var isPresented: Bool {
        didSet {
            print("CustomPresentationView isPresented")
        }
    }
    private let content: () -> ViewContent
    
    init(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> ViewContent) {
        self._isPresented = isPresented
        self.content = content
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(controller: self)
    }
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        let controller = CustomUIViewController(isPresented: $isPresented, content: content)
        controller.coordinator = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        print("update view controller")
    }
    
    class Coordinator: NSObject, UIAdaptivePresentationControllerDelegate {
        
        let controller: CustomPresentationView<ViewContent>
        
        init(controller: CustomPresentationView<ViewContent>) {
            self.controller = controller
        }
        
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            controller.isPresented = false
        }
        
    }
    
    class CustomUIViewController: UIViewController {
        
        @Binding var isPresented: Bool {
            didSet {
                print("CustomUIViewController isPresented")
            }
        }
        private let content: () -> ViewContent
        weak var coordinator: Coordinator?
        
        init(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> ViewContent) {
            self._isPresented = isPresented
            self.content = content
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            configureButton()
        }
        
        func configureButton() {
            var configuration = UIButton.Configuration.gray()
            configuration.title = "Present custom"
            configuration.cornerStyle = .capsule
            configuration.baseForegroundColor = UIColor.red
            configuration.buttonSize = .large
            
            let button = UIButton(type: .custom)
            button.configuration = configuration
            view.addSubview(button)
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraint(equalToConstant: 150).isActive = true
            button.heightAnchor.constraint(equalToConstant: 80).isActive = true
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            
            button.addAction(UIAction(
                handler: { [weak self] _ in
                    self?.onButtonTap()
                }
            ),for: .touchUpInside)
        }
        
        func onButtonTap() {
            let view = content()
                .environment(\.close, CloseAction(isPresented: $isPresented))
            let hostingViewController = UIHostingController(rootView: view)
            hostingViewController.presentationController?.delegate = coordinator
            present(hostingViewController, animated: true, completion: { [weak self] in
                self?.isPresented = true
            })
        }
        
    }
    
}



struct CustomPresentationViewOriginal<ViewContent: View>: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController
    
    class Coordinator: NSObject, UIAdaptivePresentationControllerDelegate {
        @Binding private var isPresented: Bool
        
        init(isPresented: Binding<Bool>) {
            self._isPresented = isPresented
            super.init()
        }
        
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            isPresented = false
        }
    }
    
    @Binding private var isPresented: Bool
    @ViewBuilder private let content: () -> ViewContent
    
    init(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> ViewContent) {
        self._isPresented = isPresented
        self.content = content
    }
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        if isPresented {
            if uiViewController.presentedViewController == nil {
                DispatchQueue.main.async {
                    let view = content()
                        .environment(\.close, CloseAction(isPresented: $isPresented))
                    let hostingViewController = UIHostingController(rootView: view)
                    hostingViewController.presentationController?.delegate = context.coordinator
                    uiViewController.present(hostingViewController, animated: true)
                }
            }
        } else if
            let presentedViewController = uiViewController.presentedViewController,
            !presentedViewController.isBeingDismissed
        {
            presentedViewController.dismiss(animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(isPresented: $isPresented)
    }
}

struct CustomPresentationModifier<ViewContent: View>: ViewModifier {
    @Binding private var isPresented: Bool
    @ViewBuilder private let viewContent: () -> ViewContent
    
    public init(isPresented: Binding<Bool>, @ViewBuilder viewContent: @escaping () -> ViewContent) {
        self._isPresented = isPresented
        self.viewContent = viewContent
    }
    
    func body(content: Content) -> some View {
        content.background(CustomPresentationViewOriginal(isPresented: _isPresented, content: viewContent))
    }
}

public extension View {
    func customPresentation<ViewContent: View>(isPresented: Binding<Bool>, @ViewBuilder viewContent: @escaping () -> ViewContent) -> some View {
        modifier(CustomPresentationModifier(isPresented: isPresented, viewContent: viewContent))
    }
}

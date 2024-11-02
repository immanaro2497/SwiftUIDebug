//
//  MatchingOffsetScrollView.swift
//  SwiftUIDebug
//
//  Created by Immanuel on 10/10/24.
//

import SwiftUI

struct SwiftUIScrollView<Content: View>: UIViewControllerRepresentable {
    
    @Binding var contentOffset: CGPoint
    let content: () -> Content
    
    typealias UIViewControllerType = CustomScrollController<Content>
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        print(#function, contentOffset)
        let controller = CustomScrollController(contentOffset: $contentOffset, content: content)
        controller.scrollView.contentOffset = contentOffset
        controller.scrollView.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        print(#function, contentOffset)
        uiViewController.scrollView.contentOffset = contentOffset
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(contentOffset: $contentOffset)
    }

    public class Coordinator: NSObject, UIScrollViewDelegate {
        
//        let scrollViewWrapper: SwiftUIScrollView
//
//        init(scrollViewWrapper: SwiftUIScrollView) {
//            self.scrollViewWrapper = scrollViewWrapper
//        }
        @Binding var contentOffset: CGPoint
        var isFirstLoad: Bool = true
        
        init(contentOffset: Binding<CGPoint>) {
            self._contentOffset = contentOffset
        }

        public func scrollViewDidScroll(_ scrollView: UIScrollView) {
//            print(#function, scrollViewWrapper.contentOffset)
//            if !isFirstLoad {
                print(#function, contentOffset)
                print(scrollView.contentOffset)
                print(scrollView)
                contentOffset = scrollView.contentOffset
//            }
            isFirstLoad = false
        }
    }
}

class CustomScrollController<Content: View>: UIViewController {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let scrollView: UIScrollView = UIScrollView()
    @Binding var contentOffset: CGPoint
    let content: () -> Content
    
    init(contentOffset: Binding<CGPoint>, @ViewBuilder content: @escaping () -> Content) {
        self._contentOffset = contentOffset
        self.content = content
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        print("is appearing - ", scrollView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("did appear - ", scrollView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("layout subviews - ", scrollView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        
        view.addSubview(scrollView)
        print(scrollView)
        scrollView.backgroundColor = .blue
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        let swiftUIController = UIHostingController(rootView: content())
        let hostingView: UIView = swiftUIController.view
        addChild(swiftUIController)
        
        let spacing = 10.0
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        stackView.addArrangedSubview(hostingView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
        ])
        
        swiftUIController.didMove(toParent: self)
        
        
//        let label = UILabel()
//        label.numberOfLines = 0
//        stackView.addArrangedSubview(label)
//        label.text = "Hello, World! This is a custom scroll view. Scroll down to see the text. Scroll up to see the square. Scroll left to see the text. Scroll right to see the square.    \n\nSwiftUI is awesome! It's a great UI library. It's easy to use. It's beautiful. It's free. foo bar baz quux Hello, World! This is a custom scroll view. Scroll down to see the text. Scroll up to see the square. Scroll left to see the text. Scroll right to see the square.    \n\nSwiftUI is awesome! It's a great UI library. It's easy to use. It's beautiful. It's free. foo bar baz quux Hello, World! This is a custom scroll view. Scroll down to see the text. Scroll up to see the square. Scroll left to see the text. Scroll right to see the square.    \n\nSwiftUI is awesome! It's a great UI library. It's easy to use. It's beautiful. It's free. foo bar baz quux Hello, World! This is a custom scroll view. Scroll down to see the text. Scroll up to see the square. Scroll left to see the text. Scroll right to see the square.    \n\nSwiftUI is awesome! It's a great UI library. It's easy to use. It's beautiful. It's free. foo bar baz quux Hello, World! This is a custom scroll view. Scroll down to see the text. Scroll up to see the square. Scroll left to see the text. Scroll right to see the square.    \n\nSwiftUI is awesome! It's a great UI library. It's easy to use. It's beautiful. It's free. foo bar baz quux Hello, World! This is a custom scroll view. Scroll down to see the text. Scroll up to see the square. Scroll left to see the text. Scroll right to see the square.    \n\nSwiftUI is awesome! It's a great UI library. It's easy to use. It's beautiful. It's free. foo bar baz quux Hello, World! This is a custom scroll view. Scroll down to see the text. Scroll up to see the square. Scroll left to see the text. Scroll right to see the square.    \n\nSwiftUI is awesome! It's a great UI library. It's easy to use. It's beautiful. It's free. foo bar baz quux Hello, World! This is a custom scroll view. Scroll down to see the text. Scroll up to see the square. Scroll left to see the text. Scroll right to see the square.    \n\nSwiftUI is awesome! It's a great UI library. It's easy to use. It's beautiful. It's free. foo bar baz quux, Scroll down to see the text. Scroll up to see the square. Scroll left to see the text. Scroll right to see the square.    \n\nSwiftUI is awesome! It's a great UI library. It's easy to use. It's beautiful. It's free. foo bar baz quux Hello, World! This is a custom scroll view. Scroll down to see the text. Scroll up to see the square. Scroll left to see the text. Scroll right to see the square.    \n\nSwiftUI is awesome! It's a great UI library. It's easy to use. It's beautiful. It's free. foo bar baz quux"
    }
}

// TODO: Scrollview offsets not matching the first time they appear and binding value is not same for different scrollviews if printed
struct MatchingOffsetScrollView: View {
    @State private var contentOffset: CGPoint = CGPoint(x: 0, y: 100)
    @State private var currentPageIndex: Int = 0
    
    var body: some View {
        VStack(spacing: .zero) {
            TabView(selection: $currentPageIndex) {
                ForEach(0..<2, id: \.self) { index in
                    SwiftUIScrollView(
                        contentOffset: $contentOffset
                    ) {
                        VStack(spacing: .zero) {
                            square
                            VStack(spacing: .zero) {
                                text
                                Spacer()
                            }
                            .frame(height: 800)
                        }
                        .tag(index)
                    }
                    .ignoresSafeArea(edges: .top)
                    .onAppear {
                        print("onAppear for \(index) - \(contentOffset.y)")
                    }
                    .onDisappear {
                        print("onDisappear for \(index) - \(contentOffset.y)")
                    }
                }
            }
            .ignoresSafeArea(edges: .top)
            .tabViewStyle(.page(indexDisplayMode: .never))

            Text("Footer")
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red)
        }
        .onChange(of: contentOffset) {
            print("contentOffset Y is now \(contentOffset.y)")
        }
    }

    var square: some View {
        RoundedRectangle(cornerRadius: 29)
            .frame(width: 300, height: 300)
    }

    var text: some View {
        VStack(spacing: 16) {
            Text("Text")
                .font(.title)
        }
    }
}

private struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        let next = nextValue()
        // Take the maximum value to ensure we get the correct height
        print(value, next)
        value = max(value, next)
    }
}

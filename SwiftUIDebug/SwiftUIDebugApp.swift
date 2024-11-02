//
//  SwiftUIDebugApp.swift
//  SwiftUIDebug
//
//  Created by Immanuel on 07/05/24.
//

import SwiftUI
import TipKit

@MainActor
func nonisolatedAsyncOne() async {
    print(#function)
}

@MainActor
func nonisolatedAsyncTwo() async {
    print(#function)
}

@main
struct SwiftUIDebugApp: App {
    let persistenceController = PersistenceController.shared
    @State private var actor = TestAct(name: "name1")
    @State private var count = 0
    var body: some Scene {
        WindowGroup {
            Button("click") {
                count += 1
                Task {
                    await Task.yield()
                    await nonisolatedAsyncOne()
                }
                Task {
                    await nonisolatedAsyncTwo()
                }
//                for _ in 0...5000000 {
//                    let val = 1 + 1
//                }
//                Task.detached {
//                    await actor.updateName()
//                    for _ in 0...5000000 {
//                        let val = 1 + 1
//                    }
//                }
//                Task.detached {
//                    await longRunningTask()
//                }
            }
            Text("\(count)")
        }
    }
    
    @MainActor
    func longRunningTask() {
//        Task { @MainActor in
            for _ in 0...5000000 {
                let val = 1 + 1
            }
            count += 1
//        }
    }
    
//    init() {
//        do {
//            try setupTips()
//        } catch {
//            print("Error initializing tips: \(error)")
//        }
//    }
    
    private func setupTips() throws {
        // Show all defined tips in the app.
        // Tips.showAllTipsForTesting()

        // Show some tips, but not all.
        // Tips.showTipsForTesting([tip1, tip2, tip3])

        // Hide all tips defined in the app.
        // Tips.hideAllTipsForTesting()

        // Purge all TipKit-related data.
        try Tips.resetDatastore()

        // Configure and load all tips in the app.
        try Tips.configure()
    }
}

actor TestAct {
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    func updateName() {
        for _ in 0...5000000 {
            let val = 1 + 1
        }
        name.append("1")
    }
}

import WebKit

struct CustomWebView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> InternetLoader {
        InternetLoader(nibName: nil, bundle: nil)
    }
    
    func updateUIViewController(_ uiViewController: InternetLoader, context: Context) {
        
    }
}

class InternetLoader: UIViewController {
    
    lazy var button: UIButton = {
        let button: UIButton = UIButton(type: .detailDisclosure)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        button.setTitle("Load", for: .normal)
        button.addAction(UIAction(handler: { _ in
            self.getHTML()
        }), for: .touchUpInside)
        return button
    }()
    
    lazy var webView: WKWebView = {
        let webView: WKWebView = WKWebView(frame: CGRect(x: 0, y: 50, width: 300, height: 500))
        webView.navigationDelegate = self
        return webView
    }()
    
    private var resultHtml: String? = nil
        
    var continuation: UnsafeContinuation<Bool, Error>?
    
    override func viewDidLoad() {
        view.addSubview(button)
        view.addSubview(webView)
    }
    
    func getHTML(from url: URL = URL(string: "https://stackoverflow.com/questions")!) {
        print(#function, Thread.isMainThread)
        Task {
            try await withUnsafeThrowingContinuation { continuatio in
                continuation = continuatio
                webView.load(URLRequest(url: url))
            }
        }
    }
    
}

extension InternetLoader: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.body.innerHTML") { [weak self] (result, error) in
//            if let error = error {
//                print("Error executing JavaScript: \(error.localizedDescription)")
//            } else if let htmlContent = result as? String {
//                self?.resultHtml = htmlContent
//            }
            print(#function, Thread.isMainThread)
            self?.continuation?.resume(returning: true)
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        continuation?.resume(throwing: error)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        continuation?.resume(throwing: error)
    }
}

//actor BarActor {
//    
//    var bar: Int {
//        return 2
//    }
//    
//    static let barActor: BarActor = BarActor()
//    
//    func add(theBar: Int = BarActor.barActor.bar) -> Int { //Error is here.
//        return theBar + 100
//    }
//}

struct MyScene: Scene {
    
    @State private var appNotes: String = ""
    @Environment(\.scenePhase) private var scenePhase
    let money = Money(value: 1, notes: "")
    
    var body: some Scene {
        WindowGroup {
            MultiWindowView(money: money, appNotes: $appNotes)
        }
        .onChange(of: scenePhase) { oldValue, newValue in
            print("\(oldValue) - \(newValue)")
        }
        WindowGroup("Multi-one", id: "multi-window-one", for: Int.self) { $num in
            MultiWindowView(money: money, appNotes: $appNotes)
//            CounterViewWithHang(counterViewModel: CounterViewModel())
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .defaultSize(width: 800, height: 500)
        WindowGroup("Multi-two", id: "multi-window-two", for: Int.self) { $num in
            MultiWindowView(money: money, appNotes: $appNotes)
        }
    }
    
}

import Combine

class PeopleListViewModel: ObservableObject {
    
    var searchText: String = "" {
        willSet {
            print("will set")
            Task {
                print("will set queue")
                self.objectWillChange.send()
            }
        }
    }
    var peopleLists: [String] = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten"]
    
    var searchResults: [String] {
        guard !searchText.isEmpty else { return peopleLists }
        return peopleLists.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }
    
}

struct SearchList: View {
    
    @StateObject var peopleListViewModel: PeopleListViewModel = PeopleListViewModel()
    
    var body: some View {
        NavigationStack {
            List(peopleListViewModel.searchResults, id: \.self) { value in
                Text(value)
            }
            .searchable(text: $peopleListViewModel.searchText)
        }
    }
    
}

//#Preview {
//    SearchList()
//}

struct SearchBarView: View {
    @State private var search = ""
    @State private var isSelected = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .padding(.leading, 8)

                    TextField("Search", text: $search)
                        .padding(.vertical, 8)
                        .focused($isFocused)
                        .submitLabel(.search)
                        .onSubmit {
                            isFocused = false
                        }
                }
                .background(Color(.systemGray6))
                .cornerRadius(8)

                
                if isSelected{
                    ZStack{
                        Button {

                            isFocused = false
                            search = ""
                            withAnimation {
                                isSelected = false
                            }
                        } label: {
                            Text("Cancel")
                                .foregroundStyle(Color.accentColor)
                        }
                    }
                    .transition(.move(edge: .trailing).combined(with: .opacity))
                    .buttonStyle(PlainButtonStyle())
                }
                
            }
            .onChange(of: isFocused) { _, focused in

                withAnimation(.easeInOut) {
                    isSelected = focused
                }
            }
    }
}

struct CombineTestView: View {
    @State private var textOne: String = ""
    @State private var textTwo: String = ""
    
//    let pub1 = PassthroughSubject<String, Never>()
//    let pub2 = PassthroughSubject<String, Never>()
    
    let pub1 = [1,2,3].publisher
    let pub2 = [4,5,6].publisher
    
    var cancellable: AnyCancellable?
    
    init() {
        cancellable = pub1
            .zip(pub2) { (first, second) in
                print("executing closure")
                return first + second
            }
            .sink { print("Result: \($0).") }
    }
    
    var body: some View {
        HStack {
            TextField("Text One", text: $textOne)
            Text(textOne)
        }
        HStack {
            TextField("Text Two", text: $textTwo)
            Text(textTwo)
        }
        
        Button("One send") {
//            pub1.send(textOne)
        }
        Button("Two send") {
//            pub2.send(textTwo)
        }
    }
}

//#Preview(body: {
//   CombineTestView()
//})


/*
TestOne
final class NonSendableClass: Sendable {
    var data: Int = 0
}

actor A {
  func f(_ ns: NonSendableClass) async {
    await Task.yield()
    ns.data += 1
  }
}

@MainActor
func main() async {
  let nonSendableObject = NonSendableClass()
  let a = A()
  Task {
    await a.f(nonSendableObject)
  }
  await Task.yield()
  print(nonSendableObject.data)
}

TestTwo
class NonSendableClass {
  var data: Int
  init(data: Int) {
    self.data = data
  }
}

//@available(*, unavailable)
//extension NonSendableClass: Sendable { }

// Make Foo explicitly run on a different actor
actor SomeActor{
  static func Foo(_ obj: NonSendableClass) async -> Int{
    try? await Task.sleep(nanoseconds: UInt64.random(in: 0..<1000))
    obj.data += 1
    return 0
  }
}

@MainActor
func main() async {
  let nonSendableObject = NonSendableClass(data: 0)
  let nonSendableObject2 = nonSendableObject
  for i in 0...1000{
    // SomeActor.Foo will increment this value by 1
    let task = Task { await SomeActor.Foo(nonSendableObject) }
    try? await Task.sleep(nanoseconds: UInt64.random(in: 0..<1000))
    // Decrement this value by 1
    nonSendableObject2.data -= 1
    let _ = await task.value
    // I would expect at the end of each iteration the value should be 0 +1 -1 = 0
    print("Iteration \(i): \(nonSendableObject2.data)")
  }
}

await main()
*/

struct HeaderView: View {
    var body: some View {
        Text("Welcome to Ask Anything")
    }
}

struct HomeView: View {
    var body: some View {
        VStack{
            // Header
            HeaderView()
            Spacer() // Push everything to the top
            Spacer()
            
            //Query chips and sign in button
            HomeBodyView()
            Spacer()
            Spacer()
            
            
            SearchButtonView()
        }
        
    }
}

class SearchButtonViewVModel: ObservableObject {
    @Published var showSearchSheet: Bool = false
}

struct SearchButtonView: View {
    @StateObject var viewModel = SearchButtonViewVModel()
    var body: some View {
        Button(action: {
            viewModel.showSearchSheet.toggle()
        }) {
            Text("Ask anything...")
                .font(.system(size: 16))
                .fontWeight(.semibold)
                .foregroundColor(Color("FontColor"))
                .padding() // Adds internal padding to the text
                .frame(maxWidth: .infinity) // Make the button take full width
                .background(Color(.systemGray6))
                .cornerRadius(30)
                .shadow(radius: 1)
        }
        .padding()// Horizontal padding around the button
        .sheet(isPresented: $viewModel.showSearchSheet) {
            // Content of the sheet
          
            SearchView(showSearchSheet: $viewModel.showSearchSheet)
                .presentationDetents([.height(100)])
        }
        
    }
}

struct SearchView: View {
    @Binding var showSearchSheet: Bool
    var body: some View {
        Text("Search view")
    }
}

struct HomeBodyView: View {
    var body: some View {
        VStack{
            Image("butler_logo_light") // Replace with your image asset name
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 110) // Adjust the height as needed
                            .padding(.bottom, 10)
            Text("Search for your restaurant")
                .font(.system(size: 20))
                .fontWeight(.regular)
                .foregroundStyle(Color("FontColor"))

            // View that contains animation
            QueryChipsView()
        }.frame(width: UIScreen.main.bounds.width, height: 100)
            
    }
}

struct ButtonData: Identifiable, Hashable {
    let id = UUID()
    var text: String
}

struct QueryChipsView: View {
    let buttonData = [
        ["🕯️ Did Edison invent the lightbulb?", "🚴‍♂️ How do you ride a bike?"],
        ["⛷️ The best ski resorts in the Alps", "🏟️ The greatest Super Bowl moments", "🎬 Best movies of all time"],
        ["🥊 The best boxing style", "🐩 The best dog breed for apartments","🏖️ Top beach destinations"],
    ]
    

    var body: some View {
        
        // Apply the scrolling content as an overlay to a placeholder,
        // so that it is leading-aligned instead of center-aligned
        Color.clear
            .overlay(alignment: .leading) {
                VStack(alignment: .leading) {
                    ForEach(Array(buttonData.enumerated()), id: \.offset) { rowIndex, buttonItems in
                        ScrollingButtonRow(buttonItems: buttonItems)
                        
                    }
                }
            }
            .frame(height: 200) // Constrain the height of the button area
    }
    
}

struct ScrollingButtonRow: View {
    let buttonItems: [String]
    let spacing: CGFloat = 14
    let baseSpeed: CGFloat = 50 // Speed of the scroll (points per second)
    @State private var offsetX: CGFloat = 0 // To move the buttons horizontally
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        HStack(spacing: spacing) {
            buttons
                .background {
                    
                    // Measure the width of one set of buttons and
                    // launch scrolling when the view appears
                    GeometryReader { proxy in
                        Color.clear
                            .onAppear {
                                startScrolling(scrolledWidth: proxy.size.width + spacing)
                            }
                            
                    }
                }
            
            // Repeat the buttons, so that the follow-on is seamless
            buttons
        }
        .offset(x: offsetX)
    }
    
    private var buttons: some View {
        HStack(spacing: spacing) {
            ForEach(Array(buttonItems.enumerated()), id: \.offset) { offset, item in
                Button {
                    // Button action
                } label: {
                    Text(item)
                        .padding(.vertical, 8)
                        .padding(.horizontal,15)
                        .fixedSize()
//                        .foregroundStyle(Color("FontColor"))
                        .font(.system(size: 12))
//                        .fontWeight(.light)
                        .background {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.gray.opacity(colorScheme == .dark ? 0.15 : 0.05))
                        }
                }
            }
        }
    }
    
    private func startScrolling(scrolledWidth: CGFloat) {
        withAnimation(
            .linear(duration: scrolledWidth / baseSpeed)
            .repeatForever(autoreverses: false)
        ) {
            offsetX = -scrolledWidth
        }
    }
}

#Preview {
    HomeView()
}

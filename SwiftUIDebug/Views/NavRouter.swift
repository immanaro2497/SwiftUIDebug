//
//  NavRouter.swift
//  SwiftUIDebug
//
//  Created by Immanuel on 25/07/24.
//

import SwiftUI

//@main
struct RoutingDemo_SwiftUIApp: App {
    
    @StateObject private var router = Router()

    var body: some Scene {
        WindowGroup {
            RouterContentView()
        }
        .environmentObject(router)
    }
}

struct RouterContentView: View {
    @StateObject private var router = Router()
    
    var body: some View {
//        let _ = Self._printChanges()
        NavigationStack(path: $router.navPath) {
            Text("fwfe")
                .onAppear {
                    print("splash appear")
                }
                .onDisappear {
                    print("splash disappear")
                }
//                .modifier(TimedView(callBack: {
//                    router.navigate(to: .login)
//                }))
                .navigationDestination(for: Router.Destination.self, destination: { destination in
                    switch destination {
                    case .dashboardView:
                        RouteTempView()
                            .onAppear {
                                print("temp appear")
                            }
                            .onDisappear{
                                print("temp disappear")
                            }
                    case .login:
                        RouteLoginView().navigationTitle("")
                            .onAppear {
                                print("login appear")
                            }
                            .onDisappear{
                                print("login disappear")
                            }
//                            .navigationBarBackButtonHidden()
                    }
                })
        }.environmentObject(router)
    }
}

struct RouteSplashScreen: View {
    
    @EnvironmentObject var router: Router
   
    var body: some View {
//        let _ = Self._printChanges()
        TimerView(callBack: {
//            router.navigate(to: .login)
        })
        
    }
}

struct TimedView: ViewModifier {
    
    @State private var countDown = 5
    var callBack: (() -> Void)
    
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    func body(content: Content) -> some View {
        content
            .onReceive(timer) { _ in
                if countDown > 0 {
                    countDown -= 1
                } else {
                    timer.upstream.connect().cancel()
                    countDown = 2
                    callBack()
                }
            }
    }
}

struct TimerView: View {
    @State private var countDown = 5
    
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var callBack: (() -> Void)
    
    var body: some View {
//        let _ = Self._printChanges()
        VStack {
            Text("Timer")
        }.onReceive(timer) { _ in
            if countDown > 0 {
                countDown -= 1
            } else {
                timer.upstream.connect().cancel()
                callBack()
            }
        }
    }
}

struct RouteLoginView: View {
    
    @EnvironmentObject var router: Router
   
    var body: some View {
        Button("Login", action: {
            router.navigate(to: .dashboardView)
        })
    }
}

struct RouteTempView: View {
    
//    @EnvironmentObject var router: Router
    
    var body: some View {
        Text("RouteTempView")
//        Button("reset") {
//            router.navPath.removeLast(router.navPath.count)
//        }
    }
}

final class Router: ObservableObject {
    
    public enum Destination: Codable, Hashable {
        case login
        case dashboardView
    }
    
    @Published var navPath = NavigationPath()
    
//    init() {
//        navPath.append(Destination.login)
//        navPath.append(Destination.dashboardView)
//    }
    
    func navigate(to destination: Destination) {
        navPath.append(destination)
    }
    
    func navigateBack() {
        navPath.removeLast()
    }
    
    func navigateToRoot() {
        navPath.removeLast(navPath.count)
    }
}

#Preview {
    RouterContentView()
}

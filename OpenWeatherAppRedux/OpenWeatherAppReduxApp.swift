//
//  OpenWeatherAppReduxApp.swift
//  OpenWeatherAppRedux
//
//  Created by Tạ Minh Quân on 03/05/2023.
//

import SwiftUI
import OpenWeatherBusinessLogic

let store = Store(
    initial: AppState(),
    reducer: AppState.reducer,
    middlewares: [ Middlewares.logger, Middlewares.openWeather]
)

let navBarAppearence = UINavigationBarAppearance()

struct AppView: View {
    @EnvironmentObject var store: Store<AppState>

    var body: some View {
        if store.state.screenState(for: .home) as HomeState? != nil {
            NavigationView {
                HomeView()
            }
            .navigationViewStyle(.stack)
        } else {
            ContentView()
        }
    }
}

@main
struct OpenWeatherAppReduxApp: App {
    
    init() {
        UINavigationBar.appearance().isTranslucent = false
        navBarAppearence.configureWithTransparentBackground()
        navBarAppearence.backgroundColor = .systemGreen
        navBarAppearence.titleTextAttributes = [.foregroundColor: UIColor.black]
        navBarAppearence.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        
        UINavigationBar.appearance().standardAppearance = navBarAppearence
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearence
        
    }
    
    var body: some Scene {
        WindowGroup {
            AppView()
                .tint(.black)
                .foregroundColor(.primary)
                .environmentObject(store)
        }
    }
}

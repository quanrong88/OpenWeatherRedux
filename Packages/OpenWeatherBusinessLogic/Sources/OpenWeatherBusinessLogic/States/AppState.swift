//
//  File.swift
//  
//
//  Created by Tạ Minh Quân on 13/05/2023.
//

import Foundation

public struct AppState: Codable {
    public let activeScreens: ActiveScreensState
}

extension AppState {
    public init() {
        activeScreens = ActiveScreensState()
    }
    
    public static let mock = AppState(activeScreens: .mock)
}

public extension AppState {
    static let reducer: Reducer<Self> = { state, action in
        AppState(
            activeScreens: ActiveScreensState.reducer(state.activeScreens, action)
        )
    }
}

extension AppState {
    public func screenState<State>(for screen: AppScreen) -> State? {
        return activeScreens.screens
            .compactMap {
                switch ($0, screen) {
                case (.home(let state), .home): return state as? State
                case (.forecast(let state), .forecast): return state as? State
                default: return nil
                }
            }
            .first
    }
}

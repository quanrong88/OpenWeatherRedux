//
//  File.swift
//  
//
//  Created by Tạ Minh Quân on 13/05/2023.
//

import Foundation

public enum AppScreenState: Codable {
    case home(HomeState)
    case forecast(ForecastState)
}

extension AppScreenState: CustomStringConvertible {
    public var description: String {
        switch self {
        case .home(let state):
            return "Home: isLoading = \(state.isLoading)"
        case .forecast(let state):
            return "Forecast: isLoading = \(state.isLoading)"
        }
    }
}

extension AppScreenState {
    public static let reducer: Reducer<Self> = { state, action in
        switch state {
        case .home(let state):
            return .home(HomeState.reducer(state, action))
        case .forecast(let state):
            return .forecast(ForecastState.reducer(state, action))
        }
    }
}

extension AppScreenState {
    public static func == (lhs: AppScreenState, rhs: AppScreen) -> Bool {
        switch (lhs, rhs) {
        case (.home, .home): return true
        case (.forecast, .forecast): return true
        default:
            return false
        }
    }

    public static func == (lhs: AppScreen, rhs: AppScreenState) -> Bool {
        rhs == lhs
    }

    public static func != (lhs: AppScreen, rhs: AppScreenState) -> Bool {
        !(lhs == rhs)
    }

    public static func != (lhs: AppScreenState, rhs: AppScreen) -> Bool {
        !(lhs == rhs)
    }
}

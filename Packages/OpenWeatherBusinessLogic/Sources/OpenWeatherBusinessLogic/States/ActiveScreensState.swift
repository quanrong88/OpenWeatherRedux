//
//  File.swift
//  
//
//  Created by Tạ Minh Quân on 13/05/2023.
//

import Foundation

public struct ActiveScreensState: Codable {
    public let screens: [AppScreenState]
}

extension ActiveScreensState {
    init() {
        screens = [.home(HomeState())]
    }
    
    public static let mock = ActiveScreensState(screens: [.home(.mock), .forecast(.mock)])
}

public enum AppScreen {
    case home
    case forecast
}

public enum ActiveScreenStateAction: Action {
    case showScreen(AppScreen)
    case dismissScreen(AppScreen)
}

extension ActiveScreensState {
    public static let reducer: Reducer<Self> = { state, action in
        var screens = state.screens
        if let action = action as? ActiveScreenStateAction {
            switch action {
            case .showScreen(.forecast):
                screens += [.forecast(ForecastState())]
            case .dismissScreen(let screen):
                screens = screens.filter { $0 != screen }
            case .showScreen(.home):
                screens = [.home(HomeState())]
            }
        }
        
        screens = screens.map { AppScreenState.reducer($0, action) }

        return ActiveScreensState(screens: screens)
    }
}

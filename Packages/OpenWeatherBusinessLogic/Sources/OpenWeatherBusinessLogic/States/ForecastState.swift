//
//  File.swift
//  
//
//  Created by Tạ Minh Quân on 07/05/2023.
//

import Foundation

public struct ForecastState: Codable {
    public let forecasts: [ForecastCellModel]
    public let isLoading: Bool
    public let errorMessage: String
}

extension ForecastState {
    public init() {
        forecasts = []
        isLoading = false
        errorMessage = ""
    }
    
    public static let mock = ForecastState(forecasts: [.mock], isLoading: false, errorMessage: "")
}

public enum ForecastStateAction: Action {
    case loadData
    case didReceiveData(forecasts: [ForecastCellModel])
    case didReceiveError(message: String)
}

extension ForecastState {
    public static let reducer: Reducer<Self> = { state, action in
        switch action {
        case ForecastStateAction.loadData:
            return ForecastState(forecasts: state.forecasts, isLoading: true, errorMessage: "")
        case ForecastStateAction.didReceiveData(forecasts: let data):
            return ForecastState(forecasts: data, isLoading: false, errorMessage: "")
        case ForecastStateAction.didReceiveError(message: let message):
            return ForecastState(forecasts: [], isLoading: true, errorMessage: message)
        default:
            return state
        }
    }

}

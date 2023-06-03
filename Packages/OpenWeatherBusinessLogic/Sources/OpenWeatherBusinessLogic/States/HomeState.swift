//
//  File.swift
//  
//
//  Created by Tạ Minh Quân on 07/05/2023.
//

import Foundation

public struct HomeState: Codable {
    public let cityName: String
    public let temp: Double
    public let humidity: Int
    public let isLoading: Bool
    public let errorMessage: String
    public let searchText: String
    public let iconURL: String
    public let isShowDetail: Bool
}

extension HomeState {
    public init() {
        cityName = ""
        temp = 0
        humidity = 0
        isLoading = false
        errorMessage = ""
        searchText = ""
        iconURL = ""
        isShowDetail = false
    }
    
    public static let mock = HomeState(cityName: "Test city", temp: 30, humidity: 80, isLoading: false, errorMessage: "", searchText: "", iconURL: "https://openweathermap.org/img/wn/04d@2x.png", isShowDetail: false)
}

public enum HomeStateAction: Action {
    case updateSearchWord(word: String)
    case didReceiveResponse(name: String, temp: Double, humidity: Int, iconURL: String)
    case didReceiveError(message: String)
}

extension HomeState {
    public static let reducer: Reducer<Self> = { state, action in
        switch action {
        case HomeStateAction.updateSearchWord(word: let word):
            return HomeState(cityName: state.cityName, temp: state.temp, humidity: state.humidity, isLoading: word.isEmpty ? false : true, errorMessage: state.errorMessage, searchText: word, iconURL: state.iconURL, isShowDetail: state.isShowDetail)
        case HomeStateAction.didReceiveResponse(name: let name, temp: let temp, humidity: let humidity, let iconURL):
            return HomeState(cityName: name, temp: temp, humidity: humidity, isLoading: false, errorMessage: "", searchText: state.searchText, iconURL: iconURL, isShowDetail: state.isShowDetail)
        case HomeStateAction.didReceiveError(message: let message):
            return HomeState(cityName: "", temp: 0, humidity: 0, isLoading: true, errorMessage: message, searchText: state.searchText, iconURL: "", isShowDetail: false)
        case ActiveScreenStateAction.showScreen(.forecast):
            return HomeState(cityName: state.cityName, temp: state.temp, humidity: state.humidity, isLoading: state.isLoading, errorMessage: state.errorMessage, searchText: state.searchText, iconURL: state.iconURL, isShowDetail: true)
        case ActiveScreenStateAction.dismissScreen(.forecast):
            return HomeState(cityName: state.cityName, temp: state.temp, humidity: state.humidity, isLoading: state.isLoading, errorMessage: state.errorMessage, searchText: state.searchText, iconURL: state.iconURL, isShowDetail: false)
        default:
            return state
        }
    }
}




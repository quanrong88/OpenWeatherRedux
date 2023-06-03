//
//  File.swift
//  
//
//  Created by Tạ Minh Quân on 14/05/2023.
//

import Foundation
import Combine
import OpenWeatherDataAccess

public extension Middlewares {
    typealias Location = (Double, Double)
    private static let weatherService = OpenWeatherService()
    private static var currentLocation: Location = (0, 0)
    private static var currentUnit: OpenWeatherDataAccess.Unit = .metric
    private static var currentName: String = ""
    private static var searchDebouncer = CurrentValueSubject<String, Never>("")
    
    static let openWeather: Middleware<AppState> = { state, action in
        switch action {
        case HomeStateAction.updateSearchWord(word: let word):
            guard !word.isEmpty else {
                return Empty().eraseToAnyPublisher()
            }
            searchDebouncer.send(completion: .finished)
            searchDebouncer = CurrentValueSubject<String, Never>(word)
            
            return searchDebouncer
                .debounce(for: word == "" ? 0.0 : 0.5, scheduler: RunLoop.main)
                .first()
                .flatMap { weatherService.getLocation(q: $0) }
                .mapError {
                    HomeViewError.network($0)
                }
                .tryMap { locations in
                    guard let location = locations.first else {
                        currentLocation = (0, 0)
                        currentName = ""
                        throw HomeViewError.locationNotFound
                    }
                    currentLocation = (location.lat, location.lon)
                    currentName = location.name
                    return location
                   
                }
                .flatMap { location in
                    return weatherService.getCurrentWeather(lat: location.lat, lon: location.lon, unit: currentUnit)
                        .mapError {
                            HomeViewError.network($0)
                        }
                }
                .map { rep in
                    var iconURL = ""
                    if let iconWeather = rep.weather.first?.icon {
                        iconURL = "https://openweathermap.org/img/wn/\(iconWeather)@2x.png"
                    }
                    return HomeStateAction.didReceiveResponse(name: currentName, temp: rep.main.temp, humidity: rep.main.humidity, iconURL: iconURL)
                }
                .catch({ error in
                    
                    return Just(HomeStateAction.didReceiveError(message: error.localizedDescription))
                })
                .ignoreError()
                .eraseToAnyPublisher()
                
        case ForecastStateAction.loadData:
            let dayTimePeriodFormatter = DateFormatter()
            dayTimePeriodFormatter.dateFormat = "hh:mm dd/MM/YYYY"
            return weatherService.getWeatherForecast(lat: currentLocation.0, lon: currentLocation.1, unit: currentUnit)
                .mapError {
                    HomeViewError.network($0)
                }
                .map { item -> [ForecastCellModel] in
                    return item.list.map { element -> ForecastCellModel in
                        let displayTempature = "Tempature: \(element.main.temp)\(currentUnit.displaySuffix())"
                        let diplayHumidity = "Humidity: \(element.main.humidity)"
                        var iconImage  = ""
                        if let iconWeather = element.weather.first?.icon {
                            iconImage = "https://openweathermap.org/img/wn/\(iconWeather)@2x.png"
                        }
                        let date = Date(timeIntervalSince1970: TimeInterval(element.dt))
                        let dateString = dayTimePeriodFormatter.string(from: date)
                        return ForecastCellModel(displayTempature: displayTempature, displayHumidity: diplayHumidity, displayIcon: iconImage, displayDateTime: dateString, dtTxt: element.dtTxt)
                    }
                }
                .map { ForecastStateAction.didReceiveData(forecasts: $0) }
                .catch({ error in
                    return Just(ForecastStateAction.didReceiveError(message: error.localizedDescription))
                })
                .ignoreError()
                .eraseToAnyPublisher()
        default:
            return Empty().eraseToAnyPublisher()
        }
    }
}

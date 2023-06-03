//
//  File.swift
//  
//
//  Created by Tạ Minh Quân on 13/05/2023.
//

import Foundation
import Moya
import CombineMoya
import Combine

public class OpenWeatherService {
    let provider = MoyaProvider<OpenWeatherAPI>(plugins:[
      NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
    ])
    
    public init() {}
    
    public func getLocation(q: String) -> AnyPublisher<LocationResponse, MoyaError>  {
        provider.requestPublisher(.getLocation(q: q)).map(LocationResponse.self)
    }
    
    public func getCurrentWeather(lat: Double, lon: Double, unit: Unit = .standard) -> AnyPublisher<CurrentWeatherResponse, MoyaError> {
        provider.requestPublisher(.getCurrentWeather(lat: lat, lon: lon, unit: unit)).map(CurrentWeatherResponse.self)
    }
    
    public func getWeatherForecast(lat: Double, lon: Double, unit: Unit = .standard) -> AnyPublisher<WeatherForecastResponse, MoyaError> {
        provider.requestPublisher(.get5DayForecast(lat: lat, lon: lon, unit: unit)).map(WeatherForecastResponse.self)
    }
}

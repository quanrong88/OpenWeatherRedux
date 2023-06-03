//
//  File.swift
//  
//
//  Created by Tạ Minh Quân on 27/03/2023.
//

import Foundation

public struct ForecastCellModel: Codable {
    public let displayTempature: String
    public let displayHumidity: String
    public let displayIcon: String
    public let displayDateTime: String
    public let dtTxt: String
}

extension ForecastCellModel: Identifiable {
    public static let mock = ForecastCellModel(displayTempature: "Temp: 25", displayHumidity: "Humidity: 80%", displayIcon: "https://openweathermap.org/img/wn/02d@2x.png", displayDateTime: "Now", dtTxt: "1234")
    
    public var id: String {
        return dtTxt
    }
}

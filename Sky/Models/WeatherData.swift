//
//  WeatherData.swift
//  Sky
//
//  Created by 夏忠胜 on 2019/1/23.
//  Copyright © 2019 MrXia. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let latitude: Double
    let longitude: Double
    let currently: CurrentWeather
    
    struct CurrentWeather: Codable {
        let time: Date
        let summary: String
        let icon: String
        let temperature: Double
        let humidity: Double
    }
}

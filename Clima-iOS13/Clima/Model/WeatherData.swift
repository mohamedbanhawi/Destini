//
//  WeatherData.swift
//  Clima
//
//  Created by Mohamed Elbanhawi on 18/7/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Decodable { // must use a decodable protocol
    
    let name: String
    
    let main: Main
    
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Float
}

struct Weather: Decodable {
    let id: Int
}


//
//  WeatherModel.swift
//  Clima
//
//  Created by Mohamed Elbanhawi on 18/7/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    
    // stored property
    let conditionId: Int
    let cityName: String
    let temp: Float
    
    // computed property
    var conditionName: String {
        return getConditionName(weatherID: conditionId)
    }
    
    var tempratureString: String {
        return String(format: "%2.1f", temp)
    }
    
    func getConditionName(weatherID: Int) -> String {
        
        switch weatherID {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}

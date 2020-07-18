//
//  WeatherManager.swift
//  Clima
//
//  Created by Mohamed Elbanhawi on 18/7/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//
import Foundation

// convetion is to create protocol in the same file as the Class that will use it
protocol WeatherManagerDelegate {

    func didUpdateWeather(_ weather: WeatherModel)
    
    func didFailWithError(_ error: Error)
    
}


struct WeatherManager {
    
    // must use an https session
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=4ee1d0d49a0fe9f98625bc3598f20ca0&units=metric"
    
    var weatherDelegate: WeatherManagerDelegate?
    
    func fetchWeatherByName(cityName: String) {
        
        let urlString = "\(weatherURL)&q=\(cityName)"
        
        performRequest(with: urlString)
    }
    
    func fetchWeatherByCoordinate(lat:Double, lon: Double) {
        
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(lon)"
        
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String)
    {
        // 1. Create URL Object
        if let url = URL(string: urlString) {
            
            // 2. URL sessions (analgous to a broswer)
            let session = URLSession(configuration: .default)
            
            // 3. Give the session a task
            // takes a handler as a parameter
            //            let task = session.dataTask(with: url, completionHandler: handle(data: response: error:))
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    self.weatherDelegate?.didFailWithError(error!)
                }
                
                if let safeData = data {
    
                    if let weather = self.parseJSON(safeData) {
                        
                        self.weatherDelegate?.didUpdateWeather(weather)
                        
                    }// called inside a closure. Excplicit self is required
                }
            }
            
            //4. Start the task (they start in a suspended state
            task.resume()
            
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        
        let decoder = JSONDecoder()
        
        do {
            let weatherDecoded = try decoder.decode(WeatherData.self, from: weatherData)
            
            let weather = WeatherModel(
                conditionId: weatherDecoded.weather[0].id,
                cityName: weatherDecoded.name,
                temp: weatherDecoded.main.temp)
            
            return weather


        } catch {
            print(error)
            self.weatherDelegate?.didFailWithError(error)
            return nil
        }
    }
}

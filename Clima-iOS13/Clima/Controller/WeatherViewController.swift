//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        // the text field should report back to the view controller
        searchTextField.delegate = self
        weatherManager.weatherDelegate = self
    }
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        locationManager.requestLocation()

    }
}

// MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        
    }
    
    // user pressed return ok ?
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    
    // validation
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if searchTextField.text != "" {
            return true
        }
        searchTextField.placeholder = "Type something"
        return false
    }
    
    // return allowed
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        // search for weather in that city
        if let city = searchTextField.text {
            weatherManager.fetchWeatherByName(cityName: city)
        }
    }
}

// MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weather: WeatherModel) {
        
        // need to use a dispatch queue, this method is called from a networking completion handler
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.tempratureString
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }
    }
    
    func didFailWithError(_ error: Error) {
        
        print(error)
        
    }
}

// MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let currentLocation = locations.last {
            
            locationManager.stopUpdatingLocation()
            weatherManager.fetchWeatherByCoordinate(lat: currentLocation.coordinate.latitude,
                                                    lon: currentLocation.coordinate.longitude)
        }
    }
    
    func  locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}


//
//  Weather View Model.swift
//  Weather App
//
//  Created by Mahdi on 11/2/23.
//

import Foundation
import WidgetKit

class WeatherViewModel {
    
    private var weatherItems: [WeatherItem] = []
    private var errorMessage: String = ""
    let weatherTableViewCellReuse: String = "WeatherTableViewCell"
    private var weatherCache: [String:[WeatherItem]] = [:]

     
    func fetchWeatherData(_ city: String, completion: @escaping () -> Void) {
        
        weatherItems = []
        errorMessage = ""
        //no need to parse data in case on empty text.
        guard !city.trimmingCharacters(in: .whitespaces).isEmpty else {
            completion()
            return
        }
        
        //Code can use in case we need to load the cache if its already saved per Session scenario.
        /*if let cachedData = weatherCache[city] {
            weatherItems = cachedData
            completion()
            return
        }*/
        
        // Check if the data is cached for the city
        if let cachedData = loadCachedData(city) {
            weatherItems = cachedData
            completion()
            return
        }
        //No cache found so call the openWeather API
        WeatherService.shared.fetchWeatherData(for: city) { [weak self] result in
            switch result {
            case .success(let items):
                self?.weatherItems = items
                // Cache data for future use
                self?.saveDataToCache(items,city)
                //if we need to save cache per Session scenario
                /*self?.weatherCache[city] = items*/
            case .failure(let error):
                switch error {
                case .cityNotFound:
                    self?.errorMessage = "City not found"
                case .networkError:
                    self?.errorMessage = "Network error"
                case .other(let message):
                    self?.errorMessage = message
                }
            }
            completion()
        }
    }
    
    //access the weather Items Array
    func getWeatherData() -> [WeatherItem] {
        return weatherItems
    }
    
    //User Selection: get the selected weather Item
    func selectWeatherItem(_ index: Int) -> WeatherItem {
        return weatherItems[index]
    }
    
    
    func getWeatherErrorMessage() -> String{
        return errorMessage
    }
    
    //Weather Widget Extension sharedDefaults Item Update -- user Select a Weather Item from table Data
    func updateWeatherWidget(_ weatherWidgetItem:WeatherItem){
        if let sharedData = try? JSONEncoder().encode(weatherWidgetItem) {
            let sharedDefaults = UserDefaults(suiteName: "weatherWidget.com.weatherapp")
            sharedDefaults?.set(sharedData, forKey: "SharedWeatherData")
            sharedDefaults?.synchronize()
            WidgetCenter.shared.reloadTimelines(ofKind: "WeatherWidget")
        }
    }
    
    // Load cached data
    private func loadCachedData(_ city: String) -> [WeatherItem]? {
        if let data = UserDefaults.standard.data(forKey: "Weather_\(city)"),
            let decodedData = try? JSONDecoder().decode([WeatherItem].self, from: data) {
            return decodedData
        }
        return nil
    }
    
    // Save data to UserDefaults cache
    private func saveDataToCache(_ data: [WeatherItem],_ city: String) {
        if let encodedData = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encodedData, forKey: "Weather_\(city)")
        }
    }
}

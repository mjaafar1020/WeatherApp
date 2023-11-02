//
//  Weather Response.swift
//  Weather App
//
//  Created by Mahdi on 11/2/23.
//

import Foundation

//structure for handling succeed URLSession task
struct WeatherResponseList: Codable {
    let list:[WeatherResponse]
}
struct WeatherResponse: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}
struct Main: Codable {
    let temp,temp_max,temp_min: Double
}
struct Weather: Codable {
    let description,icon: String
    var iconURL: URL {
        //URL used according to the openWeather API docum.
        return URL(string:"https://openweathermap.org/img/wn/\(icon)@4x.png")!
    }
}

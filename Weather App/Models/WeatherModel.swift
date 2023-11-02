//
//  Weather Model.swift
//  Weather App
//
//  Created by Mahdi on 11/2/23.
//

import Foundation

//Weather Model . used also in Weather Widget.
struct WeatherItem:Codable {
    let city,description,temperature,maxTemperature,minTemperature: String
    let iconURL: URL
}

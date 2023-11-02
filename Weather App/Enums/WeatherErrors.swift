//
//  Weather Errors.swift
//  Weather App
//
//  Created by Mahdi on 11/2/23.
//

import Foundation

//Weathre Service Error Cases
enum WeatherError: Error {
    case cityNotFound
    case networkError
    case other(String)
}

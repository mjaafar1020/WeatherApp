//
//  Double - Extensions.swift
//  Weather App
//
//  Created by Mahdi on 11/2/23.
//

import Foundation

extension Double{
    //kelvin Tempreture To Celsius in string format
    func tempToString() -> String{
        let kelvinToCelsius = Int(self - 273.15)
        return "\(kelvinToCelsius)°C"
    }
}

//
//  WeatherTableViewCell.swift
//  Weather App
//
//  Created by Mahdi on 11/2/23.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var cityTempreture: UILabel!
    @IBOutlet weak var cityName: UILabel!
    
    //configure weatherCell via weatherItem
    func configure(_ weatherItem: WeatherItem) {
        cityName.text = weatherItem.city
        cityTempreture.text = "\(weatherItem.temperature)"
    }
    
}

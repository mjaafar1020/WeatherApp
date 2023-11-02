//
//  WeatherDetailViewController.swift
//  Weather App
//
//  Created by Mahdi on 11/2/23.
//

import UIKit

class WeatherDetailViewController: UIViewController {

    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityTemp: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    
    var selectedWeatherItem: WeatherItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure your detail view using the data from weatherItem.
        if let weatherItem = selectedWeatherItem {
           fillWeatherDetails(weatherItem)
        }
    }

    private func fillWeatherDetails(_ weatherItem:WeatherItem){
        cityName.text = weatherItem.city
        weatherDescription.text = weatherItem.description
        cityTemp.text = "\(weatherItem.temperature)"
        maxTemp.text = "H:\(weatherItem.maxTemperature)"
        minTemp.text = "L:\(weatherItem.minTemperature)"
        weatherIcon.image = UIImage(named: "placeholder")
        DispatchQueue.global(qos: .background).async {
         if let imageData = try? Data(contentsOf: weatherItem.iconURL) {
                if let image = UIImage(data: imageData) {
                    // Update UI 
                    DispatchQueue.main.async { [weak self] in
                        self?.weatherIcon.image = image
                    }
                }
            }
        }
    }
}

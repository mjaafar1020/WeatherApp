//
//  Weather Service.swift
//  Weather App
//
//  Created by Mahdi on 11/2/23.
//

import Foundation

class WeatherService {
    //can also use the below openWeatherAPILink accr. to the openweather API docum. -- but it always return single weather Item
    /*https://api.openweathermap.org/data/2.5/weather?*/
    
    static let shared = WeatherService()
    private let apiKey = "243ad480bae2af9857caaa7a1aa53ccf"
    private let openWeatherAPILink = "https://api.openweathermap.org/data/2.5/find?"
    private var currentDataTask: URLSessionDataTask?

    func fetchWeatherData(for city: String, completion: @escaping (Result<[WeatherItem], WeatherError>) -> Void){
        // 1st Cancel ongoing tasks
        currentDataTask?.cancel()
        
        let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "\(openWeatherAPILink)q=\(encodedCity)&appid=\(apiKey)"
        //check for valid openweather API Url
        guard let url = URL(string: urlString) else {
            completion(.failure(.other("Invalid URL")))
            return
        }
        //generate a task
        currentDataTask = URLSession.shared.dataTask(with: url) {[weak self] (data, response, error) in
            guard self != nil else { return }
            if let error = error as? URLError, error.code == URLError.cancelled {
               //task was cancelled
               return
            }
            //Call Error detection
            if error != nil {
                completion(.failure(.networkError))
                return
            }
            //openWeather API 400 case. can return city not found
            guard let data = data,let response = try? JSONDecoder().decode(WeatherResponseList.self, from: data) else {
                completion(.failure(.cityNotFound))
                return
            }
            //No Errors . city data found . parse response
            let weatherItems = response.list.map { item in
                return WeatherItem(city: item.name, description: item.weather.first?.description ?? "N/A", temperature: item.main.temp.tempToString(),maxTemperature:item.main.temp_max.tempToString(),minTemperature:item.main.temp_min.tempToString(),iconURL: item.weather.first?.iconURL ?? URL(string: "https://via.placeholder.com/128?text=Icon+Not+Found")!)
            }
            //if theres not items . can return no city found as result
            weatherItems.count > 0 ? completion(.success(weatherItems)) : completion(.failure(.cityNotFound))
        }
        currentDataTask?.resume()
    }
}

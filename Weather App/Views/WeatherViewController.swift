//
//  WeatherViewController.swift
//  Weather App
//
//  Created by Mahdi on 11/2/23.
//

import UIKit

class WeatherViewController: UIViewController,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var weatherTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
   
    private let weatherViewModel = WeatherViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        //register weather table view
        weatherTableView.register(UINib(nibName: weatherViewModel.weatherTableViewCellReuse, bundle: .main), forCellReuseIdentifier: weatherViewModel.weatherTableViewCellReuse)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //fetch to get data from openweather according to user input
        weatherViewModel.fetchWeatherData(searchText) { [weak self] in
            DispatchQueue.main.async {
                //update user Interface.
                self?.updateUI()
            }
        }
    }
    
    
    private func updateUI() {
        //check if weather Item found, or error message
        guard weatherViewModel.getWeatherData().count != 0 || !weatherViewModel.getWeatherErrorMessage().isEmpty else{
            self.errorLabel.isHidden = true
            self.weatherTableView.isHidden = true
            return
        }
        
        //show weather items
        if(weatherViewModel.getWeatherData().count > 0){
            self.weatherTableView.isHidden = false
            self.errorLabel.isHidden = true
            weatherTableView.reloadData()
            
        }else if (!weatherViewModel.getWeatherErrorMessage().isEmpty){// error Case
            self.weatherTableView.isHidden = true
            self.errorLabel.isHidden = false
            self.errorLabel.text = weatherViewModel.getWeatherErrorMessage()
        }
        /* We can show error also via alert Dialog*/
    }
    
    // Implement WeatherTableView methods.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherViewModel.getWeatherData().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: weatherViewModel.weatherTableViewCellReuse, for: indexPath) as! WeatherTableViewCell
        let weather = weatherViewModel.getWeatherData()[indexPath.row]
        cell.configure(weather)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let weatherItem = weatherViewModel.selectWeatherItem(indexPath.row)
        weatherViewModel.updateWeatherWidget(weatherItem)
        let weatherDetailVC = storyboard?.instantiateViewController(withIdentifier: "WeatherDetailViewController") as! WeatherDetailViewController
        weatherDetailVC.selectedWeatherItem = weatherItem
        // Present Weather Details controller.
        self.present(weatherDetailVC, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }

}

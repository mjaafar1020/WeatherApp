//
//  WeatherWidget.swift
//  WeatherWidget
//
//  Created by Mahdi on 11/2/23.
//

import WidgetKit
import SwiftUI

@main
struct WeatherWidget: Widget {
    let kind: String = "WeatherWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WeatherWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Weather Widget")
        .description("Display weather")
    }
}

struct WeatherWidgetEntry: TimelineEntry {
    let date: Date
    let temperature,city,description: String
    let iconURL:URL
}

struct Provider: TimelineProvider {
    typealias Entry = WeatherWidgetEntry

    func placeholder(in context: Context) -> WeatherWidgetEntry {
        defaultContent()
    }
    
    func getSnapshot(in context: Context, completion: @escaping (WeatherWidgetEntry) -> ()) {
        // Return a entery accor. to the phone region country
        fetchEntryData(for: getCountryName()) { (entryResult) in
            completion(entryResult)
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<WeatherWidgetEntry>) -> Void) {
        var entries: [WeatherWidgetEntry] = []
        let currentDate = Date()
        //check if theres saved weather widget item
        if let sharedDefaults = UserDefaults(suiteName: "weatherWidget.com.weatherapp"),
            let sharedData = sharedDefaults.data(forKey: "SharedWeatherData"),
            let weatherData = try? JSONDecoder().decode(WeatherItem.self, from: sharedData) {
            let entry = WeatherWidgetEntry(date: currentDate, temperature: weatherData.temperature, city: weatherData.city, description: weatherData.description, iconURL: weatherData.iconURL)
            entries.append(entry)
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        } else {
            //if theres no saved widget Item -- Return a entery accor. to the phone region country
            fetchEntryData(for: getCountryName()){ entryResult in
                entries.append(entryResult)
                let timeline = Timeline(entries: entries, policy:.atEnd)
                completion(timeline)
            }
        }
    }
}


struct WeatherWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        // Display weather data in the widget
        VStack {
            Text(entry.city)
            Text(entry.description)
                .font(.custom("HelveticaNeue-BoldItalic", size: 12))
            Spacer()
            Text("\(entry.temperature)")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .font(.custom("HelveticaNeue-BoldItalic", size: 22))
        .foregroundColor(.black)
        .padding()
        .lineLimit(2)
        .minimumScaleFactor(0.5)
        .background(
            Image("placeholder")
                .data(url: entry.iconURL)
                .resizable()
                .scaledToFit()
                .opacity(0.7)
        )
    }
}

private func defaultContent() -> WeatherWidgetEntry {
    return WeatherWidgetEntry(
        date: Date(),
      temperature: "Temp °C",
      city: "Weather App", description: "",
      iconURL: URL(string: "iconPlaceHolderURL")!
    )
}

private func getCountryName() -> String {
    if let locale = Locale.current.regionCode {
        let countryName = Locale.current.localizedString(forRegionCode: locale)
        return countryName ?? ""
    } else {
        return ""
    }
}

private func fetchEntryData(for city:String,completion: @escaping (WeatherWidgetEntry) -> Void) {
    var entry = defaultContent()
    let currentDate = Date()
    //select 0 index from the items . unless change the VStack in the body to show list of items
    WeatherService.shared.fetchWeatherData(for: getCountryName()) { result in
        switch result {
        case .success(let items):
            entry = WeatherWidgetEntry(date: currentDate, temperature: items[0].temperature, city: items[0].city, description: items[0].description, iconURL: items[0].iconURL)
            completion(entry)
        case .failure( _):
            //show default Entry
            completion(entry)
        }
    }
}

struct WeatherWidget_Previews: PreviewProvider {
    static var previews: some View {
        WeatherWidgetEntryView(entry: defaultContent())
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        }
}


extension Image {
    func data(url:URL) -> Self {
    if let data = try? Data(contentsOf: url) {
        return Image(uiImage: UIImage(data: data)!)
    }
        return Image("placeholder")
    }
}


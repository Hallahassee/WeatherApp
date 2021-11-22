//
//  RealWeatherModel.swift
//  Weather App
//
//  Created by Егор Пашкевич on 03.11.2021.
//

import Foundation

protocol RealWeatherModelProtocol {
    
    var town: String {get set}
    var description: String {get}
    var tempMax: Int {get}
    var tempMin: Int {get}
    var temp: Int {get}
    var id: Int {get}
    var icon: String {get}
    var lon: Double {get}
    var lat : Double {get}
     func changeName(_ newName: String) -> RealWeatherModel
    init(withModel model : NetworkWeatherDataProtocol)
    init (withModel model : NetworkWeatherDataProtocol, andName name: String)
    init?()
}


struct RealWeatherModel : RealWeatherModelProtocol {

    
    
     func changeName(_ newName: String) -> RealWeatherModel {
       var newData = self
        newData.town = newName
        return newData
    }
    

    
    init(withModel model: NetworkWeatherDataProtocol, andName name: String) {
       
        let currentMoodel = model as! TownWeather

            self.town = name
            self.description = currentMoodel.weather[0].description!
            self.icon = currentMoodel.weather[0].icon!
            self.feelsLike = currentMoodel.main.feelsLike
            self.humidity = currentMoodel.main.humidity
            self.pressure = currentMoodel.main.pressure
            self.temp = Int(currentMoodel.main.temp)
            self.tempMax = Int(currentMoodel.main.tempMax)
            self.tempMin = Int(currentMoodel.main.tempMin)
            self.id = currentMoodel.id
        self.lat = currentMoodel.coord.lat
        self.lon = currentMoodel.coord.lon
    }
    
 
    
    
 
    var lon: Double
    var lat: Double
    var town: String
    var description: String
    var icon: String
    var feelsLike: Double
    var humidity: Double
    var pressure: Double
    var temp: Int
    var tempMax: Int
    var tempMin: Int
    var id: Int

    
  
    init?() {
        return nil
    }
    
 
init(withModel model : NetworkWeatherDataProtocol) {
let currentMoodel = model as! TownWeather

    self.town = currentMoodel.name!
    self.description = currentMoodel.weather[0].description!
    self.icon = currentMoodel.weather[0].icon!
    self.feelsLike = currentMoodel.main.feelsLike
    self.humidity = currentMoodel.main.humidity
    self.pressure = currentMoodel.main.pressure
    self.temp = Int(currentMoodel.main.temp)
    self.tempMax = Int(currentMoodel.main.tempMax)
    self.tempMin = Int(currentMoodel.main.tempMin)
    self.id = currentMoodel.id
    self.lat = currentMoodel.coord.lat
    self.lon = currentMoodel.coord.lon
    }

}

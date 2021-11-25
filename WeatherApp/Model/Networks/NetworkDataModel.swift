//
//  NetworkDataModel.swift
//  Weather App
//
//  Created by Егор Пашкевич on 03.11.2021.
//

import Foundation


protocol NetworkWeatherDataProtocol: Decodable {
    
}
//
//"coord": {
//    "lon": -122.08,
//    "lat": 37.39
//  },
public struct Coord : Decodable {
    var lon: Double
    var lat: Double
 
}

public struct NetworkWeatherData: NetworkWeatherDataProtocol {
    var list: [TownWeather]
    
}

public struct TownWeather : NetworkWeatherDataProtocol {
    var main : Main
    var weather : [Weather]
    var name : String?
    var id : Int
    var coord: Coord
    
}


public struct Weather : Decodable {
    var description: String?
    var icon: String?
}

public struct Main: Decodable {
var feelsLike: Double
var humidity: Double
var pressure: Double
var  temp: Double
var tempMax: Double
var  tempMin: Double
}





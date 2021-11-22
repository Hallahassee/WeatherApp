//
//  WeatherDataFletcher.swift
//  Weather App
//
//  Created by Егор Пашкевич on 02.11.2021.
//

//public struct Weather : Decodable {
//    var description: String?
//    var icon: String?
//}
//
//public struct Main: Decodable {
//var feelsLike: Double
//var humidity: Double
//var pressure: Double
//var  temp: Double
//var tempMax: Double
//var  tempMin: Double
//}

import Foundation
import UIKit
 protocol WeatherOfTownProtocol {
    var desription : String {get}
    var icon: UIImage {get}
    var feelLike: Double {get}
    var humidity: Double {get}
    var pressure : Double {get}
    var temp: Double {get}
    var tempMax: Double {get}
    var tempMin: Double {get}
    var town: String {get}
    func townFromModel(_ model: NetworkWeatherDataProtocol, _ town : String) -> WeatherOfTownProtocol
}

public struct WeatherOfTown: WeatherOfTownProtocol {
    func townFromModel(_ model: NetworkWeatherDataProtocol, _ town: String) -> WeatherOfTownProtocol {
        WeatherOfDataFletcher.getWeatherForTown(forTown: town, model.self, <#T##completion: (NetworkWeatherDataProtocol) -> Void##(NetworkWeatherDataProtocol) -> Void#>)
        
        
        
        
    }
    
  
    
    

    
    
    var town: String
   
    var desription: String
    
    var icon: UIImage
    
    var feelLike: Double
    
    var humidity: Double
    
    var pressure: Double
    
    var temp: Double
    
    var tempMax: Double
    
    var tempMin: Double
        
    }
    
    


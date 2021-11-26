//
//  WeatherAnnotationPoint.swift
//  WeatherAppV2
//
//  Created by Егор Пашкевич on 25.11.2021.
//

import Foundation
import MapKit

public class WeatherAnnorationPoint: MKPointAnnotation, WeatherDescriptorsProtocol {
    
    var imageID: String?
    var placeStatus : Bool = false
    var isCurrentPlace : Bool = false {
        willSet {
            if newValue == true {self.subtitle? += " Вы здесь!"}
        }
    }
    
    func setTemp(_ model : RealWeatherModelProtocol) {
        self.title = model.town
        let temp = model.temp
        if temp > 0 {
            self.subtitle = "+\(temp)°C"
        } else {
            self.subtitle = "\(temp)°C"
        }
        self.imageID = model.icon
    }
}

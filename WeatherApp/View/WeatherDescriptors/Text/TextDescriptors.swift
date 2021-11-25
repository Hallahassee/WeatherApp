//
//  TextDescriptors.swift
//  WeatherAppV2
//
//  Created by Егор Пашкевич on 17.11.2021.
//

import Foundation
import UIKit
import MapKit






class TextWeatherDescriptor: UILabel, WeatherDescriptorsProtocol {
    func setTemp(_ model: RealWeatherModelProtocol) {
        self.layer.shadowOpacity = 0.25
        self.textColor = .white
        self.shadowOffset = CGSize(width: 2, height: 2)
    }

}

class TextWeatherDescription: TextWeatherDescriptor {
    override func setTemp(_ model: RealWeatherModelProtocol) {
        self.text = model.description
        super.setTemp(model)
    }
    
    
    

    
}

class TownName: TextWeatherDescriptor {
    override func setTemp(_ model: RealWeatherModelProtocol) {
        self.text = model.town
        super.setTemp(model)

    }
    
    
}


class TempLabel: TextWeatherDescriptor {

 override  func setTemp(_ model: RealWeatherModelProtocol ) {
        let temp = model.temp
        if temp > 0 {
            self.text = "+\(temp)°C"
        } else {
            self.text = "\(temp)°C"
        }
    super.setTemp(model)

    }
}
    
class MaxAndMinlabel : TextWeatherDescriptor {
    override func setTemp(_ model: RealWeatherModelProtocol) {
        var max = ""
        var min = ""

        if  model.tempMax > 0 { max =  "+\(model.tempMax)°C"}
        else {
            max =  "\(model.tempMax)°C"
        }
        
        if  model.tempMin > 0 { min =  "+\(model.tempMin)°C"}
        else {
            min =  "\(model.tempMax)°C"
        }
        self.text = "максимальая \(max) \nминимальная \(min)"
        super.setTemp(model)

    }

    }
    
       
  
    
    
    class FeelsLikeLabel : TextWeatherDescriptor {
     override   func setTemp(_ model: RealWeatherModelProtocol) {
            let temp = model.temp

            if temp > 0 {
                self.text = "ощущается как +\(temp)°C"
            } else {
                self.text = "ощущается как \(temp)°C"
            }
        super.setTemp(model)

        }
        
        
    }

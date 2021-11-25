//
//  ImageDescriptors.swift
//  WeatherAppV2
//
//  Created by Егор Пашкевич on 17.11.2021.
//

import Foundation
import UIKit

class WeatherImageDescription: UIImageView, WeatherDescriptorsProtocol {
    
    
     func setTemp (_ model: RealWeatherModelProtocol) {
        
        let indicator = UIActivityIndicatorView()
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        self.addSubview(indicator)
        
        
        
        
        
        WeatherDownloader.getImage(model.icon) { [weak self ] data in
            DispatchQueue.main.async {
                guard let data = data else {return}
                let image  = UIImage(data: data)
                self?.image = image
                indicator.stopAnimating()
            }
     
            }
            
        
    }
}
class WeatherBackGroindImage: WeatherImageDescription {
    override func setTemp (_ model: RealWeatherModelProtocol) {
       var id = ""
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.startAnimating()
        activityIndicator.frame = self.bounds
        activityIndicator.backgroundColor = .white
        self.bringSubviewToFront(activityIndicator)
        activityIndicator.hidesWhenStopped = true
        
        switch model.icon {
        case "01d", "01n" : id = "ClearSky"
        case "02d", "02n" , "03d", "03n", "04d", "04n" : id = "FewClouds"
        case "09d", "09n", "10d", "10n" : id = "Rain"
        case "11d", "11n" : id = "ThunderStrorm"
        case "13d", "13n" : id = "Snow"
        default : id = "Rain"
        }
        self.image = UIImage(named: id)
        self.setNeedsDisplay()
        activityIndicator.stopAnimating()
        }

        
            
}



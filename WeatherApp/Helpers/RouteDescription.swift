//
//  RouteDescription.swift
//  WeatherAppV2
//
//  Created by Егор Пашкевич on 25.11.2021.
//

import Foundation
import MapKit

extension MKRoute {
    func distDescription() -> Float {
      Float(self.distance / Double(1000))
    }
    
    func timeDescription() -> String {
        let dataFormatter = DateComponentsFormatter()
        dataFormatter.allowedUnits = [.hour, .minute]
        dataFormatter.unitsStyle = .abbreviated
        dataFormatter.maximumUnitCount = 2
        return dataFormatter.string(from: self.expectedTravelTime)!
        
    }
    
}

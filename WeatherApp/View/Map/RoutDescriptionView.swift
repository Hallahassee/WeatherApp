//
//  RoutDescriptionView.swift
//  WeatherAppV2
//
//  Created by Егор Пашкевич on 25.11.2021.
//

import UIKit
import MapKit

class RoutDescriptionView: UIView {
  
    
    
    var indicator = UIActivityIndicatorView()

    override init(frame: CGRect) {
        super .init(frame: frame)

        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    

    func startSetup() {
        self.addSubview(indicator)
        self.bringSubviewToFront(indicator)
        indicator.startAnimating()
        let dist = self.viewWithTag(1) as! UILabel
        let time = self.viewWithTag(2) as! UILabel
        dist.text = ""
        time.text = ""
        indicator.frame = self.bounds

        self.isHidden = false
        
    }
    
    
    func finishSetupWithRoute(_ route: MKRoute) {
        
        let dist = self.viewWithTag(1) as! UILabel
        let time = self.viewWithTag(2) as! UILabel
     
        dist.text = "Расстояние: \(route.distDescription()) киллометров"
        time.text = "Время в пути: \(route.timeDescription())"
        indicator.stopAnimating()
    
    }
    
    func finishwithError(){
        indicator.stopAnimating()
        let dist = self.viewWithTag(1) as! UILabel
        let time = self.viewWithTag(2) as! UILabel
        time.text = nil
        dist.text = "Сюда не проехать на машине"
    }
    


    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.

}

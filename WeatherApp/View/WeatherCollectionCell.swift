//
//  WeatherCollectionCell.swift
//  WeatherAppV2
//
//  Created by Егор Пашкевич on 22.11.2021.
//

import UIKit

class WeatherCollectionCell: UICollectionViewCell, ViewDescriptorsProtocol {
    
    override var isSelected: Bool {
        didSet {
            if oldValue == false {
            name.textColor = .black
            temp.textColor = .black
            self.backgroundColor = .white
            self.backgroundColor = self.backgroundColor?.withAlphaComponent(0.3)
            } else {
                self.backgroundColor = .black
                self.backgroundColor = self.backgroundColor?.withAlphaComponent(0.12)
            }
            
            }
}
    
     var currentTownCell : Bool = false {
        didSet {
            if oldValue == false {
            self.backgroundColor = .white
            name.textColor = .black
            temp.textColor = .black
            }
            }
}
    
    
    

    
    
    func setTemp(_ model: RealWeatherModelProtocol) {
        weatherIcon.setTemp(model)
        name.setTemp(model)
        temp.setTemp(model)
        self.backgroundColor = .black
        self.backgroundColor = self.backgroundColor?.withAlphaComponent(0.12)
        

    }
    

    @IBOutlet weak var weatherIcon: WeatherImageDescription!
    @IBOutlet weak var name: TownName!
    @IBOutlet weak var temp: TextWeatherDescription!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10

    }

}

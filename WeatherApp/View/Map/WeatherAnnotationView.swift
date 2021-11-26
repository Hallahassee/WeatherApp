//
//  WeatherAnnotationView.swift
//  WeatherAppV2
//
//  Created by Егор Пашкевич on 25.11.2021.
//

import UIKit
import MapKit


public protocol WeatherAnnotationViewDelegeteProtocol : UIViewController {
    func moreInfoTapped()
    func routeShowTapped(toAnnotation annotation : WeatherAnnorationPoint)
}




class WeatherAnnotationView: MKAnnotationView {
   
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
      
        guard let annotation = annotation as? WeatherAnnorationPoint else {return}
        self.canShowCallout = true

        
        let tempText = UILabel()
        tempText.text = annotation.subtitle
        tempText.textAlignment  = .left
    
        
        
        let button1 = UIButton()
        
        let color = UIColor.blue
        
        button1.setTitle("Подробнее", for: .normal)
        button1.setTitleColor(color, for: .normal)
        button1.backgroundColor = UIColor.clear
        button1.contentHorizontalAlignment = .left
        button1.setTitleColor(color.withAlphaComponent(0.5), for: .highlighted)

        button1.addTarget(self, action: #selector(button1Tupped), for: .touchUpInside)
        

        let button2 = UIButton()
        button2.setTitle("Построить маршрут", for: .normal)
        button2.setTitleColor(color, for: .normal)
        button2.backgroundColor = UIColor.clear
        button2.setTitleColor(color.withAlphaComponent(0.5), for: .highlighted)
        button2.contentHorizontalAlignment = .left
        if annotation.isCurrentPlace {button2.isHidden = true}
        button2.addTarget(self, action: #selector(button2Tupped), for: .touchUpInside)

    let arrangedSubviews = [tempText, button1,button2]
    let stackView = UIStackView(arrangedSubviews: arrangedSubviews)

    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    stackView.alignment = .leading
    stackView.spacing = 5

    stackView.translatesAutoresizingMaskIntoConstraints = false

                
//        imageView.layer.cornerRadius = imageView.frame.size.width / 2
//        imageView.layer.masksToBounds = true
//        imageView.layer.borderWidth = 2
//        imageView.layer.borderColor = UIColor.brown.cgColor
        
        let rightButton = UIButton(type: .contactAdd)
        rightButton.tag = 1
        
        
        WeatherDownloader.getImage(annotation.imageID!, { [weak self] data in
            
            DispatchQueue.main.async {
                guard let data = data else {return}
                self?.image = UIImage(data: data)
                            
                
                self?.detailCalloutAccessoryView = stackView
                self?.rightCalloutAccessoryView = rightButton
                
            }
        })
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var delegate : WeatherAnnotationViewDelegeteProtocol?
    
    @objc func button1Tupped() {
        delegate?.moreInfoTapped()
        
    }
    
    @objc func button2Tupped(){
        delegate?.routeShowTapped(toAnnotation: self.annotation as! WeatherAnnorationPoint)
    }
    
    
 

    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */



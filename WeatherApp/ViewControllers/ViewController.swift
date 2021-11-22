//
//  ViewController.swift
//  WeatherAppV2
//
//  Created by Егор Пашкевич on 17.11.2021.
//

import UIKit
import MapKit

class BasedViewController: UIViewController {

var backGroundView = WeatherBackGroindImage()
var storage = TownsStorage.shared
var currentPickedTown: RealWeatherModelProtocol?
var closure: ((RealWeatherModelProtocol?) -> ())?
var activityIndicator = UIActivityIndicatorView()
    
    

    
    
    
    func reloadWeather(){
        
    if storage.count == 0 {self.noWeatherFound() ; return}
    if currentPickedTown == nil {self.currentPickedTown = self.storage.allTowns.first}
    backGroundView.setTemp(currentPickedTown!)
    activityIndicator.stopAnimating()
    }
    
     func downloadInProgress() {
        activityIndicator.startAnimating()
        activityIndicator.frame = view.bounds
        activityIndicator.backgroundColor = .white
        view.addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = true
       }
    
    
    
func noWeatherFound(){}
    
    override func viewDidLoad() {
       
        
        downloadInProgress()
        view.backgroundColor = .black
        backGroundView.frame = view.bounds
        backGroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backGroundView.alpha = 0.7
        view.addSubview(backGroundView)
        view.sendSubviewToBack(backGroundView)
        
    }
}



//
//  ViewController.swift
//  WeatherAppV2
//
//  Created by Егор Пашкевич on 17.11.2021.
//

import UIKit
import MapKit

class BasedViewController: UIViewController {
// MARK: Vars
var backGroundView = WeatherBackGroindImage()
var storage = TownsStorage.shared
var currentPickedTown: RealWeatherModelProtocol?
var closure: ((RealWeatherModelProtocol?) -> ())?
var activityIndicator = UIActivityIndicatorView()
var locationManager = LocationManager()

    

    
    
    // MARK: Cuctom LifeCicle

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
    
    
    
func noWeatherFound(){

    let vcAlert = UIAlertController(title: "Городов нет!", message: "Давайте их найдем", preferredStyle: .alert)
   
    let one = UIAlertAction(title: "По названию", style: .default, handler: { _ in
        let vc = TownAddController()
        vc.closure = { [weak self ] town in
            DispatchQueue.main.async {
                self?.currentPickedTown = town
                self?.downloadInProgress()
                self?.reloadWeather()
            }
    }
        self.present(vc, animated: true, completion: nil)
    })
    let two = UIAlertAction(title: "Найти на карте", style: .default, handler: {_ in
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(identifier: "MapViewController") as! MapViewController
        vc.closure = {[weak self] data in
            self?.currentPickedTown = data
            self?.reloadWeather()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    })
    let thee = UIAlertAction(title: "По вашей локации", style: .default, handler: { _ in
        
        
        guard let location = self.locationManager.currentLocation else {return}
        let lat = location.latitude
        let lon = location.longitude

        self.storage.addTown(lat, lon){ [weak self ] data in
            guard let data = data else {return}
            DispatchQueue.main.async {
                self?.downloadInProgress()
                self?.storage.addTown(data)
                self?.currentPickedTown = data
                self?.reloadWeather()
            }
        }
    })
    
    vcAlert.addAction(one)
    vcAlert.addAction(two)
    vcAlert.addAction(thee)
    self.present(vcAlert, animated: true, completion: nil)
    
}
    // MARK: View LifeCicle

    override func viewDidLoad() {
        NetworkController.errorDelegete = self
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            locationManager.requestLocation()
        }
        
        
        downloadInProgress()
        view.backgroundColor = .black
        backGroundView.frame = view.bounds
        backGroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backGroundView.alpha = 0.7
        view.addSubview(backGroundView)
        view.sendSubviewToBack(backGroundView)
        
    }
}


// MARK: Location

extension BasedViewController : CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("error:: \(error.localizedDescription)")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if locations.first != nil {
            locationManager.currentLocation = locations.first?.coordinate
        }

    }

}
// MARK: ErrorHandling

extension BasedViewController: ErrorDelegetaProtocol {
    func networkError() {
        let alert = UIAlertController(title: "Проблемы с интернетом", message: "Проверьте ваше интернет-соеденение", preferredStyle: .alert)
        let actionOne = UIAlertAction(title: "Попробовать еще раз", style: .default, handler: {_ in self.reloadWeather()})
        let actionTwo = UIAlertAction(title: "Закрыть приложение" , style: .destructive) { _ in
            exit(0)
        }
        alert.addAction(actionOne)
        alert.addAction(actionTwo)
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

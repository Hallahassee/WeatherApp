//
//  ViewController.swift
//  Weather App
//
//  Created by Егор Пашкевич on 02.11.2021.
//

import UIKit
import MapKit

class WeatherShowController: BasedViewController {

    var mainMode: Bool = true
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    switch segue.identifier {
    case "ToAllTowns" :
        let next = segue.destination as? BasedViewController
        next?.currentPickedTown = self.currentPickedTown
        next?.closure = {[weak self] picked in
           
            guard let picked = picked else {
            self?.reloadWeather()
            return
            }
            self?.currentPickedTown = picked
            self?.reloadWeather()
        }
    case "toMap" :
        let next = segue.destination as? MapViewController
        next?.currentPickedTown = self.currentPickedTown
        
    default : return
    }
    }
    

   
    
    // MARK: actions
      @IBAction func toMap(_ sender: Any) {
performSegue(withIdentifier: "toMap", sender: self)
}
    @IBAction func geo(_ sender: Any) {
        guard let location = locationManager.currentLocation else {return}
        let lat = Float(location.latitude)
        let lon = Float(location.longitude)

        self.storage.addTown(lat, lon){ [weak self ] data in
            guard let data = data else {return}
            DispatchQueue.main.async {
                self?.downloadInProgress()
                self?.storage.addTown(data)
                self?.currentPickedTown = data
                self?.reloadWeather()
            }

        }
    }
    
    
    @IBOutlet  var buttonsStack: UIStackView!
    
    @IBAction func swipeDown(_ sender: Any) {

    
        self.downloadInProgress()
        self.storage.reloadAllTowns {
            self.reloadWeather()
        }
    }
    
    @IBAction func allTowns(_ sender: Any) {
        
       performSegue(withIdentifier: "ToAllTowns", sender: self)
    }
    
    
    
    @IBAction func addTown(_ sender: Any) {
        let vc = TownAddController()
        vc.closure = { [weak self ] town in
            self?.currentPickedTown = town
            self?.downloadInProgress()
            self?.reloadWeather()
        }
present(vc, animated: true, completion: nil)
        
    }
    
    
// MARK: Var and Outlets
   
    let locationManager = LocationManager()

    
    @IBOutlet var textDescriptors: [TextWeatherDescriptor]!
    

    
 // MARK: Custom LifeCicle
    
    

    

     override func downloadInProgress() {
        super.downloadInProgress()
        textDescriptors.forEach({$0.isHidden = true})
    }
    
    
    override func reloadWeather(){
        
        super .reloadWeather()
        guard  let town = self.currentPickedTown else {return}
        textDescriptors.forEach({$0.isHidden = false ; $0.setTemp(town)})
        }
        

    internal override func noWeatherFound(){
       
        let vc = TownAddController()
        vc.closure = {[weak self] data in
            
            self?.currentPickedTown = data
            self?.downloadInProgress()
            self?.reloadWeather()
        }
        present(vc, animated: true, completion: {
            self.downloadInProgress()})

        
    }

  // MARK: LifeCicle of View
   
    override func viewDidDisappear(_ animated: Bool) {
        storage.save()
        super .viewDidDisappear(animated)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        super.viewWillAppear(animated)
        if mainMode == false {buttonsStack.isHidden = true}

    }
    
    
    

    
    override func viewDidLoad() {
//        textDescriptors.forEach({$0.layer.shadowOpacity = 0.15; $0.textColor = .white ; $0.shadowOffset = CGSize(width: 2, height: 2)})
        super.viewDidLoad()

        if mainMode {locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            if CLLocationManager.locationServicesEnabled() {
                locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
                locationManager.requestLocation()
            }} else {
                reloadWeather()
            }


}


    override func loadView() {
        super.loadView()
        if mainMode {
            storage.load {  [weak self] done in
                
                    DispatchQueue.main.async {
                    self?.reloadWeather()
                                             }
                    
                

            
            }}
   
      
       
}
}


extension WeatherShowController : CLLocationManagerDelegate {

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

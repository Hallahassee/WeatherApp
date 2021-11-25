//
//  ViewController.swift
//  Weather App
//
//  Created by Егор Пашкевич on 02.11.2021.
//

import UIKit
import MapKit

class WeatherShowController: BasedViewController {

    // MARK: Segues

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
        self.textDescriptors.forEach({$0.isHidden = true})
        
        
        guard let location = locationManager.currentLocation else {return}
        let lat = location.latitude
        let lon = location.longitude
        
         if let town = storage.findTownByGeo(lat, lon) {
            currentPickedTown = town
            reloadWeather()
         }

        self.storage.addTown(lat, lon){ [weak self ] data in
            guard let data = data else {return}
            DispatchQueue.main.async {
                self?.storage.addTown(data)
                self?.currentPickedTown = data
                self?.reloadWeather()
            }

        }
    }
    
    
    @IBOutlet  var buttonsStack: UIStackView!
    

    
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
   
    var mainMode: Bool = true
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
        super.viewDidLoad()
        if mainMode == false {self.reloadWeather()}
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




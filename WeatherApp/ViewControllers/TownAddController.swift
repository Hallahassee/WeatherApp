//
//  ViewController.swift
//  WeatherAppV2
//
//  Created by Егор Пашкевич on 15.11.2021.
//



    import UIKit
    import GooglePlaces
    import MapKit


class TownAddController: GMSAutocompleteViewController {
   
    var storage: TownsStorageProtocol = TownsStorage.shared
    
    var closure: ((RealWeatherModelProtocol)->())?
    
    
    override func viewDidLoad() {
       

        super .viewDidLoad()
        
        delegate = self
        let fields: GMSPlaceField = GMSPlaceField(rawValue:UInt(GMSPlaceField.name.rawValue)|UInt(GMSPlaceField.coordinate.rawValue))
        
        
                self.placeFields = fields
        
                // Specify a filter.
                let filter = GMSAutocompleteFilter()
                filter.type = .city
                self.autocompleteFilter = filter
            
}
}

extension TownAddController: GMSAutocompleteViewControllerDelegate {

  // Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {

    
    storage.addTown(place.name!) { [weak self] town in
            DispatchQueue.main.async {
                guard let town = town else {self?.troubleDetected("Не получается добавить город"); return}
                self?.closure!(town)
                self?.dismiss(animated: true, completion: nil)
            }
        }
    
  }

  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

  // User canceled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    if storage.count == 0 {self.troubleDetected("Добавьте хотя бы один город")}
    dismiss(animated: true, completion: nil)
  }

  // Turn the network activity indicator on and off again.
  func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
  }

  func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
  }



func troubleDetected(_ message: String) {
    let alert = UIAlertController(title: "Что-то пошло не так", message: message, preferredStyle: .alert)
    let ok = UIAlertAction.init(title: "Попробовать еще раз", style: .default, handler: nil)
    alert.addAction(ok)
    present(alert, animated: true, completion: nil)
}
}

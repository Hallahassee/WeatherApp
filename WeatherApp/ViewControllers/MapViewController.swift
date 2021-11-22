//
//  MapViewController.swift
//  WeatherAppV2
//
//  Created by Егор Пашкевич on 18.11.2021.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate {
   
    var storage: TownsStorageProtocol = TownsStorage.shared
    var currentPickedTown: RealWeatherModelProtocol?
    var closure: ((RealWeatherModelProtocol?) -> ())?
    @IBOutlet weak var mapView: MKMapView!


    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        
        if view.annotation is WeatherAnnorationPoint {
            let annotation =  view.annotation as! WeatherAnnorationPoint
            switch control.tag {
        
            
            case 1 :
            
            
            let alert =  UIAlertController(title: "Место добавлено", message: "", preferredStyle: .actionSheet)
            self.present(alert, animated: true, completion: {alert.dismiss(animated: true, completion: nil)})
            annotation.placeStatus = true
            storage.addTown(currentPickedTown!)
            view.rightCalloutAccessoryView?.isHidden = true
            self.closure?(currentPickedTown!)
            case 2 :
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(identifier: "MainVC") as! WeatherShowController
            vc.currentPickedTown = self.currentPickedTown
            vc.mainMode = false
            present(vc, animated: true, completion: nil)
            
            return
        default : return
    }
    }
    }
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = (annotation as? WeatherAnnorationPoint) else {return nil}
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "WeatherPin")
        if annotation.placeStatus! { annotationView?.rightCalloutAccessoryView?.isHidden = true} else {annotationView?.rightCalloutAccessoryView?.isHidden = false}
        WeatherDownloader.getImage(annotation.imageID!, { data in
            
            DispatchQueue.main.async {
                guard let data = data else {return}
                annotationView?.image = UIImage(data: data)
            }
        })
        
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "WeatherPin")
            let rightButton = UIButton(type: .contactAdd)
            let leftButton = UIButton(type: .detailDisclosure)
            rightButton.tag = 1
            leftButton.tag = 2
            annotationView?.rightCalloutAccessoryView = rightButton
            annotationView?.leftCalloutAccessoryView = leftButton

            annotationView?.canShowCallout = true
            WeatherDownloader.getImage(annotation.imageID!, { data in
                
                DispatchQueue.main.async {
                    guard let data = data else {return}
                    annotationView?.image = UIImage(data: data)
                }
            })
        }
        if annotation.placeStatus! { annotationView?.rightCalloutAccessoryView?.isHidden = true} else {annotationView?.rightCalloutAccessoryView?.isHidden = false}
        return annotationView
    }
    
    
    
    @objc func handleTap(gestureRecognizer: UITapGestureRecognizer) {
       
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        
        WeatherDownloader.getWeather(Float(coordinate.latitude), Float(coordinate.longitude)) { [weak self] data in
           
            DispatchQueue.main.async { [weak self] in
                
                guard let data = data else {return}
                let annotation = WeatherAnnorationPoint()
                annotation.placeStatus = self?.storage.placeStatus(data)
                annotation.setTemp(data)
                self?.mapView.removeAnnotations((self?.mapView.annotations)!)
                annotation.coordinate = coordinate
                self?.mapView.addAnnotation(annotation)
                self?.currentPickedTown = data
                
            }
        }
      
    }
    
 func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        view.isEnabled = true
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        views.forEach({$0.isSelected = true})
    }
    
    
    func setupMap() {
        mapView.delegate = self
//        mapView.setCenter(currentLocation!, animated: true)
        
       let location = CLLocationCoordinate2D(latitude: Double(currentPickedTown!.lat), longitude: CLLocationDegrees(currentPickedTown!.lon))
        
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 15000, longitudinalMeters: 15000)
        mapView.setRegion(region, animated: true)
       let currentTownAnnotation = WeatherAnnorationPoint()
        currentTownAnnotation.setTemp(currentPickedTown!)
        currentTownAnnotation.coordinate = location
        currentTownAnnotation.placeStatus = true
        mapView.addAnnotation(currentTownAnnotation)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupMap()
        self.navigationController?.isNavigationBarHidden = false
        
        let gestureRecognizer = UITapGestureRecognizer(
                                      target: self, action: #selector(handleTap) )
            gestureRecognizer.delegate = self
            mapView.addGestureRecognizer(gestureRecognizer)

    }
    
   
    

    
    
    
}



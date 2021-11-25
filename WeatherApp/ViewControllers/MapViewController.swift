//
//  MapViewController.swift
//  WeatherAppV2
//
//  Created by Егор Пашкевич on 18.11.2021.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate {
   
    // MARK: Vars And Outlets
    var storage: TownsStorageProtocol = TownsStorage.shared
    var currentPickedTown: RealWeatherModelProtocol?
    var closure: ((RealWeatherModelProtocol?) -> ())?
    var curretnLocationTown: RealWeatherModelProtocol?
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distDescription: UIView!
    

// MARK: Work with Annotations
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        view.isEnabled = true
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        views.forEach({$0.isSelected = true})
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        
        if view.annotation is WeatherAnnorationPoint {
            let annotation =  view.annotation as! WeatherAnnorationPoint
            switch control.tag {
        
            
            case 1 :
            townAddedAlert()
            annotation.placeStatus = true
            storage.addTown(currentPickedTown!)
            view.rightCalloutAccessoryView?.isHidden = true
            self.closure?(currentPickedTown!)
            
            
            case 2 :
                infoAlert(forAnnotation: annotation)
            
            return
        default : return
    }
    }
    }
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = (annotation as? WeatherAnnorationPoint) else {return nil}
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "WeatherPin")
        if annotation.placeStatus { annotationView?.rightCalloutAccessoryView?.isHidden = true} else {annotationView?.rightCalloutAccessoryView?.isHidden = false}
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
        if annotation.placeStatus { annotationView?.rightCalloutAccessoryView?.isHidden = true} else {annotationView?.rightCalloutAccessoryView?.isHidden = false}
        return annotationView
    }
    
    // MARK: HandelTap
    
    @objc func handleTap(gestureRecognizer: UITapGestureRecognizer) {
       
        distDescription.isHidden = true
        self.mapView.removeOverlays(self.mapView.overlays)
        
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        
        WeatherDownloader.getWeather(coordinate.latitude, coordinate.longitude) { [weak self] data in
           
            DispatchQueue.main.async { [weak self] in
                
                guard let data = data else {return}
                let annotation = WeatherAnnorationPoint()
                annotation.setTemp(data)
                annotation.placeStatus = ((self?.storage.placeStatus(data)) != nil)
                let deletedAnnotations = self?.mapView.annotations as! [WeatherAnnorationPoint]
                
                
                self?.mapView.removeAnnotations(deletedAnnotations.filter({$0.isCurrentPlace != true}))
                annotation.coordinate = coordinate
                self?.mapView.addAnnotation(annotation)
                self?.currentPickedTown = data
                
            }
        }
      
    }
    
    // MARK: Route
    
    func setupDistView(forRoute route: MKRoute) {
        let dist = distDescription.viewWithTag(1) as! UILabel
        let time = distDescription.viewWithTag(2) as! UILabel
        dist.text = "Расстояние: \(route.distDescription()) киллометров"
        time.text = "Время в пути: \(route.timeDescription())"
        distDescription.isHidden = false
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .green
        renderer.lineWidth = 4.0
        
            return renderer
        }
    
    
    func showRoute(toAnnotation annotation : WeatherAnnorationPoint) {
        
        guard let sourse = self.curretnLocationTown else {return}
        self.distDescription.isHidden = true
        self.mapView.removeOverlays(self.mapView.overlays)
        
        let sourceLocation = CLLocationCoordinate2D(latitude: sourse.lat, longitude: sourse.lon)
        let destinationLocation = annotation.coordinate
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate() { [weak self] response, error in
            if error != nil {self?.routEror()}
            guard let response = response else {return}
            for route in response.routes {
                self?.mapView.addOverlay(route.polyline, level: .aboveRoads)
                self?.setupDistView(forRoute: route)
        
            }
            
        }

        
    }
    
    
    
    // MARK: MapView behavior and setups
    

    
    
    func setupMap() {
        mapView.delegate = self
        guard let currentPickedTown = currentPickedTown else {
            
            return}
        
        let location = CLLocationCoordinate2D(latitude: Double(currentPickedTown.lat), longitude: CLLocationDegrees(currentPickedTown.lon))
        
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 15000, longitudinalMeters: 15000)
        mapView.setRegion(region, animated: true)
       let currentTownAnnotation = WeatherAnnorationPoint()
        currentTownAnnotation.setTemp(currentPickedTown)
        currentTownAnnotation.coordinate = location
        currentTownAnnotation.placeStatus = true
        mapView.addAnnotation(currentTownAnnotation)
        currentTownAnnotation.isCurrentPlace = true
        curretnLocationTown = currentPickedTown
        
    }
    
    // MARK: View LifeCicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.distDescription.isHidden = true
        self.setupMap()
        self.navigationController?.isNavigationBarHidden = false
        
        let gestureRecognizer = UITapGestureRecognizer(
                                      target: self, action: #selector(handleTap) )
            gestureRecognizer.delegate = self
            mapView.addGestureRecognizer(gestureRecognizer)

    }
    
   
    

    
    
    
}
// MARK: ErrorHandling
extension MapViewController: ErrorDelegetaProtocol {
    func networkError() {
        self.navigationController?.popToRootViewController(animated: true)
        closure?(nil)
        
    }
}
// MARK: Alerts:
extension MapViewController {
    
    func infoAlert(forAnnotation annotation: WeatherAnnorationPoint) {
        let alert =  UIAlertController(title: "Что нужно сдеолать?", message: "", preferredStyle: .alert)
        let actionone = UIAlertAction(title: "Показать подробнее", style: .default) {_ in
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(identifier: "MainVC") as! WeatherShowController
            vc.currentPickedTown = self.currentPickedTown
            vc.mainMode = false
            self.present(vc, animated: true, completion: nil)
        }
        
        let actionTwo = UIAlertAction(title: "Провести маршрут", style: .default) {_ in
            self.showRoute(toAnnotation: annotation)
        }
        let actionThree = UIAlertAction(title: "Закрыть", style: .default, handler: nil)
        
        alert.addAction(actionone)
        alert.addAction(actionTwo)
        alert.addAction(actionThree)
        self.present(alert, animated: true, completion: nil)
    }
    
    func routEror() {
        let alert =  UIAlertController(title: "На машине сюда не добраться!", message: "", preferredStyle: .alert)
        let close = UIAlertAction(title: "Закрыть", style: .default, handler: nil)
        alert.addAction(close)
        self.present(alert, animated: true, completion: nil)
    }
    
    func townAddedAlert() {
        let alert =  UIAlertController(title: "Место добавлено", message: "", preferredStyle: .actionSheet)
        self.present(alert, animated: true, completion: {alert.dismiss(animated: true, completion: nil)})
    }
    
}


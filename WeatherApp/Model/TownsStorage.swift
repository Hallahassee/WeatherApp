//
//  TownsStorage.swift
//  Weather App
//
//  Created by Егор Пашкевич on 03.11.2021.
//

import Foundation


protocol TownsStorageProtocol {
    
  static  var shared: TownsStorageProtocol {get}
    var count: Int {get}
    var allTowns: [RealWeatherModelProtocol] {get}
    func addTown (_ town: String,  _ completion : @escaping (RealWeatherModelProtocol?) ->())
    func addTown(_ town: RealWeatherModelProtocol)
    func addTown (_ lat: Float , _ lon : Float, _ completion : @escaping (RealWeatherModelProtocol?) ->())
    func deleteTown (_ town : RealWeatherModelProtocol)
    func clearAll()
    func reloadAllTowns(_ completion : @escaping ()->())
    func reloadTown(_ town : RealWeatherModelProtocol)
    func getTown(byName town: String) -> RealWeatherModelProtocol
    func save()
    func load(_ completion : @escaping (Bool)->())
    func placeStatus(_ place : RealWeatherModelProtocol) ->  Bool
    
 }







class TownsStorage: TownsStorageProtocol {
    func clearAll() {
        CoreDataStorage.clearAll()
        allTowns.removeAll()
    }
    
    
    func placeStatus(_ place : RealWeatherModelProtocol) ->  Bool {
        if  allTownsId.contains(place.id) , allTowns.map({$0.town}).contains(place.town) {return true}
        else {
            return false
        }
    }
    
    
    func addTown(_ lat: Float, _ lon: Float, _ completion: @escaping (RealWeatherModelProtocol?) -> ()) {
        WeatherDownloader.getWeather(lat, lon, { [weak self] data in
            
            guard let data = data else {completion(nil) ; return}
            self?.allTowns = (self?.allTowns.filter({$0.id != data.id}))!
            self?.allTowns.append(data)
            self?.sort()
            
            completion(data)
        })
    }
    

    var count : Int {
        return self.allTowns.count
    }
    
    func addTown(_ town: RealWeatherModelProtocol) {
        self.allTowns = allTowns.filter({$0.id != town.id})
        self.allTowns.append(town)
        self.sort()

    }
    
 
static var shared: TownsStorageProtocol = TownsStorage()
    
    func save() {
        self.sort()
        CoreDataStorage.save()
    }

    
    func load( _ completion: @escaping ((Bool) -> () )) {
        guard let loadedFromCore = CoreDataStorage.load() else {completion(false) ; return }
        WeatherDownloader.getWeather(loadedFromCore, {[weak self] data in
            guard let data = data else {completion(true); return}
            data.forEach({self?.allTowns.append($0)})
            self?.sort()
            completion(true)
        })
    }
    
    
    var allTowns: [RealWeatherModelProtocol] = []
   
    var allTownsId: [Int] {
        self.sort()
        return self.allTowns.map({$0.id})
    }
    
    
    func getTown(byName town: String) -> RealWeatherModelProtocol {
        let result = self.allTowns.filter({$0.town == town})[0]
        self.sort()
        return result
    }
    
    func reloadTown(_ town: RealWeatherModelProtocol) {

    }
        
    
    
    
    func reloadAllTowns(_ completion : @escaping ()->()) {
        guard self.count == 0 else {completion()
            return
        }
        var dict: [String: String] = [:]
        for oneTown in allTowns {
            dict.updateValue(oneTown.town, forKey: String(oneTown.id))
        }
        WeatherDownloader.getWeather(dict, { [weak self] data in
           
            
            guard let data = data else { return}
            self?.allTowns.removeAll()
            data.forEach({self?.allTowns.append($0)})
            self?.sort()
            completion()
        })
    }
    
    
    
    func deleteTown(_ town: RealWeatherModelProtocol) {
        self.allTowns = self.allTowns.filter({$0.id != town.id })
        self.sort()
        CoreDataStorage.delete(town.id)
    }
    
    

    
    func addTown (_ town: String, _ completion : @escaping (RealWeatherModelProtocol?) ->()) {
            WeatherDownloader.getWeather(town) { data in
                guard let data = data else {completion(nil) ; return}
                self.allTowns = self.allTowns.filter({$0.id != data.id})
                self.allTowns.append(data)
                self.sort()
                completion(data)
        
        }
        

   
    }

    
    private init() {}
    
    
    private func sort(){
        if self.count > 0 {self.allTowns.sort(by: {$0.id < $1.id})}
    }
}

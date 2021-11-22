//
//  WeatherDownloader.swift
//  Weather App
//
//  Created by Егор Пашкевич on 03.11.2021.
//
//api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
import Foundation

protocol WeatherDownloaderProtocol {

    static var  storage: TownsStorageProtocol {get}
    static func getWeather( _ town: String, _ completion : @escaping (RealWeatherModelProtocol?) ->())
    static func getWeather(  _ id : [String], _ completion: @escaping (([RealWeatherModelProtocol]?)->()))
    static func getWeather(  _ lat: Float,  _ lon: Float,   _ completion: @escaping ((RealWeatherModelProtocol?)->()))
    static func getWeather(  _ idAndName : [String:String], _ completion: @escaping (([RealWeatherModelProtocol]?)->()))


}

class WeatherDownloader: WeatherDownloaderProtocol {
   
    
    static func getWeather(_ idAndName: [String : String], _ completion: @escaping (([RealWeatherModelProtocol]?) -> ())) {
   
    let id = idAndName.keys.map({String($0)})
        
    let strOfid = id.joined(separator: ",")
    let apiKey = "5740ecf7c8bb27efbce428a1b7e35f7a"
    let url = "https://api.openweathermap.org/data/2.5/group?id=\(strOfid)&lang=ru&units=metric&appid=\(apiKey)"
        NetworkController.getData(fromUrl: url) { (data)  in
       
            guard let data = data else {completion(nil); return}

        do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let result = try decoder.decode(NetworkWeatherData.self ,from: data)
        let towns = result.list
        var resultTowns: [RealWeatherModelProtocol] = []

            for town in towns {
                if town.name == idAndName[String(town.id)] {  resultTowns.append(RealWeatherModel(withModel: town))
            } else {
                resultTowns.append(RealWeatherModel(withModel: town, andName: idAndName[String(town.id)]!))
            }
            }
            
        completion(resultTowns)
        } catch  {
                print(error)
        }
        }
    }
        
        
    
    
    static func getWeather(_ lat: Float, _ lon: Float, _ completion: @escaping ((RealWeatherModelProtocol?) -> ())) {
        let apiKey = "5740ecf7c8bb27efbce428a1b7e35f7a"
       let url =  "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&lang=ru&units=metric&appid=\(apiKey)"
        NetworkController.getData(fromUrl: url) { (data)  in
            guard let data = data else {completion(nil); return}

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode(TownWeather.self ,from: data)
                completion(RealWeatherModel(withModel: result))
            } catch  {
                    print(error)
            }
        }
    }
    
    
    
    static var storage: TownsStorageProtocol = TownsStorage.shared
    
    static func getImage(_ id: String, _ completion: @escaping ((Data?) -> ())) {
       let url = "https://openweathermap.org/img/wn/\(id)@2x.png"
        NetworkController.getData(fromUrl: url) { (data)  in
completion(data)
        }
        

}

    
    static func getWeather( _ town: String, _ completion : @escaping (RealWeatherModelProtocol?) ->()) {
     
       var townStr = ""
        for oneLetter in town {
            if String(oneLetter) == " " {townStr += "%20"}
            else {
                townStr += String(oneLetter)
            }
        }
        
        let apiKey = "5740ecf7c8bb27efbce428a1b7e35f7a"
        let url = "https://api.openweathermap.org/data/2.5/weather?q=\(townStr)&lang=ru&units=metric&appid=\(apiKey)"
      // &lang=ru
        NetworkController.getData(fromUrl: url) { (data)  in
            guard let data = data else {completion(nil); return}

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode(TownWeather.self ,from: data)
                completion(RealWeatherModel(withModel: result))
            } catch  {
                    print(error)
            }
        }
    }
    
    
    
    
    static func getWeather(  _ id : [String], _ completion: @escaping (([RealWeatherModelProtocol]?)->())) {

        let strOfid = id.joined(separator: ",")
        let apiKey = "5740ecf7c8bb27efbce428a1b7e35f7a"

            let url = "https://api.openweathermap.org/data/2.5/group?id=\(strOfid)&lang=ru&units=metric&appid=\(apiKey)"

                NetworkController.getData(fromUrl: url) { (data)  in
                    guard let data = data else {completion(nil); return}

                do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode(NetworkWeatherData.self ,from: data)
                let towns = result.list
                let resultTowns =  towns.map({RealWeatherModel(withModel: $0)})
                completion(resultTowns)
                } catch  {
                        print(error)
                }
            }
            }
  
}

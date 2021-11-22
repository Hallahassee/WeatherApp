//
//  NetworkController.swift
//  Weather App
//
//  Created by Егор Пашкевич on 02.11.2021.
//

import Foundation

protocol NetWorkControllerProtocol {

static func getData(fromUrl url : String , _ complition : @escaping (Data?) -> ())

}

public class NetworkController: NetWorkControllerProtocol {

    
       
    

    
    
    static func getData(fromUrl url : String , _ complition : @escaping (Data?) -> ()) {
      
        guard let url = URL(string: url ) else {return}
        
            let session = URLSession.shared
            session.dataTask(with: url) {  (data, response, error ) in
          complition(data)
            }.resume()
                
        }
    }
    







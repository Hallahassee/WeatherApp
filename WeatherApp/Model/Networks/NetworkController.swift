//
//  NetworkController.swift
//  Weather App
//
//  Created by Егор Пашкевич on 02.11.2021.
//

import Foundation

protocol NetWorkControllerProtocol {

static func getData(fromUrl url : String , _ complition : @escaping (Data?) -> ())
    static var errorDelegete: ErrorDelegetaProtocol? {get set}

}

public class NetworkController: NetWorkControllerProtocol {
    static var errorDelegete: ErrorDelegetaProtocol?
    

    
       
    

    
    
    static func getData(fromUrl url : String , _ complition : @escaping (Data?) -> ()) {
      
        guard let url = URL(string: url ) else {return}
        
            let session = URLSession.shared
            session.dataTask(with: url) {  (data, response, error ) in
                if error != nil {
                    DispatchQueue.main.async {
                        self.errorDelegete?.networkError()
                    }
                    
                }
                complition(data)
            }.resume()
                
        }
    }
    







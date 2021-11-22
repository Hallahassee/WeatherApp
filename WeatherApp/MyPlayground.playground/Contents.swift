import UIKit


public class NetworkController  {

    
    static func getData(fromUrl url : String , _ complition : @escaping (Data) -> ()) {
      
        guard let url = URL(string: url ) else {return}
        
            let session = URLSession.shared
            session.dataTask(with: url) {  (data, response, error ) in
                
                guard let data = data else {return}
                    complition(data)
            }.resume()
                
        }
    
}




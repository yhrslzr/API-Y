//
//  PokemonListViewModel.swift
//  API
//
//  Created by win603 on 07/11/25.
//

import Foundation

class PokemonListViewModel : ObservableObject {
    @Published var pokemon: Pokemon
    
    init(){
        self.pokemon = Pokemon(count: -1, next: "" , previous: "" , results: [])
    }
    
    func getPokemonList(){
        let endPoint : String = "https://pokeapi.co/api/v2/pokemon"
               
           guard let apiURL = URL(string: endPoint) else{
               fatalError("Url no válida o no definida")
           }
            var urlRequest = URLRequest(url: apiURL)
            
            //Especificar tipo de contenido: XML, JSON, String,etc.
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

            //Mencionar tipo de método GET, POST, PUT, PATCH, DELETE
            urlRequest.httpMethod = "GET"
        
        let session = URLSession.shared
                
            let task = session.dataTask(with: urlRequest, completionHandler: { data, response, error -> Void in
                
                if let errorDelServidor = error {
                    print("Error: " + errorDelServidor.localizedDescription)
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    print("Error: Incapaz de conectar o recibir respuesta del servidor")
                    return
                }
                
                
                if response.statusCode == 200 {
                    
                    guard let data = data else {
                        print("Respuesta vacía")
                        return
                    }
                    
                    
                  DispatchQueue.main.async {
                      do {
                          let decoded = try JSONDecoder().decode(Pokemon.self, from: data)
                     
                          self.pokemon = decoded
                      } catch let error {
                          print("Error al decodificar JSON \(error)")
                          return
                      }
                  }
                 

                   
                }else{
                    print("Status diferente a 200. Ejemplos: 500 - Internal server error, 400 - Not found , etc.")
                    return
                }
                
            })
            task.resume()
            

    }
}

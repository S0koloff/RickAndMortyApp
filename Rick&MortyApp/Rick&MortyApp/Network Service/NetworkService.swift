//
//  NetworkService.swift
//  Rick&MortyApp
//
//  Created by Sokolov on 20.08.2023.
//

import UIKit

class NetworkService {
    
    func getCharacters(for page: Int, completion: ((_ characters: [Character]?, _ errorText: String?) -> Void)?) {
        
        let session = URLSession(configuration: .default)
        guard let url = URL(string: "https://rickandmortyapi.com/api/character?page=\(page)") else {
            completion?(nil, "Invalid URL")
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            
            if let error {
                print(error)
                completion?(nil, error.localizedDescription)
                return
            }
            
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            if statusCode != 200 {
                print("Error of status code", statusCode as Any)
                completion?(nil, "Error of status code: \(String(describing: statusCode))")
                return
            }
            
            guard let data else {
                print("Error of data")
                completion?(nil, "Error of data")
                return
            }
            
            do {
                let response = try JSONDecoder().decode(CharacterResponse.self, from: data)
                let characters = response.results
                completion?(characters, nil)
            } catch {
                print(error)
                completion?(nil, error.localizedDescription)
            }
        }
        
        task.resume()
    }
    
    func getEpisodes(for config: String, completion: ((_ episode: Episode?, _ textError: String?) -> Void)?) {
        
        let session = URLSession(configuration: .default)
        
        let url = URL(string: config )
        
        let task = session.dataTask(with: url!) { data, response, error in
            
            if let error {
                print(error)
                completion?(nil, error.localizedDescription)
                return
            }
            
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            if statusCode != 200 {
                print("Error of statusCode", statusCode as Any)
                completion?(nil, "Error of statusCode: \(String(describing: statusCode))")
                
                return
            }
            
            guard let data else {
                print("Error of data")
                completion?(nil, "Error of data")
                
                return
            }
            
            do {
                let episode  = try JSONDecoder().decode(Episode.self, from: data)
                completion?(episode, nil)
            } catch {
                print(error)
                completion?(nil, error.localizedDescription)
            }
        }
        
        task.resume()
    }
    
}

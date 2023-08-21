//
//  FactoryService.swift
//  Rick&MortyApp
//
//  Created by Sokolov on 20.08.2023.
//

import Foundation

protocol FactoryServiceProtocol {
    var networkService: NetworkService { get }
}

struct FactoryService: FactoryServiceProtocol {
    
    var networkService: NetworkService {
        NetworkService()
    }
}

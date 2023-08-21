//
//  Structs.swift
//  Rick&MortyApp
//
//  Created by Sokolov on 21.08.2023.
//

import Foundation

struct Character: Decodable {
    var id: Int
    var name: String
    var status: String
    var species: String
    var type: String
    var gender: String
    var origin: Origin
    var image: String
    var episode: [String]
}

struct Origin: Decodable {
    var name: String
    var url: String
}

struct Episode: Decodable {
    var name: String
    var air_date: String
    var episode: String
}

struct CharacterResponse: Decodable {
    var results: [Character]
}

//
//  SearchPerson.swift
//  SWAPI
//
//  Created by Konstantin Mishukov on 03.11.2022.
//  Copyright © 2022 Konstantin Mishukov. All rights reserved.
//

import Foundation

struct SearchPersonResponse: Codable {
    var count: Int
    var next: String?
    var previous: String?
    var results: [Person]?
    
    struct Person: Codable {
        var name: String
        var height: String
        var mass: String
        var hair_color: String
        var skin_color: String
        var eye_color: String
        var birth_year: String
        var gender: String
        var homeworld: String
        var films: [String]
        var species: [String]
        var vehicles: [String]
        var starships: [String]
        var created: String
        var edited: String
        var url: String
    }
}

extension SWAPI {
    static private let searchURL = "https://swapi.dev/api/people/?search="
    
    static func searchPerson(forString string: String, completion: @escaping ([SearchPersonResponse.Person]?) -> ()) -> () {
        APIManager.networkRequest(url: searchURL, parameter: string) { (recieved) in
            if let data = recieved.data {
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(SearchPersonResponse.self, from: data)
                    completion(response.results)
                } catch {
                    print(error)
                }
            } else {
                completion(nil)
            }
        }
    }
}

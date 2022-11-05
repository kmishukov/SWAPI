//
//  SearchPerson.swift
//  SWAPI
//
//  Created by Konstantin Mishukov on 03.11.2022.
//  Copyright © 2022 Konstantin Mishukov. All rights reserved.
//

import Foundation

struct SearchPersonResponse: Decodable {
    var count: Int
    var next: String?
    var previous: String?
    var results: [Person]?

    struct Person: Decodable {
        let name: String
        let height: String
        let mass: String
        let hairColor: String
        let skinColor: String
        let eyeColor: String
        let birthYear: String
        let gender: String
        let homeworld: String
        let films: [String]
        let species: [String]
        let vehicles: [String]
        let starships: [String]
        let created: String
        let edited: String
        let url: String
    }
}

final class SWAPI {
    static private let searchURL = "https://swapi.dev/api/people/?search="

    static func searchPerson(forString string: String, completion: @escaping ([SearchPersonResponse.Person]?) -> Void) {
        APIManager.networkRequest(url: searchURL, parameter: string) { (recieved) in
            if let data = recieved.data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
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

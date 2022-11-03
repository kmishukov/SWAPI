//
//  jsonFilmObject.swift
//  SWAPI
//
//  Created by Konstantin Mishukov on 10/12/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import Foundation

struct jsonFilmObject: Codable {
    var title: String
    var episode_id: Int
    var opening_crawl: String
    var director: String
    var producer: String
    var release_date: String
    var characters: [String]
    var planets: [String]
    var starships: [String]
    var vehicles: [String]
    var species: [String]
    var created: String
    var edited: String
    var url: String
}

extension SWAPI {
    static func getFilmTitle(url: [String], completion: @escaping (String)-> ()) {
        var films: String = "", counter = 0
        let totalNames = url.count
        for item in url {
            APIManager.networkRequest(url: item, parameter: nil) { (recieved) in
                guard recieved.error == nil else { return }
                do {
                    counter += 1
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(jsonFilmObject.self, from: recieved.data!)
                    if films == "" {
                        films = "Films: \(response.title)"
                    } else {
                        films = films + ", \(response.title)"
                    }
                    if counter == totalNames {
                        completion(films)
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
}

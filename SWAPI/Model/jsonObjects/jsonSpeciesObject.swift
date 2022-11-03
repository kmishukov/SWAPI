//
//  jsonSpeciesObject.swift
//  SWAPI
//
//  Created by Konstantin Mishukov on 10/12/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import Foundation

class jsonSpecieObject: Codable {
    var name: String
}

extension SWAPI {
    static func getSpecieName(url: [String], completion: @escaping (_ name: String) -> Void) {
        guard !url.isEmpty else { completion(""); return }
        var counter = 0, species: String = ""
        let totalSpecies = url.count
        for item in url {
            APIManager.networkRequest(url: item, parameter: nil) { (recieved) in
                do {
                    counter += 1
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(jsonSpecieObject.self, from: recieved.data!)
                    if species == "" {
                        species = "Species: \(response.name)"
                    } else {
                        species = species + ", \(response.name)"
                    }
                    if counter == totalSpecies {
                        completion(species)
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
}

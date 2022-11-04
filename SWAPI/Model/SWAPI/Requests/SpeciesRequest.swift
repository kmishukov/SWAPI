//
//  getSpecieName.swift
//  SWAPI
//
//  Created by Konstantin Mishukov on 10/12/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import Foundation

class SpeciesResponse: Codable {
    var name: String
}

extension SWAPI {
    static func getSpecieName(url: [String], completion: @escaping (_ species: [String]?) -> Void) {
        guard !url.isEmpty else { completion(nil); return }
        var species: [String]?
        for item in url {
            APIManager.networkRequest(url: item, parameter: nil) { response in
                guard let data = response.data else { completion(nil); return }
                do {
                    let decoder = JSONDecoder()
                    let specie = try decoder.decode(SpeciesResponse.self, from: data)
                    species = (species ?? []) + [specie.name]
                } catch {
                    print(error)
                }
            }
        }
        completion(species)
    }
}

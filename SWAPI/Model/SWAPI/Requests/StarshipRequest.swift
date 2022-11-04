//
//  StarshipRequest.swift
//  SWAPI
//
//  Created by Konstantin Mishukov on 10/12/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import Foundation

struct StarshipResponse: Codable {
    var name: String
}

extension SWAPI {
    static func getStarshipName(urlArray: [String], completion: @escaping (_ name: [String]?) -> Void) {
        var starships: [String]?
        for url in urlArray {
            APIManager.networkRequest(url: url, parameter: nil) { response in
                guard let data = response.data else { completion(nil); return }
                do {
                    let decoder = JSONDecoder()
                    let starship = try decoder.decode(StarshipResponse.self, from: data)
                    starships = (starships ?? []) + [starship.name]
                } catch {
                    print(error)
                }
            }
        }
        completion(starships)
    }
}

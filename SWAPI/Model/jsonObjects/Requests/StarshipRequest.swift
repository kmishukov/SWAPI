//
//  jsonStarshipObject.swift
//  SWAPI
//
//  Created by Konstantin Mishukov on 10/12/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import Foundation

struct jsonStarshipObject: Codable {
    var name: String
}

extension SWAPI {
    static func getStarshipName(urlArray: [String], completion: @escaping (_ name: String) -> Void) {
        var starships = "", counter = 0
        let totalStarships = urlArray.count
        for url in urlArray {
            APIManager.networkRequest(url: url, parameter: nil) { (recieved) in
                do {
                    counter += 1
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(jsonStarshipObject.self, from: recieved.data!)
                    if starships == "" {
                        starships = "Starships: \(response.name)"
                    } else {
                        starships = starships + ", \(response.name)"
                    }
                    if counter == totalStarships {
                        completion(starships)
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
}

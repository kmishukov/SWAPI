//
//  jsonPlanetObject.swift
//  SWAPI
//
//  Created by Konstantin Mishukov on 10/12/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import Foundation

class jsonPlanetObject: Codable {
    var name: String
}

extension SWAPI {
    static func getPlanetName(url: String, completion: @escaping (_ name: String) -> Void) {
        API.networkRequest(url: url, parameter: nil) { (recieved) in
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(jsonPlanetObject.self, from: recieved.data!)
                let name = response.name
                completion(name)
            } catch {
                print(error)
            }
        }
    }
}


//
//  jsonVehiclesObject.swift
//  SWAPI
//
//  Created by Konstantin Mishukov on 10/12/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import Foundation

struct jsonVehicleObject: Codable {
    var name: String
}

extension SWAPI {
    static func getVehicleName(urlArray: [String], completion: @escaping (_ name: String?) -> Void) {
        var vehicles: String = "", counter = 0
        let totalVehicles = urlArray.count
        for url in urlArray {
            APIManager.networkRequest(url: url, parameter: nil) { (recieved) in
                do {
                    counter += 1
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(jsonVehicleObject.self, from: recieved.data!)
                    if vehicles == "" {
                        vehicles = "Vehicles: \(response.name)"
                    } else {
                        vehicles = vehicles + ", \(response.name)"
                    }
                    if counter == totalVehicles {
                        completion(vehicles)
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
}

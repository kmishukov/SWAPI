//
//  jsonVehiclesObject.swift
//  SWAPI
//
//  Created by Konstantin Mishukov on 10/12/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import Foundation

struct VehicleResponse: Codable {
    var name: String
}

extension SWAPI {
    static func getVehicleName(urlArray: [String], completion: @escaping (_ name: [String]?) -> Void) {
        var vehicles: [String]?
        for url in urlArray {
            APIManager.networkRequest(url: url, parameter: nil) { response in
                guard let data = response.data else { completion(nil); return }
                do {
                    let decoder = JSONDecoder()
                    let vehicle = try decoder.decode(VehicleResponse.self, from: data)
                    vehicles = (vehicles ?? []) + [vehicle.name]
                } catch {
                    print(error)
                }
            }
        }
        completion(vehicles)
    }
}

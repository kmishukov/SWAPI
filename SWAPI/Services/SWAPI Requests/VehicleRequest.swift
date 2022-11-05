//
//  jsonVehiclesObject.swift
//  SWAPI
//
//  Created by Konstantin Mishukov on 10/12/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import Foundation

struct VehicleResponse: Codable {
    let name: String
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

    static func getVehicles(urlsStr: [String]) async -> [String]? {
        guard !urlsStr.isEmpty else { return nil }

        var vehicles: [String] = []
        try? await withThrowingTaskGroup(of: String?.self, body: { group in
            for urlStr in urlsStr {
                guard let url = URL(string: urlStr) else { continue }
                group.addTask {
                    return await getVehicle(url: url)
                }
            }
            for try await vehicle in group {
                guard let vehicle = vehicle else { continue }
                print("Vehicle Receive")
                vehicles.append(vehicle)
            }
        })
        return vehicles.sorted()
    }

    static private func getVehicle(url: URL) async -> String? {
        do {
            print("Vehicle Get")
            let (data, _) = try await URLSession.shared.data(from: url)
            let vehicle = try JSONDecoder().decode(VehicleResponse.self, from: data)
            return vehicle.name
        } catch let err {
            print(err.localizedDescription)
        }
        return nil
    }
}

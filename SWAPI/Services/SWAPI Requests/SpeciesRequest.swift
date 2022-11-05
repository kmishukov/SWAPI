//
//  getSpecieName.swift
//  SWAPI
//
//  Created by Konstantin Mishukov on 10/12/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import Foundation

struct SpeciesResponse: Codable {
    let name: String
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

    static func getSpecies(urlsStr: [String]) async -> [String]? {
        guard !urlsStr.isEmpty else { return nil }

        var species: [String] = []
        try? await withThrowingTaskGroup(of: String?.self, body: { group in
            for urlStr in urlsStr {
                guard let url = URL(string: urlStr) else { continue }
                group.addTask {
                    return await getSpecie(url: url)
                }
            }
            for try await specie in group {
                guard let specie = specie else { continue }
                print("Specie Receive")
                species.append(specie)
            }
        })
        return species.sorted()
    }

    static private func getSpecie(url: URL) async -> String? {
        do {
            print("Specie Get")
            let (data, _) = try await URLSession.shared.data(from: url)
            let specie = try JSONDecoder().decode(SpeciesResponse.self, from: data)
            return specie.name
        } catch let err {
            print(err.localizedDescription)
        }
        return nil
    }
}

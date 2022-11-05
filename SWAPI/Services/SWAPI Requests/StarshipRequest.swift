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

    static func getStarships(urlsStr: [String]) async -> [String]? {
        guard !urlsStr.isEmpty else { return nil }

        var starships: [String] = []
        try? await withThrowingTaskGroup(of: String?.self, body: { group in
            for urlStr in urlsStr {
                guard let url = URL(string: urlStr) else { continue }
                group.addTask {
                    return await getStarship(url: url)
                }
            }
            for try await starship in group {
                guard let starship = starship else { continue }
                print("Starship Receive")
                starships.append(starship)
            }
        })
        return starships.sorted()
    }

    static private func getStarship(url: URL) async -> String? {
        do {
            print("Starship Get")
            let (data, _) = try await URLSession.shared.data(from: url)
            let starship = try JSONDecoder().decode(StarshipResponse.self, from: data)
            return starship.name
        } catch let err {
            print(err.localizedDescription)
        }
        return nil
    }
}

//
//  FilmRequest.swift
//  SWAPI
//
//  Created by Konstantin Mishukov on 10/12/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import Foundation

struct FilmResponse: Codable {
    var title: String
    var episode_id: Int
    var opening_crawl: String
    var director: String
    var producer: String
    var release_date: String
    var characters: [String]
    var planets: [String]
    var starships: [String]
    var vehicles: [String]
    var species: [String]
    var created: String
    var edited: String
    var url: String
}

extension SWAPI {
    static func getFilm(url: [String], completion: @escaping ([String]?) -> ()) {
        var films: [String]?
        for item in url {
            APIManager.networkRequest(url: item, parameter: nil) { reponse in
                guard let data = reponse.data else { completion(nil); return }
                do {
                    let decoder = JSONDecoder()
                    let film = try decoder.decode(FilmResponse.self, from: data)
                    films = (films ?? []) + [film.title]
                } catch {
                    print(error)
                }
            }
        }
        completion(films)
    }
    
    static func getFilms(urlsStr: [String]) async -> [String]? {
        guard !urlsStr.isEmpty else { return nil }
        
        var films: [String] = []
        try? await withThrowingTaskGroup(of: String?.self, body: { group in
            for urlStr in urlsStr {
                guard let url = URL(string: urlStr) else { continue }
                group.addTask {
                    return await getFilm(url: url)
                }
            }
            for try await filmTitle in group {
                guard let filmTitle = filmTitle else { continue }
                print("Film Receive")
                films.append(filmTitle)
            }
        })
        return films.sorted()
    }
    
    static private func getFilm(url: URL) async -> String? {
        do {
            print("Film Get")
            let (data, _) = try await URLSession.shared.data(from: url)
            let film = try JSONDecoder().decode(FilmResponse.self, from: data)
            return film.title
        } catch (let err) {
            print(err.localizedDescription)
        }
        return nil
    }
}

//
//  FilmRequest.swift
//  SWAPI
//
//  Created by Konstantin Mishukov on 10/12/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import Foundation

struct FilmResponse: Codable {
    let title: String
    let episode_id: Int
    let opening_crawl: String
    let director: String
    let producer: String
    let release_date: String
    let characters: [String]
    let planets: [String]
    let starships: [String]
    let vehicles: [String]
    let species: [String]
    let created: String
    let edited: String
    let url: String
}

extension SWAPI {
    static func getFilm(url: [String], completion: @escaping ([String]?) -> Void) {
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
        } catch let err {
            print(err.localizedDescription)
        }
        return nil
    }
}

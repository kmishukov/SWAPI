//
//  SearchResult.swift
//  SWAPI
//
//  Created by Konstantin Mishukov on 10/12/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import Foundation

extension SWAPI {

    /// Method of getting multiple details of a person using groups.
    /// - Parameters:
    ///   - pobject: Person object with URLs in its properties.
    ///   - completion: Returns an optional Person object with filled properties.
    static func downloadPersonDetails(object: SearchPersonResponse.Person) -> Person {
        let group = DispatchGroup()

        var homeworld: String?
        var films: [String]?
        var species: [String]?
        var vehicles: [String]?
        var starships: [String]?

        group.enter()
        SWAPI.getHomeworld(url: object.homeworld) { apiHomeworld in
            homeworld = homeworld
            group.leave()
        }

        group.enter()
        SWAPI.getFilm(url: object.films) { apiFilms in
            films = apiFilms
            group.leave()
        }

        group.enter()
        SWAPI.getSpecieName(url: object.species) { apiSpecies in
            species = apiSpecies
            group.leave()
        }

        if !object.vehicles.isEmpty {
            group.enter()
            SWAPI.getVehicleName(urlArray: object.vehicles) { apiVehicles in
                vehicles = apiVehicles
                group.leave()
            }
        }

        if !object.starships.isEmpty {
            group.enter()
            SWAPI.getStarshipName(urlArray: object.starships) { apiStarships in
                starships = apiStarships
                group.leave()
            }
        }

        group.wait()
        return Person(object, homeworld: homeworld, films: films, species: species, vehicles: vehicles, starships: starships)
    }

    /// Method of getting multiple details of a person using async/await.
    /// - Parameter responsePerson: Person object with URLs in its properties.
    /// - Returns: An optional Person object with filled properties.
    static func downloadPersonDetails(_ responsePerson: SearchPersonResponse.Person) async -> Person? {
        async let homeworld = await SWAPI.getHomeworld(urlStr: responsePerson.homeworld)
        async let films = await SWAPI.getFilms(urlsStr: responsePerson.films)
        async let species = await SWAPI.getSpecies(urlsStr: responsePerson.species)
        async let vehicles = await SWAPI.getVehicles(urlsStr: responsePerson.vehicles)
        async let starships = await SWAPI.getStarships(urlsStr: responsePerson.starships)

        return await Person(responsePerson,
                            homeworld: homeworld,
                            films: films,
                            species: species,
                            vehicles: vehicles,
                            starships: starships
        )
    }
}

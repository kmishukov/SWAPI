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
        var person = Person(object: object)

        group.enter()
        SWAPI.getHomeworld(url: object.homeworld) { homeworld in
            person.homeworld = homeworld
            group.leave()
        }

        group.enter()
        SWAPI.getFilm(url: object.films) { films in
            person.films = films?.joined(separator: ", ")
            group.leave()
        }

        group.enter()
        SWAPI.getSpecieName(url: object.species) { species in
            person.species = species?.joined(separator: ", ")
            group.leave()
        }

        if !object.vehicles.isEmpty {
            group.enter()
            SWAPI.getVehicleName(urlArray: object.vehicles) { vehicles in
                person.vehicles = vehicles?.joined(separator: ", ")
                group.leave()
            }
        }

        if !object.starships.isEmpty {
            group.enter()
            SWAPI.getStarshipName(urlArray: object.starships) { starships in
                person.starships = starships?.joined(separator: ", ")
                group.leave()
            }
        }

        group.wait()
        return person
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

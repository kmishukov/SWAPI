//
//  SearchResult.swift
//  SWAPI
//
//  Created by Konstantin Mishukov on 10/12/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import Foundation

extension SWAPI {
    static func downloadPersonDetails(object: SearchPersonResult.Person) -> Person {
        let group = DispatchGroup()
        var person = Person(object: object)
 
        group.enter()
        SWAPI.getPlanetName(url: object.homeworld) { homeworld in
            person.homeworld = homeworld
            group.leave()
        }

        group.enter()
        SWAPI.getFilmTitle(url: object.films) { (films) in
            person.films = films
            group.leave()
        }
        
        group.enter()
        SWAPI.getSpecieName(url: object.species) { (name) in
            person.species = name
            group.leave()
        }
    
        if object.vehicles.isEmpty == false {
            group.enter()
            SWAPI.getVehicleName(urlArray: object.vehicles) { (names) in
                person.vehicles = names
                group.leave()
            }
        } else {
            person.vehicles = "Vehicles: none"
        }
        
        if object.starships.isEmpty == false {
            group.enter()
            SWAPI.getStarshipName(urlArray: object.starships) { (names) in
                person.starships = names
                group.leave()
            }
        } else {
            person.starships = "Starships: none"
        }
        
        group.wait()
        return person
    }
}

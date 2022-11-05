//
//  Person.swift
//  SWAPI
//
//  Created by Konstantin Mishukov on 09/12/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import Foundation

struct Person {
    let name: String
    let height: String
    let mass: String
    let hairColor: String
    let skinColor: String
    let eyeColor: String
    let birthYear: String
    let gender: String
    let homeworld: String?
    let films: String?
    let species: String?
    let vehicles: String?
    let starships: String?
    let created: String
    let edited: String
    let url: String

    init(_ person: SearchPersonResponse.Person,
         homeworld: String?,
         films: [String]?,
         species: [String]?,
         vehicles: [String]?,
         starships: [String]?) {
        self.name = person.name
        self.height = person.height
        self.mass = person.mass
        self.hairColor = person.hairColor
        self.skinColor = person.skinColor
        self.eyeColor = person.eyeColor
        self.birthYear = person.birthYear
        self.gender = person.gender
        self.created = person.created.toDate()
        self.edited = person.edited.toDate()
        self.url = person.url

        self.homeworld = homeworld
        self.films = (films ?? []).isEmpty ? nil : (films ?? []).joined(separator: ", ")
        self.species = (species ?? []).isEmpty ? nil : (species ?? []).joined(separator: ", ")
        self.vehicles = (vehicles ?? []).isEmpty ? nil : (vehicles ?? []).joined(separator: ", ")
        self.starships = (starships ?? []).isEmpty ? nil : (starships ?? []).joined(separator: ", ")
    }

    init(data: PersonData) {
        self.name = data.name ?? "error"
        self.height = data.height ?? "error"
        self.mass = data.mass ?? "error"
        self.hairColor = data.hairColor ?? "error"
        self.skinColor = data.skinColor ?? "error"
        self.eyeColor = data.eyeColor ?? "error"
        self.birthYear = data.birthYear ?? "error"
        self.gender = data.gender ?? "error"
        self.homeworld = data.homeworld
        self.films = data.films
        self.species = data.spiecies
        self.vehicles = data.vehicles
        self.starships = data.starships
        self.created = data.created ?? "error"
        self.edited = data.edited ?? "error"
        self.url = data.url ?? "error"
    }
}

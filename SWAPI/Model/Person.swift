//
//  Person.swift
//  SWAPI
//
//  Created by Konstantin Mishukov on 09/12/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import Foundation

struct Person {

    init(_ person: SearchPersonResponse.Person,
         homeworld: String?,
         films: [String]?,
         species: [String]?,
         vehicles: [String]?,
         starships: [String]?) {
        self.name = person.name
        self.height = person.height
        self.mass = person.mass
        self.hair_color = person.hairColor
        self.skin_color = person.skinColor
        self.eye_color = person.eyeColor
        self.birth_year = person.birthYear
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

    var name: String
    var height: String
    var mass: String
    var hair_color: String
    var skin_color: String
    var eye_color: String
    var birth_year: String
    var gender: String
    var homeworld: String?
    var films: String?
    var species: String?
    var vehicles: String?
    var starships: String?
    var created: String
    var edited: String
    var url: String

    init(object: SearchPersonResponse.Person) {
        self.name = object.name
        self.height = object.height
        self.mass = object.mass
        self.hair_color = object.hairColor
        self.skin_color = object.skinColor
        self.eye_color = object.eyeColor
        self.birth_year = object.birthYear
        self.gender = object.gender
        self.created = object.created.toDate()
        self.edited = object.edited.toDate()
        self.url = object.url
    }

    init(data: PersonData) {
        self.name = data.name ?? "error"
        self.height = data.height ?? "error"
        self.mass = data.mass ?? "error"
        self.hair_color = data.hair_color ?? "error"
        self.skin_color = data.skin_color ?? "error"
        self.eye_color = data.eye_color ?? "error"
        self.birth_year = data.birth_year ?? "error"
        self.gender = data.gender ?? "error"
        self.homeworld = data.homeworld ?? "error"
        self.films = data.films ?? "error"
        self.species = data.spiecies ?? "error"
        self.vehicles = data.vehicles ?? "error"
        self.starships = data.starships ?? "error"
        self.created = data.created ?? "error"
        self.edited = data.edited ?? "error"
        self.url = data.url ?? "error"
    }

}

extension String {
    func toDate(withFormat format: String = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        guard let date = dateFormatter.date(from: self) else {
            return self
        }
        return date.asString(style: .long)
    }
}

extension Date {
    func asString(style: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: self)
    }
}

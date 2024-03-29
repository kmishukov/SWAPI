//
//  DataController.swift
//  SWAPI
//
//  Created by Konstantin Mishukov on 09/12/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import UIKit
import CoreData

final class DataController: NSObject {
    static let personEntity = "PersonData"

    static func getContext() -> NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Could not get current context")
        }
        return appDelegate.persistentContainer.viewContext
    }

    static func savePerson(person: Person) {
        let context = getContext()
        let name = person.name
        let personFetch = NSFetchRequest<NSFetchRequestResult>(entityName: DataController.personEntity)
        personFetch.predicate = NSPredicate(format: "name = %@", "\(name)")
        do {
            let persons = try context.fetch(personFetch)
            if persons.count == 0 {
                let _ = PersonData(person: person, context: context)
                save()
            } else if let savedPerson = persons.first as? PersonData,
                      let edited = savedPerson.edited {
                if edited == person.edited {
                    print("This person is already saved.")
                } else {
                    DataController.removePersonData(data: savedPerson)
                    let _ = PersonData(person: person, context: context)
                    save()
                }
            }
        } catch let err {
            print(err.localizedDescription)
        }
    }
    
    static func fetchPersons() -> [PersonData]? {
        let context = getContext()
        var array: [PersonData]? = nil
        do {
            array = try context.fetch(PersonData.fetchRequest())
            return array
        } catch {
            return array
        }
    }
    
    static func removePersonData(data: PersonData) {
        let context = getContext()
        context.delete(data)
        print("\(String(describing: data.name)) removed.")
        save()
    }
    
    static func save() {
        let context = getContext()
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

// MARK: - Init with Person
extension PersonData {
    convenience init(person: Person, context: NSManagedObjectContext) {
        self.init(context: context)
        self.name = person.name
        self.birthYear = person.birthYear
        self.created = person.created
        self.edited = person.edited
        self.eyeColor = person.eyeColor
        self.films = person.films
        self.gender = person.gender
        self.hairColor = person.hairColor
        self.height = person.height
        self.homeworld = person.homeworld
        self.mass = person.mass
        self.skinColor = person.skinColor
        self.spiecies = person.species
        self.starships = person.starships
        self.vehicles = person.vehicles
        self.url = person.url
    }
}

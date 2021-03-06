//
//  DataHandler.swift
//  SWAPI
//
//  Created by Konstantin Mishukov on 09/12/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import UIKit
import CoreData

class DataHandler: NSObject {

    private class func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    class func addPerson(person: Person){
        let context = getContext()
        let name = person.name
        let personFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "PersonData")
        personFetch.predicate = NSPredicate(format: "name = %@", "\(name)")
        do {
            let persons = try! context.fetch(personFetch)
            if persons.count == 0 {
                let _ = PersonData(person: person, context: context)
                do {
                    try context.save()
                    print("\(person.name) saved successfully.")
                } catch {
                    print(error)
                    print("Save failed.")
                }
            } else {
                print("This person is already saved.")
            }
        }
    }
    
    class func fetchPersons() -> [PersonData]? {
        let context = getContext()
        var array: [PersonData]? = nil
        do {
            array = try context.fetch(PersonData.fetchRequest())
            return array
        } catch {
            return array
        }
    }
    
    class func removePersonObject(data: PersonData) {
        let context = getContext()
        context.delete(data)
        print("\(String(describing: data.name)) removed.")
    }
}

extension PersonData {
    
    convenience init(person: Person, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.name = person.name
        self.birth_year = person.birth_year
        self.created = person.created
        self.edited = person.edited
        self.eye_color = person.eye_color
        self.films = person.films
        self.gender = person.gender
        self.hair_color = person.hair_color
        self.height = person.height
        self.homeworld = person.homeworld
        self.mass = person.mass
        self.skin_color = person.skin_color
        self.spiecies = person.species
        self.starships = person.starships
        self.vehicles = person.vehicles
        self.url = person.url
    }
}

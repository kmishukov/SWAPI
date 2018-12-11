//
//  DetailViewController.swift
//  SWAPI
//
//  Created by Konstantin Mishukov on 09/12/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var homeworldLabel: UILabel!
    @IBOutlet weak var filmsLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var vehiclesLabel: UILabel!
    @IBOutlet weak var starshipsLabel: UILabel!
    @IBOutlet weak var createEditLabel: UILabel!
    
    var person: Person?
    var personObject: jsonPersonSearchObject.PersonObject?
    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.swapiBackground
        
        activityIndicator.color = UIColor.swapiGreen
        let barButton = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.setRightBarButton(barButton, animated: true)
        
        if let person = personObject {
            downloadPersonDetails(pobject: person) { p in
                DispatchQueue.main.async {
                    self.updateView(p: p, textColor: UIColor.swapiGreen)
                    DataHandler.addPerson(person: p)
                    self.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.5, animations: {
                        self.label.alpha = 1
                        self.homeworldLabel.alpha = 1
                        self.filmsLabel.alpha = 1
                        self.speciesLabel.alpha = 1
                        self.vehiclesLabel.alpha = 1
                        self.starshipsLabel.alpha = 1
                        self.createEditLabel.alpha = 1
                    })
                }
            }
        }
        
        if let person = person {
            updateView(p: person, textColor: UIColor.swapiYellow)
        }
    }
    
    func downloadPersonDetails(pobject: jsonPersonSearchObject.PersonObject, completion: @escaping (Person) -> Void ){
        label.alpha = 0
        homeworldLabel.alpha = 0
        filmsLabel.alpha = 0
        speciesLabel.alpha = 0
        vehiclesLabel.alpha = 0
        starshipsLabel.alpha = 0
        createEditLabel.alpha = 0
        
        self.activityIndicator.startAnimating()
        DispatchQueue.global(qos: .utility).async {
            let person = SWAPI.parseJsonPersonObject(object: pobject)
            completion(person)
        }
    }
   
    func updateView(p: Person, textColor: UIColor) {
        
        label.textColor = textColor
        homeworldLabel.textColor = textColor
        filmsLabel.textColor = textColor
        speciesLabel.textColor = textColor
        vehiclesLabel.textColor = textColor
        starshipsLabel.textColor = textColor
        createEditLabel.textColor = textColor
        
        label.numberOfLines = 0
        label.text = "Name: \(p.name)\nHeight: \(p.height)\nMass: \(p.mass)\nHair color: \(p.hair_color)\nSkin color: \(p.skin_color)\nEye color: \(p.eye_color)\nBirth year: \(p.birth_year)\nGender: \(p.gender)"
        homeworldLabel.numberOfLines = 0
        if let homeworld = p.homeworld {
            homeworldLabel.text =  "Homeworld: \(homeworld)"
        } else {
            homeworldLabel.text = "Homeworld: error?"
        }
        filmsLabel.numberOfLines = 0
        if let films = p.films {
            filmsLabel.text =  "Films: \(films)"
        } else {
            filmsLabel.text = "Films: error?"
        }
        speciesLabel.numberOfLines = 0
        if let species = p.species {
            speciesLabel.text = species
        } else {
            speciesLabel.text = "Species: error?"
        }
        vehiclesLabel.numberOfLines = 0
        if let vehicles = p.vehicles {
            vehiclesLabel.text = vehicles
        } else {
            vehiclesLabel.text = "Vehicles: error?"
        }
        starshipsLabel.numberOfLines = 0
        if let starships = p.starships {
            starshipsLabel.text = starships
        } else {
            starshipsLabel.text = "Starships: error?"
        }
        createEditLabel.numberOfLines = 0
        createEditLabel.text = "Created: \(p.created)\nEdited: \(p.edited)\nURL: \(p.url)"
    
    }
}

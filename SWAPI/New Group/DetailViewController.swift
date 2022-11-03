//
//  DetailViewController.swift
//  SWAPI
//
//  Created by Konstantin Mishukov on 09/12/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    // Views
    private let nameLabel = UILabel(frame: .zero)
    private let homeworldLabel = UILabel(frame: .zero)
    private let filmsLabel = UILabel(frame: .zero)
    private let speciesLabel = UILabel(frame: .zero)
    private let vehiclesLabel = UILabel(frame: .zero)
    private let starshipsLabel = UILabel(frame: .zero)
    private let createEditLabel = UILabel(frame: .zero)
    
    // Data
    var person: Person? // Это для дейтела уже сохраненных
    var personObject: jsonPersonSearchObject.PersonObject? // Это для лоада
    let activityIndicator = UIActivityIndicatorView(frame: .zero)
    
    init() {
        person = nil
        personObject = nil
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(person: Person) {
        self.init()
        self.person = person
        self.personObject = nil
    }
    
    convenience init(personObject: jsonPersonSearchObject.PersonObject) {
        self.init()
        self.person = nil
        self.personObject = personObject
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.swapiBackground
        setupViews()
        
        if let personObject = personObject {
            downloadPersonDetails(pobject: personObject) { person in
                if let p = person {
                    DispatchQueue.main.async {
                        self.updateView(p: p, textColor: UIColor.swapiGreen)
                        DataHandler.addPerson(person: p)
                        self.activityIndicator.stopAnimating()
                        UIView.animate(withDuration: 0.5, animations: {
                            self.nameLabel.alpha = 1
                            self.homeworldLabel.alpha = 1
                            self.filmsLabel.alpha = 1
                            self.speciesLabel.alpha = 1
                            self.vehiclesLabel.alpha = 1
                            self.starshipsLabel.alpha = 1
                            self.createEditLabel.alpha = 1
                        })
                    }
                } else {
                    print("Error Downloading Person Information")
                    self.activityIndicator.stopAnimating()
                }
            }
        } else if let person = person {
            updateView(p: person, textColor: UIColor.swapiYellow)
        }
    }
    
    private func setupViews() {
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin).inset(5)
            $0.left.right.equalTo(view)
        }
        
        view.addSubview(homeworldLabel)
        homeworldLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom)
            $0.left.right.equalTo(view)
        }
        
        view.addSubview(filmsLabel)
        filmsLabel.snp.makeConstraints {
            $0.top.equalTo(homeworldLabel.snp.bottom)
            $0.left.right.equalTo(view)
        }
        
        view.addSubview(speciesLabel)
        speciesLabel.snp.makeConstraints {
            $0.top.equalTo(filmsLabel.snp.bottom)
            $0.left.right.equalTo(view)
        }
        
        view.addSubview(starshipsLabel)
        starshipsLabel.snp.makeConstraints {
            $0.top.equalTo(speciesLabel.snp.bottom)
            $0.left.right.equalTo(view)
        }
        
        view.addSubview(createEditLabel)
        createEditLabel.snp.makeConstraints {
            $0.top.equalTo(starshipsLabel.snp.bottom)
            $0.left.right.equalTo(view)
        }
        
        activityIndicator.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 20, height: 20))
        }
        activityIndicator.color = UIColor.swapiGreen
        let barButton = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.setRightBarButton(barButton, animated: true)

    }
    
    func downloadPersonDetails(pobject: jsonPersonSearchObject.PersonObject, completion: @escaping (Person?) -> Void ){
        nameLabel.alpha = 0
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
        
        nameLabel.textColor = textColor
        homeworldLabel.textColor = textColor
        filmsLabel.textColor = textColor
        speciesLabel.textColor = textColor
        vehiclesLabel.textColor = textColor
        starshipsLabel.textColor = textColor
        createEditLabel.textColor = textColor
        
        nameLabel.numberOfLines = 0
        nameLabel.text = "Name: \(p.name)\nHeight: \(p.height)\nMass: \(p.mass)\nHair color: \(p.hair_color)\nSkin color: \(p.skin_color)\nEye color: \(p.eye_color)\nBirth year: \(p.birth_year)\nGender: \(p.gender)"
        homeworldLabel.numberOfLines = 0
        if let homeworld = p.homeworld {
            homeworldLabel.text =  "Homeworld: \(homeworld)"
        } else {
            homeworldLabel.text = "Homeworld: error?"
        }
        filmsLabel.numberOfLines = 0
        if let films = p.films {
            filmsLabel.text = films
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

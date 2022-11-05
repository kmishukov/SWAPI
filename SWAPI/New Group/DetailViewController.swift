//
//  DetailViewController.swift
//  SWAPI
//
//  Created by Konstantin Mishukov on 09/12/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import UIKit

final class DetailViewController: UIViewController {

    // Views
    private let containerView = UIView(frame: .zero)
    private let textLabel = UILabel(frame: .zero)
    private let activityIndicator = UIActivityIndicatorView(frame: .zero)

    // Data
    private var person: Person?
    private var apiPerson: SearchPersonResponse.Person?

    init() {
        person = nil
        apiPerson = nil
        super.init(nibName: nil, bundle: nil)
    }

    convenience init(person: Person) {
        self.init()
        self.person = person
    }

    convenience init(apiPerson: SearchPersonResponse.Person) {
        self.init()
        self.apiPerson = apiPerson
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.swapiBackground
        setupViews()

        if let apiPerson = apiPerson {
            // Two methods of gathering person details;

//            downloadPersonDetails(pobject: apiPerson) { person in
//                DispatchQueue.main.async {
//                    self.activityIndicator.stopAnimating()
//                    guard let person = person else {
//                        return
//                    }
//                    DataController.savePerson(person: person)
//                    self.updateView(p: person, textColor: UIColor.swapiGreen)
//                    self.activityIndicator.stopAnimating()
//                    UIView.animate(withDuration: 0.5, animations: {
//                        self.textLabel.alpha = 1
//                    })
//                }
//            }

            Task {
                let person = await downloadDetails(responsePerson: apiPerson)
                if let person = person {
                    DataController.savePerson(person: person)
                    self.updateView(person: person, textColor: UIColor.swapiGreen)
                    self.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.5, animations: {
                        self.textLabel.alpha = 1
                    })
                }
            }
        } else if let person = person {
            updateView(person: person, textColor: UIColor.swapiYellow)
        }
    }

    private func setupViews() {
        view.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.top.equalTo(view.snp.topMargin).inset(5)
            $0.bottom.equalTo(view)
            $0.left.right.equalTo(view).inset(10)
        }

        textLabel.numberOfLines = 0
        containerView.addSubview(textLabel)
        textLabel.snp.makeConstraints {
            $0.left.top.right.equalTo(containerView)
        }

        activityIndicator.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 20, height: 20))
        }
        activityIndicator.color = UIColor.swapiGreen
        let barButton = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.setRightBarButton(barButton, animated: true)

    }

    func downloadPersonDetails(pobject: SearchPersonResponse.Person, completion: @escaping (Person?) -> Void ) {
        textLabel.alpha = 0
        activityIndicator.startAnimating()
        let person = SWAPI.downloadPersonDetails(object: pobject)
        completion(person)
    }

    func downloadDetails(responsePerson: SearchPersonResponse.Person) async -> Person? {
        textLabel.alpha = 0
        activityIndicator.startAnimating()
        return await SWAPI.downloadPersonDetails(responsePerson)
    }

    func updateView(person: Person, textColor: UIColor) {
        textLabel.textColor = textColor

        let boldFont = UIFont.systemFont(ofSize: 17, weight: .bold)
        let boldAttributes: [NSAttributedString.Key: Any] = [.font: boldFont]
        let medFont = UIFont.systemFont(ofSize: 17, weight: .regular)
        let medAttributes: [NSAttributedString.Key: Any] = [.font: medFont]

        // Name
        let attributedText = NSMutableAttributedString(string: "Name: ", attributes: boldAttributes)
        attributedText.append(NSMutableAttributedString(string: person.name, attributes: medAttributes))
        // Mass
        attributedText.append(NSMutableAttributedString(string: "\nMass: ", attributes: boldAttributes))
        attributedText.append(NSMutableAttributedString(string: person.mass, attributes: medAttributes))
        // Hair
        attributedText.append(NSMutableAttributedString(string: "\nHair color: ", attributes: boldAttributes))
        attributedText.append(NSMutableAttributedString(string: person.hairColor, attributes: medAttributes))
        // Skin
        attributedText.append(NSMutableAttributedString(string: "\nSkin color: ", attributes: boldAttributes))
        attributedText.append(NSMutableAttributedString(string: person.skinColor, attributes: medAttributes))
        // Eye
        attributedText.append(NSMutableAttributedString(string: "\nEye color: ", attributes: boldAttributes))
        attributedText.append(NSMutableAttributedString(string: person.eyeColor, attributes: medAttributes))
        // Birth
        attributedText.append(NSMutableAttributedString(string: "\nBirth year: ", attributes: boldAttributes))
        attributedText.append(NSMutableAttributedString(string: person.birthYear, attributes: medAttributes))
        // Gender
        attributedText.append(NSMutableAttributedString(string: "\nGender: ", attributes: boldAttributes))
        attributedText.append(NSMutableAttributedString(string: person.gender, attributes: medAttributes))
        // HomeWorld
        attributedText.append(NSMutableAttributedString(string: "\nHomeWorld: ", attributes: boldAttributes))
        attributedText.append(NSMutableAttributedString(string: person.homeworld ?? "none", attributes: medAttributes))
        // Films
        attributedText.append(NSMutableAttributedString(string: "\nFilms: ", attributes: boldAttributes))
        attributedText.append(NSMutableAttributedString(string: person.films ?? "none", attributes: medAttributes))
        // Species
        attributedText.append(NSMutableAttributedString(string: "\nSpecies: ", attributes: boldAttributes))
        attributedText.append(NSMutableAttributedString(string: person.species ?? "none", attributes: medAttributes))
        // Vehicles
        attributedText.append(NSMutableAttributedString(string: "\nVehicles: ", attributes: boldAttributes))
        attributedText.append(NSMutableAttributedString(string: person.vehicles ?? "none", attributes: medAttributes))
        // Starships
        attributedText.append(NSMutableAttributedString(string: "\nStarhips: ", attributes: boldAttributes))
        attributedText.append(NSMutableAttributedString(string: person.starships ?? "none", attributes: medAttributes))
        // Created
        attributedText.append(NSMutableAttributedString(string: "\n\nCreated: ", attributes: boldAttributes))
        attributedText.append(NSMutableAttributedString(string: person.created, attributes: medAttributes))
        // Edited
        attributedText.append(NSMutableAttributedString(string: "\nEdited: ", attributes: boldAttributes))
        attributedText.append(NSMutableAttributedString(string: person.edited, attributes: medAttributes))
        // URL
        attributedText.append(NSMutableAttributedString(string: "\n\nURL: ", attributes: boldAttributes))
        attributedText.append(NSMutableAttributedString(string: person.url, attributes: medAttributes))

        textLabel.attributedText = attributedText
    }
}

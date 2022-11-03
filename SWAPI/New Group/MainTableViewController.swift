//
//  MainTableViewController.swift
//  SWAPI
//
//  Created by Konstantin Mishukov on 06/12/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import UIKit
import CoreData

@objc
class MainTableViewController: UITableViewController {
    
    var personsFromData: [PersonData]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "SWAPI"
        tableView.register(CharacterCell.self, forCellReuseIdentifier: "swapiCell")
        let button = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
        navigationItem.setRightBarButton(button, animated: false)
        navigationItem.rightBarButtonItem?.tintColor = UIColor.swapiYellow
        
//        addBannerLabel()
        configureColorTheme()
//        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        personsFromData = DataHandler.fetchPersons()
        tableView.reloadData()
    }
    
    func addBannerLabel() {
        let banner = UILabel()
        banner.text = "Made by\n Mishukov Konstantin"
        banner.textColor = UIColor.swapiYellow
        banner.numberOfLines = 0
        banner.frame = CGRect(x: view.frame.size.width/2 - 100, y: -(view.frame.size.height * 0.15), width: 200, height: 50)
        banner.textAlignment = .center
        tableView.addSubview(banner)
    }
    
    func configureNavigationBar(){
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.swapiTitleBackground
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.swapiYellow
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.swapiYellow]
        self.navigationController?.navigationBar.backItem?.leftBarButtonItem?.tintColor = UIColor.swapiYellow
    }
    
    // MARK: - TableView Delegates
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let person = personsFromData {
            return person.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "swapiCell", for: indexPath) as! CharacterCell
        if let person = personsFromData?[indexPath.row] {
            cell.name.text = person.name
        }
        cell.contentView.alpha = 0
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.4, animations: {
            cell.contentView.alpha = 1
        }, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let object = personsFromData?[indexPath.row] else { print("DELETE Error: personsFromData?[indexPath] returned nil"); return }
            DataHandler.removePersonObject(data: object)
            personsFromData = DataHandler.fetchPersons()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let personData = personsFromData?[indexPath.row] else { print("Prepare ERROR: personsFromData[index] returned nil"); return }
        let detailVC = DetailViewController(person: Person(data: personData))
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    @objc func didTapSearch() -> Void {
        navigationController?.pushViewController(SearchViewController(), animated: true)
    }
}

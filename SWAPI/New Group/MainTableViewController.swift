//
//  MainTableViewController.swift
//  SWAPI
//
//  Created by Konstantin Mishukov on 06/12/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import UIKit
import CoreData

class MainTableViewController: UITableViewController {
    
    var personsFromData: [PersonData]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBannerLabel()
        configureColorTheme()
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        personsFromData = DataHandler.fetchPersons()
        tableView.reloadData()
    }
    
    func addBannerLabel() {
        let banner = UILabel()
        banner.text = "Здесь могла бы быть ваша реклама"
        banner.textColor = UIColor.swapiYellow
        banner.numberOfLines = 0
        banner.frame = CGRect(x: view.frame.size.width/2 - 100, y: -150, width: 200, height: 50)
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
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if personsFromData?.count == 0 {
            return nil
        } else {
            return "  Recently searched:"
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let person = personsFromData {
            return person.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "swapiCell", for: indexPath) as! SwapiCell
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
    
    // Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDataDetail" {
            guard let index = tableView.indexPathForSelectedRow?.row else { print("Prepare ERROR: indexPathForSelectedRow returned nil"); return }
            guard let personData = personsFromData?[index] else { print("Prepare ERROR: personsFromData[index] returned nil"); return }
            let destination = segue.destination as! DetailViewController
            destination.person = Person(data: personData)
        }
    }
    
}

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
        configureColorTheme()
        configureNavigationBar()
        personsFromData = DataHandler.fetchPersons()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        personsFromData = DataHandler.fetchPersons()
        tableView.reloadData()
        
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

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
       return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let count = personsFromData?.count else { return nil }
            if section == 0 && count != 0 {
                return "  Recently searched:"
            } else {
                return " No data, use search"
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
            if let object = personsFromData?[indexPath.row] {
                DataHandler.removePersonObject(data: object)
//                personsFromData = DataHandler.fetchPersons()
                personsFromData?.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDataDetail" {
            guard let index = tableView.indexPathForSelectedRow?.row else { print("Prepare ERROR: indexPathForSelectedRow returned nil"); return }
            guard let personData = personsFromData?[index] else { print("Prepare ERROR: personsFromData[index] returned nil"); return }
            let destination = segue.destination as! DetailViewController
            destination.person = Person(data: personData)
        }
    }
    
}

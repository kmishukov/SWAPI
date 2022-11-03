//
//  MainTableViewController.swift
//  SWAPI
//
//  Created by Konstantin Mishukov on 06/12/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import UIKit
import CoreData

class MainTableViewController: BaseViewController {
    var personsFromData: [PersonData]?
    
    // MARK: Init
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        title = "SWAPI"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        addSearchButton()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CharacterCell.self, forCellReuseIdentifier: CharacterCell.identifier)
    }
    
    private func addSearchButton() {
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
        navigationItem.setRightBarButton(searchButton, animated: false)
        navigationItem.rightBarButtonItem?.tintColor = UIColor.swapiYellow
    }
    
    override func viewWillAppear(_ animated: Bool) {
        personsFromData = DataHandler.fetchPersons()
        tableView.reloadData()
    }
    
    // MARK: Selector Actions
    
    @objc func didTapSearch() -> Void {
        navigationController?.pushViewController(SearchViewController(), animated: true)
    }
}

// MARK: UITableViewDelegate
extension MainTableViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        personsFromData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.4, animations: {
            cell.contentView.alpha = 1
        }, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let object = personsFromData?[indexPath.row] else { print("DELETE Error: personsFromData?[indexPath] returned nil"); return }
            DataHandler.removePersonObject(data: object)
            personsFromData = DataHandler.fetchPersons()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let personData = personsFromData?[indexPath.row] else { print("Prepare ERROR: personsFromData[index] returned nil"); return }
        let detailVC = DetailViewController(person: Person(data: personData))
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UITableViewDatasource
extension MainTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CharacterCell.identifier, for: indexPath) as! CharacterCell
        if let person = personsFromData?[indexPath.row] {
            cell.name.text = person.name
        }
        cell.contentView.alpha = 0
        return cell
    }
}

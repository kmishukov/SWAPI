//
//  SearchViewController.swift
//  SWAPI
//
//  Created by Konstantin Mishukov on 07/12/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CustomSearchBarDelegate {

    var searchResults: [jsonPersonSearchObject.PersonObject]? {
        didSet {
            tableView.reloadData()
        }
    }

    let tableView = UITableView(frame: .zero)
    let searchBar = CustomSearchBar(frame: .zero)
    
    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        configureView()
    }
    
    func configureView(){
        view.backgroundColor = UIColor.swapiBackground
        
        activityIndicator.color = UIColor.swapiYellow
        let barButton = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.setRightBarButton(barButton, animated: true)
    }
    
    func setupViews(){
        self.view.backgroundColor = UIColor.swapiBackground
        searchBar.delegate = self
//        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints{
            $0.top.equalTo(view.snp_topMargin)
            $0.left.right.equalTo(view)
            $0.height.equalTo(55)
        }
//        NSLayoutConstraint.activate([
//            searchBar.topAnchor.constraint(equalTo: view.topAnchor),
//            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor),
//            searchBar.rightAnchor.constraint(equalTo: view.rightAnchor),
//            searchBar.heightAnchor.constraint(equalToConstant: 55)
//        ])
//
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CharacterCell.self, forCellReuseIdentifier: "swapiCell")
        tableView.configureColorTheme()
//        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.left.right.bottom.equalTo(view)
            $0.top.equalTo(searchBar.snp.bottom)
        }
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
//            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
//        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchBar.textField.becomeFirstResponder()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if let count = searchResults?.count {
            if count != 0  {
                tableView.separatorStyle = .singleLine
                numOfSections = 1
                tableView.backgroundView = nil
            } else {
                let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                noDataLabel.text = "Nothing found"
                noDataLabel.textColor = UIColor.swapiYellow
                noDataLabel.textAlignment = .center
                tableView.backgroundView = noDataLabel
                tableView.separatorStyle = .none
            }
        } else {
            numOfSections = 1
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
        }
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = searchResults?.count {
          return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "swapiCell", for: indexPath) as! CharacterCell
        if let array = searchResults, array.isEmpty == false {
            cell.name.text = array[indexPath.row].name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let results = searchResults {
            let result = results[indexPath.row]
            let detailVC = DetailViewController()
            detailVC.personObject = result
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.textField.resignFirstResponder()
    }
    
    func cancelBtnPressed(){
        searchResults = nil
        tableView.reloadData()
    }
    
    func searchForText(searchText: String) {
        activityIndicator.startAnimating()
            updateSearchResults(text: searchText)
    }
    
    var lastPerformedArgument: NSString? = nil
    func updateSearchResults(text: String) {
        NSObject.cancelPreviousPerformRequests(
            withTarget: self,
            selector: #selector(searchForPerson(with:)),
            object: lastPerformedArgument)
        print("Canceled request with: \(String(describing: lastPerformedArgument)).")
        self.lastPerformedArgument = text as NSString
        self.perform(
            #selector(searchForPerson(with:)),
            with: text,
            afterDelay: 0.75)
    }
    
    @objc func searchForPerson(with str: String) {
        SWAPI.searchPerson(forString: str) { (personObjectArray) in
            if let array = personObjectArray {
                self.searchResults = array
                self.activityIndicator.stopAnimating()
            } else {
                let alert = UIAlertController(title: "Error", message: "Could not recieve search results", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = tableView.indexPathForSelectedRow
        if segue.identifier == "showDetails" {
            let destination = segue.destination as! DetailViewController
            destination.personObject = searchResults![indexPath!.row]
        }
    }
    
}

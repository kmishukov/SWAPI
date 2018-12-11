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

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: CustomSearchBar!
    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureView()
    }
    
    func configureView(){
        view.backgroundColor = UIColor.swapiBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.configureColorTheme()
        searchBar.delegate = self
        
        activityIndicator.color = UIColor.swapiYellow
        let barButton = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.setRightBarButton(barButton, animated: true)
    }
    
    func setupView(){
        self.view.backgroundColor = UIColor.swapiBackground
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "swapiCell", for: indexPath) as! SwapiCell
        if let array = searchResults, array.isEmpty == false {
            cell.name.text = array[indexPath.row].name
        }
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.textField.resignFirstResponder()
    }

    
    func textFieldDidBeginEditing() {
//        print("Begin editing")
    }
    
    func textFieldDidEndEditing() {
//        print("End editing")
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
            afterDelay: 0.3)
    }
    
    @objc func searchForPerson(with: String) {
        SWAPI.searchPerson(forString: with) { (personObjectArray) in
            if let array = personObjectArray {
                self.searchResults = array
                self.activityIndicator.stopAnimating()
            } else {
                let alert = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
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

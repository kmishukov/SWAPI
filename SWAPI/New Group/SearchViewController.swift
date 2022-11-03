//
//  SearchViewController.swift
//  SWAPI
//
//  Created by Konstantin Mishukov on 07/12/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import UIKit

class SearchViewController: BaseViewController {
    // Data
    var searchResults: [SearchPersonResult.Person]? {
        didSet {
            noDataLabel.isHidden = (searchResults?.count ?? 0) > 0
            tableView.reloadData()
        }
    }

    // Views
    let searchBar = CustomSearchBar(frame: .zero)
    let activityIndicator = {
        let indicator = UIActivityIndicatorView(frame: .zero)
        indicator.color = UIColor.swapiYellow
        indicator.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 20, height: 20))
        }
        return indicator
    }()
    let noDataLabel = UILabel(frame: .zero)
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        self.view.backgroundColor = UIColor.swapiBackground
        setupSearchBar()
        setupTableView()
        setupIndicatorView()
        setupNoDataLabel()
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints{
            $0.top.equalTo(view.snp_topMargin)
            $0.left.right.equalTo(view)
            $0.height.equalTo(55)
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CharacterCell.self, forCellReuseIdentifier: CharacterCell.identifier)
        tableView.snp.remakeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.left.right.bottom.equalTo(view)
        }
    }
    
    private func setupIndicatorView() {
        let barButton = UIBarButtonItem(customView: activityIndicator)
        self.navigationItem.setRightBarButton(barButton, animated: true)
    }
    
    private func setupNoDataLabel() {
        noDataLabel.text = "Nothing found"
        noDataLabel.isHidden = true
        noDataLabel.textColor = UIColor.swapiYellow
        noDataLabel.textAlignment = .center
        view.addSubview(noDataLabel)
        noDataLabel.snp.makeConstraints {
            $0.edges.equalTo(view)
        }
    }
    
    // MARK: - LifeCycle
    
    override func viewDidAppear(_ animated: Bool) {
        searchBar.textField.becomeFirstResponder()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.textField.resignFirstResponder()
    }
    
    // MARK: - Private 
    
    private var lastPerformedArgument: NSString? = nil
    private func updateSearchResults(text: String) {
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
        activityIndicator.startAnimating()
        SWAPI.searchPerson(forString: str) { (personObjectArray) in
            self.activityIndicator.stopAnimating()
            if let array = personObjectArray {
                self.searchResults = array
            } else {
                let alert = UIAlertController(title: "Error", message: "Could not recieve search results", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResults?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CharacterCell.identifier, for: indexPath)
        (cell as? CharacterCell)?.name.text = searchResults?[indexPath.row].name
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let person = searchResults?[indexPath.row] else { return }
        let detailVC = DetailViewController(personObject: person)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - CustomSearchBarDelegate {
extension SearchViewController: CustomSearchBarDelegate {
    func textDidChange(searchBar: CustomSearchBar, text: String) {
        updateSearchResults(text: text)
    }
    
    func cancelButtonPressed(on searchBar: CustomSearchBar) {
//        searchResults = nil
    }
}

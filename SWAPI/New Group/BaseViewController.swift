//
//  BaseViewController.swift
//  SWAPI
//
//  Created by Konstantin Mishukov on 03.11.2022.
//  Copyright © 2022 Konstantin Mishukov. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    let tableView = UITableView(frame: .zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view)
        }
        configureColorTheme()
    }
    
    private func configureColorTheme() {
        tableView.backgroundColor = UIColor.swapiBackground
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .zero
        tableView.separatorColor = UIColor.swapiYellow
    }
}

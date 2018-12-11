//
//  SwapiCell.swift
//  SWAPI
//
//  Created by Konstantin Mishukov on 09/12/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import UIKit

class SwapiCell: UITableViewCell {
    
    let name = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        self.backgroundColor = UIColor.swapiBackground
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    private func setupView(){
        name.translatesAutoresizingMaskIntoConstraints = false
        name.textColor = UIColor.swapiYellow
        self.contentView.addSubview(name)
        name.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8).isActive = true
        name.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8).isActive = true
        name.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
    }
    
}

//
//  CharacterCell.swift
//  SWAPI
//
//  Created by Konstantin Mishukov on 09/12/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import UIKit

class CharacterCell: UITableViewCell {
    static let identifier = "CharacterCell"
    let name = UILabel(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = UIColor.swapiBackground
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    private func setupView(){
        name.textColor = UIColor.swapiYellow
        contentView.addSubview(name)
        name.snp.makeConstraints {
            $0.leading.equalTo(contentView).inset(8)
            $0.trailing.equalTo(contentView).inset(-8)
            $0.centerY.equalTo(contentView)
        }
    }
}

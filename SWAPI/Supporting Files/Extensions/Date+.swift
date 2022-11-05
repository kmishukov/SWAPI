//
//  Date+.swift
//  SWAPI
//
//  Created by Konstantin Mishukov on 05.11.2022.
//  Copyright © 2022 Konstantin Mishukov. All rights reserved.
//

import Foundation

extension Date {
    func asString(style: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: self)
    }
}

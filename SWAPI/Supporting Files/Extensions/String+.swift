//
//  String+.swift
//  SWAPI
//
//  Created by Konstantin Mishukov on 05.11.2022.
//  Copyright © 2022 Konstantin Mishukov. All rights reserved.
//

import Foundation

extension String {
    func toDate(withFormat format: String = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        guard let date = dateFormatter.date(from: self) else {
            return self
        }
        return date.asString(style: .long)
    }
}

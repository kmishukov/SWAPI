//
//  HomeworldRequest.swift
//  SWAPI
//
//  Created by Konstantin Mishukov on 10/12/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import Foundation

class HomeworldResponse: Codable {
    var name: String
}

extension SWAPI {
    static func getHomeworld(url: String, completion: @escaping (_ name: String?) -> Void) {
        APIManager.networkRequest(url: url, parameter: nil) { response in
            guard let data = response.data else { completion(nil); return }
            do {
                let decoder = JSONDecoder()
                let homeworldResult = try decoder.decode(HomeworldResponse.self, from: data)
                let name = homeworldResult.name
                completion(name)
            } catch {
                print(error)
            }
        }
    }
}


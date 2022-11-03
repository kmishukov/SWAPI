//
//  SWAPI.swift
//  SWAPI
//
//  Created by Konstantin Mishukov on 12/12/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import Foundation

class SWAPI {
    static func searchPerson(forString string: String, completion: @escaping ([jsonPersonSearchObject.PersonObject]?) -> ()) -> () {
        let url = "https://swapi.dev/api/people/?search="
        APIManager.networkRequest(url: url, parameter: string) { (recieved) in
            if let data = recieved.data {
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(jsonPersonSearchObject.self, from: data)
                    print("Successfully received JSON.")
                    completion(response.results)
                } catch {
                    print(error)
                }
            } else {
                completion(nil)
            }
        }
    }
}

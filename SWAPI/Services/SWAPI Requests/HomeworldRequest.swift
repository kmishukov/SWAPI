//
//  HomeworldRequest.swift
//  SWAPI
//
//  Created by Konstantin Mishukov on 10/12/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import Foundation

struct HomeworldResponse: Codable {
    let name: String
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
            } catch let err {
                print(err.localizedDescription)
            }
        }
    }

    static func getHomeworld(urlStr: String) async -> String? {
        guard let url = URL(string: urlStr) else { return nil }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let homeworldResult = try JSONDecoder().decode(HomeworldResponse.self, from: data)
            return homeworldResult.name
        } catch let err {
            print(err.localizedDescription)
        }
        return nil
    }
}

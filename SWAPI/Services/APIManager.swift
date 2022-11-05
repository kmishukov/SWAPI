//
//  APIManager.swift
//  SWAPI
//
//  Created by Konstantin Mishukov on 09/12/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import Foundation

struct ApiReturn {
    let error: NSError?
    let data: Data?
    let response: URLResponse?
}

final class APIManager {
    static func networkRequest(url: String, parameter: String?, completion: @escaping (ApiReturn) -> Void) {
        HTTPRequest.request(url: url, parameter: parameter) { (data, response, error) in
            completion(ApiReturn(error: error as? NSError, data: data, response: response))
        }
    }
}

final class HTTPRequest {
    static func request(url: String,
                       parameter: String?,
                       completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        var urlString = ""
        if let param = parameter {
            let parameterChecked = param.replacingOccurrences(of: " ", with: "%20")
            urlString = url + parameterChecked
        } else {
            urlString = url
        }
        let requestURL = URL(string: urlString)
        print("URLRequest: \(urlString)")
        let request = NSMutableURLRequest(url: requestURL!)
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForResource = 10
        config.timeoutIntervalForRequest = 10
        let task = URLSession(configuration: config).dataTask(with: request as URLRequest) { (data, response, error) in
            DispatchQueue.main.async(execute: {
                print("URLRequest: \(urlString) end")
                if error != nil {
                    print("Error -> \(String(describing: error))")
                    completion(nil, nil, error)
                } else {
                    completion(data, response, nil)
                }
            })
        }
        task.resume()
    }
}

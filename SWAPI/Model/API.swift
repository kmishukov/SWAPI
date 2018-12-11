//
//  API.swift
//  SWAPI
//
//  Created by Konstantin Mishukov on 09/12/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import Foundation

public struct apiReturn {
    public var error: NSError?
    public var data: Data?
    public var response: URLResponse?
}


class API {
    static func networkRequest(url: String, parameter: String?, completion: @escaping (apiReturn) -> ()) {
        var recieved = apiReturn()
        HTTPRequest.request(url: url, parameter: parameter) { (data, response, error) in
            recieved.data = data
            recieved.response = response
            if let error = error {
                recieved.error = error as NSError
            }
            completion(recieved)
        }
    }
}

class HTTPRequest {
    class func request(url: String, parameter: String?, completionHandler: @escaping (_ data: Data?,_ response: URLResponse?,_ error: Error?) -> ()) -> () {
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
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            DispatchQueue.main.async(execute: {
                if error != nil {
                    print("Error -> \(String(describing: error))")
                    completionHandler(nil,nil,error)
                } else {
                    completionHandler(data, response, nil)
                }
            })
        }
        task.resume()
    }
}

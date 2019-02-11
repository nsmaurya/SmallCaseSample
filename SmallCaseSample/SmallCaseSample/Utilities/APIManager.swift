//
//  APIManager.swift
//  SmallCaseSample
//
//  Created by Sunil on 23/01/19.
//  Copyright © 2019 SNCorp. All rights reserved.
//

import Foundation

private let _sharedInstance = APIManager()
class APIManager {
    
    fileprivate init(){}
    
    static var sharedInstance: APIManager {
        return _sharedInstance
    }
    func getData(urlString: String, parameter: String, onSuccess:@escaping (Data)->(), onFailure:@escaping (Error)->()) {
        let appendedParameterWithURL: String = "\(urlString)\(parameter)"
        guard let url: URL = URL(string: appendedParameterWithURL) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    onFailure(error!)
                    return
            }
            onSuccess(dataResponse)
        }
        task.resume()
    }
}

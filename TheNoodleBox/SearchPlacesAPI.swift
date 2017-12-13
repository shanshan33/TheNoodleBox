//
//  LocationAPIService.swift
//  TheNoodleBox
//
//  Created by Shanshan Zhao on 13/12/2017.
//  Copyright © 2017 Shanshan Zhao. All rights reserved.
//

import Foundation
import GooglePlaces

public enum Result<Value> {
    case success(Value)
    case failure(Error?)
}

enum JSONError: Error {
    case NoData
    case ConversionFailed
}

class SearchPlacesAPI {
    func fetchRequestPlaces(_ urlString: String, withCompletion completion: ((Result<SearchResult>) -> Void)?) {
        guard let requestUrl = URL(string:urlString) else { return }
        let request = URLRequest(url:requestUrl)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            do {
                guard let data = data else {
                    throw JSONError.NoData
                }
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? JSON {
                    guard let results = try? SearchResult.init(with: json) else {
                        throw JSONError.ConversionFailed
                    }
                    completion!(.success(results))
                } else {
                    throw JSONError.ConversionFailed
                }
            } catch let error as NSError {
                print(error.debugDescription)
            }
            }.resume()
    }
}

//
//  Place.swift
//  TheNoodleBox
//
//  Created by Shanshan Zhao on 13/12/2017.
//  Copyright © 2017 Shanshan Zhao. All rights reserved.
//

import Foundation

public struct SearchResult {
    let results: [Place]?
    let status: String?
}

extension SearchResult {
    public init( status: String? = nil, results: [Place]? = nil) {
        self.results = results
        self.status = status
    }
}

extension SearchResult: JSONInitializable {
    public enum Key: String {
        case results = "results"
        case status = "status"
    }
    
    public init(with json: JSON) throws {
        var results: [Place] = []
        for case let result in (json["results"] as? [JSON])! {
            let place = try Place.init(with: result)
            results.append(place)
        }
        self.results = results
        self.status = SearchResult.optionalValue(for: .status, in: json)
    }
}

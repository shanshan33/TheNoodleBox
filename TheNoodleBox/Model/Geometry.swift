//
//  Geometry.swift
//  TheNoodleBox
//
//  Created by Shanshan Zhao on 25/01/2018.
//  Copyright © 2018 Shanshan Zhao. All rights reserved.
//

import Foundation

public struct Geometry {
    let location: Location?
}

extension Geometry {
    public init(location: Location) {
        self.location = location
    }
}

extension Geometry: JSONInitializable {
    public enum Key: String {
        case location   = "location"
    }
    
    public init(with json: JSON) throws {
        self.location  = try Geometry.optionalValue(for: .location, in: json).flatMap(Location.init(with: ))
    }
}

//
//  Location.swift
//  TheNoodleBox
//
//  Created by Shanshan Zhao on 25/01/2018.
//  Copyright © 2018 Shanshan Zhao. All rights reserved.
//

import Foundation

public struct Location {
    let latitude: Double?
    let Longitude: Double?
}

extension Location {
    public init(Longitude: Double?, latitude: Double?) {
        self.latitude = latitude
        self.Longitude = Longitude
    }
}

extension Location: JSONInitializable {
    public enum Key: String {
        case latitude   = "lat"
        case Longitude = "lng"
    }
    
    public init(with json: JSON) throws {
        self.latitude  = Location.optionalValue(for: .latitude, in: json)
        self.Longitude   = Location.optionalValue(for: .Longitude, in: json)
    }
}

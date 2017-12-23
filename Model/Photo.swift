//
//  Photo.swift
//  TheNoodleBox
//
//  Created by Shanshan Zhao on 14/12/2017.
//  Copyright © 2017 Shanshan Zhao. All rights reserved.
//

import Foundation

public struct Photo {
    var height: Double?
    var weight: Double?
    var reference: String?
}

extension Photo {
    public init(weight: Double?, height: Double?, reference: String?) {
        self.height = height
        self.weight = weight
        self.reference = reference
    }
}

extension Photo: JSONInitializable {
    
    public enum Key: String {
        case height  = "height"
        case weight  = "width"
        case reference = "photo_reference"
    }
    
    public init(with json: JSON) throws {
        self.height  = Photo.optionalValue(for: .height, in: json)
        self.weight   = Photo.optionalValue(for: .weight, in: json)
        self.reference = Photo.optionalValue(for: .reference, in: json)
    }
}

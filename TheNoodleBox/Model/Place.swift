//
//  Place.swift
//  TheNoodleBox
//
//  Created by Shanshan Zhao on 13/12/2017.
//  Copyright © 2017 Shanshan Zhao. All rights reserved.
//

import Foundation

public struct Place {
    let icon: String?
    let placeID: String?
    let name: String?
    let rating: Double?
    let address: String?
    let photos: [Photo]?
    let types: [String]?
    let geometry: Geometry?
}

extension Place {
    public init(icon: String?, placeID: String?, name:String?, address:String?, rating: Double?, photos: [Photo]? = nil, types: [String]? = nil, geometry: Geometry) {
        self.icon = icon
        self.placeID = placeID
        self.name = name
        self.rating = rating
        self.address = address
        self.photos = photos
        self.types = types
        self.geometry = geometry
        
    }
}

extension Place: JSONInitializable {

    public enum Key: String {
        case icon    = "icon"
        case id      = "id"
        case name    = "name"
        case rating  = "rating"
        case address = "vicinity"
        case photos  = "photos"
        case types   = "types"
        case geometry =  "geometry"
    }
    
    public init(with json: JSON) throws {
        self.placeID = Place.optionalValue(for: .id, in: json)
        self.icon   = Place.optionalValue(for: .icon, in: json)
        self.name = Place.optionalValue(for: .name, in: json)
        self.rating = Place.optionalValue(for: .rating, in: json)
        self.address = Place.optionalValue(for: .address, in: json)
        self.geometry  = try Place.optionalValue(for: .geometry, in: json).flatMap(Geometry.init(with: ))

        var typesResult: [String] = []
        
        if let typeJson = json["types"] as? [String] {
            for type in typeJson {
                typesResult.append(type)
            }
        }
        
        self.types = typesResult
        
        var results: [Photo] = []
        var photo: Photo?
        if json["photos"] != nil {
            for case let result in (json["photos"] as? [JSON])! {
                photo = try Photo.init(with: result)
                results.append(photo!)
            }
        }
        self.photos = results
    }
}


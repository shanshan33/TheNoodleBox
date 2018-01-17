//
//  Noodle.swift
//  TheNoodleBox
//
//  Created by Shanshan Zhao on 17/01/2018.
//  Copyright © 2018 Shanshan Zhao. All rights reserved.
//

import UIKit

public struct Noodle {
    var title: String?
    var restaurantName: String?
    var image: UIImage?
}

extension Noodle {
    public init(title: String?, image: UIImage?, restaurantName: String?) {
        self.title = title
        self.restaurantName = restaurantName
        self.image = image
    }
}

//
//  NoodleCell.swift
//  TheNoodleBox
//
//  Created by Shanshan Zhao on 17/01/2018.
//  Copyright © 2018 Shanshan Zhao. All rights reserved.
//

import UIKit

class NoodleCell: UICollectionViewCell {
    
    @IBOutlet weak var noodleImageView: UIImageView!
    @IBOutlet weak var noodleNameLabel: UILabel!
    @IBOutlet weak var restaurantLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        noodleImageView.clipsToBounds = true
        noodleImageView.layer.cornerRadius = 15
    }
    
    func configureCell(noodle: Noodle){
        noodleImageView.image = noodle.image
        noodleNameLabel.text  = noodle.title
        restaurantLabel.text  = noodle.restaurantName
    }
}

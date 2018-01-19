//
//  PlaceCollectionViewCell.swift
//  TheNoodleBox
//
//  Created by Shanshan Zhao on 13/12/2017.
//  Copyright © 2017 Shanshan Zhao. All rights reserved.
//

import UIKit

class PlaceCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImageView.clipsToBounds = true
        iconImageView.layer.cornerRadius = 10
    }
    
    public func configCell(viewModel:PlaceViewModel) {
        self.nameLabel.text = viewModel.name
        self.addressLabel.text = viewModel.address
        self.iconImageView.image = viewModel.placeImage
    }

}

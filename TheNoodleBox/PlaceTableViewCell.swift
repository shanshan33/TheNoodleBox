//
//  PlaceTableViewCell.swift
//  TheNoodleBox
//
//  Created by Shanshan Zhao on 13/12/2017.
//  Copyright © 2017 Shanshan Zhao. All rights reserved.
//

import UIKit

class PlaceTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configCell(viewModel:PlaceViewModel) {
        self.nameLabel.text = viewModel.name
        self.addressLabel.text = viewModel.address
//        viewModel.fetchPlaceIcon(url: viewModel.iconURL!, completion: {(image) in
//            self.iconImageView.image = image
//        })
        
        viewModel.fetchIcon(viewModel: viewModel, completion: {(image) in
            self.iconImageView.image = image
        })
    }

}

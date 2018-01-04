//
//  animateLoadingCell.swift
//  TheNoodleBox
//
//  Created by Shanshan Zhao on 03/01/2018.
//  Copyright © 2018 Shanshan Zhao. All rights reserved.
//

import UIKit

private let origin = CACurrentMediaTime()

class animateLoadingCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .white
    }
    
    // The index of the loading cell, used to shift slightly the timing of the
    // animations between consecutive cells.
    private var index = 0
    
    /// The layer containing the drawing of the cell.
    private lazy var shapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor(white: 0.94, alpha: 1).cgColor
        shapeLayer.path = self.shapePath
        self.layer.addSublayer(shapeLayer)
        return shapeLayer
    }()

    // The path for the shape to draw selon the  PlaceCell
    private var shapePath: CGPath {
        let path = CGMutablePath()
        path.addRect(CGRect(x: 0, y: 0, width: 150, height: 150))
        path.addRect(CGRect(x: 3, y: 161, width: 120, height: 13))
        path.addRect(CGRect(x: 3, y: 184, width: 144, height: 13))
        return path
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        index = (layoutAttributes.indexPath).item
    }

    override func didMoveToSuperview() {
        shapeLayer.removeAllAnimations()
        
        let animation = CABasicAnimation(keyPath: "fillColor")
        animation.autoreverses = true
        animation.beginTime = origin + Double(index) * 0.1
        animation.duration = 1
        animation.fromValue = UIColor(white: 0.94, alpha: 1).cgColor
        animation.repeatCount = .infinity
        animation.toValue = UIColor(white: 0.99, alpha: 1).cgColor
        shapeLayer.add(animation, forKey: nil)
    }


}

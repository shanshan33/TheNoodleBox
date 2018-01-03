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
    
    /// The index of the loading cell, used to shift slightly the timing of the
    /// animations between consecutive cells.
    private var index = 0
    
    /// The layer containing the drawing of the cell.
    private lazy var shapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor(white: 0.94, alpha: 1).cgColor
        shapeLayer.path = self.shapePath
        self.layer.addSublayer(shapeLayer)
        return shapeLayer
    }()

    /// The path for the shape to draw.
    private var shapePath: CGPath {
        let path = CGMutablePath()
        
        path.addEllipse(in: CGRect(x: 12, y: 16, width: 50, height: 50))
        path.addRect(CGRect(x: 74, y: 16, width: 68, height: 11))
        for i in 0..<5 {
            path.addEllipse(in: CGRect(x: 74 + i * 15, y: 37, width: 8, height: 8))
        }
        path.addRect(CGRect(x: 74, y: 55, width: 195, height: 11))
        path.addRect(CGRect(x: 16, y: 86, width: 253, height: 11))
        path.addRect(CGRect(x: 16, y: 109, width: 210, height: 11))
        path.addRect(CGRect(x: 16, y: 132, width: 150, height: 11))
        
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

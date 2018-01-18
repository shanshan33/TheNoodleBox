//
//  appStoreEffectAnimator.swift
//  TheNoodleBox
//
//  Created by Shanshan Zhao on 04/01/2018.
//  Copyright © 2018 Shanshan Zhao. All rights reserved.
//

import UIKit

enum TransitionType {
    case present
    case dismiss
}

class appStoreAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    var type = TransitionType.present
    init(type: TransitionType) {
        self.type = type
    }
    
    let duration = 1.0
    var presenting = true
    var originFrame = CGRect.zero
    var resizeFrame = CGRect.zero
    
    var dismissCompletion: (()->Void)?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch type {
        case .present:
            presentAnimation(originFrame: originFrame, using: transitionContext)
        case .dismiss:
            dismissAnimation(resizeFrame: resizeFrame, using: transitionContext)
        }
    }
    
    /// present
    private func presentAnimation(originFrame: CGRect, using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toView = transitionContext.view(forKey: .to) else {
            return
        }
        let containerView = transitionContext.containerView
        let detailView = toView
        let initialFrame = originFrame
        let finalFrame  = detailView.frame
        
        let xScaleFactor = initialFrame.width / finalFrame.width
        let yScaleFactor = initialFrame.height / finalFrame.height
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        
        detailView.transform = scaleTransform
        detailView.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
        detailView.clipsToBounds = true
        
        containerView.addSubview(toView)
        containerView.bringSubview(toFront: detailView)
        detailView.layer.cornerRadius = 10
        
        UIView.animate(withDuration: duration,
                       delay: 0.0,
                       usingSpringWithDamping: 0.65,
                       initialSpringVelocity: 0.0,
                       options: [],
                       animations: {
                        detailView.layer.cornerRadius = 0
                        detailView.transform = CGAffineTransform.identity
                        detailView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
        }, completion: { finished in transitionContext.completeTransition(true)
        })
    }
    
    /// dismiss
    private func dismissAnimation(resizeFrame: CGRect, using transitionContext: UIViewControllerContextTransitioning) {
       
        guard let fromView = transitionContext.view(forKey: .from) else {
            return
        }
        
        guard let toView = transitionContext.view(forKey: .to) else {
            return
        }
        
        let containerView = transitionContext.containerView
 //       let placeCell = toView
        let initialFrame = resizeFrame
        let finalFrame  = originFrame
        
        let xScaleFactor = finalFrame.width / initialFrame.width
        let yScaleFactor = finalFrame.height / initialFrame.height
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        
        UIView.animate(withDuration: 1, delay: 0, options:.curveEaseIn, animations: {
            fromView.frame = initialFrame
            fromView.layer.cornerRadius = 10
 //           fromView.alpha = 0
        }, completion: nil)
        
        containerView.addSubview(toView)
        containerView.bringSubview(toFront: fromView)

        UIView.animate(withDuration: duration, animations: {
            fromView.transform = scaleTransform
            fromView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
        }, completion: { finished in
            transitionContext.completeTransition(true)
        })
    }

}


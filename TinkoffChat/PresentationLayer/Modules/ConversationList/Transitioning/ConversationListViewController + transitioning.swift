//
//  ConversationListViewController + transitioning.swift
//  TinkoffChat
//
//  Created by Марат Джаныбаев on 26.11.2020.
//  Copyright © 2020 Tinkoff. All rights reserved.
//

import UIKit

extension ConversationsListViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

extension ConversationsListViewController: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 2.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if let toView = transitionContext.view(forKey: .to) {
            animatePresent(presentView: toView, transitionContext: transitionContext)
        } else if let fromView = transitionContext.view(forKey: .from) {
            animateDismiss(dismissView: fromView, transitionContext: transitionContext)
        } else {
            transitionContext.completeTransition(false)
            return
        }
    }
    
    private func animatePresent(presentView: UIView, transitionContext: UIViewControllerContextTransitioning) {
        let duration: Double = 1
        let xScaleFactor = 1 / presentView.frame.width
        let yScaleFactor = 1 / presentView.frame.height
 
        presentView.transform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        
        let containerView = transitionContext.containerView
        
        containerView.addSubview(presentView)
        
        UIView.animate(
            withDuration: duration,
            delay: 0.0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            animations: {
                presentView.transform = .identity
            }, completion: { _ in
                transitionContext.completeTransition(true)
            })
    }
    
    private func animateDismiss(dismissView: UIView, transitionContext: UIViewControllerContextTransitioning) {
        let duration: Double = 0.8
        UIView.animate(withDuration: duration,
                       animations: {
                        dismissView.transform = CGAffineTransform(translationX: 0, y: dismissView.bounds.height)
                       }, completion: { _ in
                        dismissView.removeFromSuperview()
                        transitionContext.completeTransition(true)
                       })
       
    }
    
}

//
//  PresentationHandler.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import UIKit

class PresentationHandler: NSObject, UIViewControllerAnimatedTransitioning{
    
    var presentationTransitionType: CustomPresentationTransitionType?
    
    init(presentationTransitionType: CustomPresentationTransitionType? = nil) {
        self.presentationTransitionType = presentationTransitionType
    }
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch presentationTransitionType {
        case .swipeRight:
            handleSwipeRight(using: transitionContext)
        case nil:
            break
        }
    }
    
    func handleSwipeRight(using transitionContext: UIViewControllerContextTransitioning){
        guard let fromView = transitionContext.view(forKey: .from),
              let toView = transitionContext.view(forKey: .to)
        else{return}
        let containerView = transitionContext.containerView
        
        containerView.addSubview(toView)
        //we are setting the initial position for the ToViewController.view, we are setting it to the left of the screen
        toView.frame = fromView.frame
        toView.frame.origin.x = -fromView.frame.width
        
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration) {
            //we are moving the toVC.view to the screen, and moving the fromView to the
            //end of the screen
            toView.frame.origin.x = 0
            fromView.frame.origin.x = fromView.frame.width
        } completion: { _ in
            if transitionContext.transitionWasCancelled{
                toView.frame.origin.x = -fromView.frame.width
                toView.removeFromSuperview()
                fromView.frame.origin.x = 0
            }else{
                fromView.removeFromSuperview()
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

enum CustomPresentationTransitionType{
    case swipeRight
}

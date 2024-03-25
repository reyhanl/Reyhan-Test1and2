//
//  TransitionManager.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import UIKit

class TransitioningManager: NSObject, UIViewControllerTransitioningDelegate{
    
    weak var interactionController: UIPercentDrivenInteractiveTransition?
    var presentationTransitionType: CustomPresentationTransitionType?
    var dismissalTransitionType: CustomDismissTransitionType?
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentationHandler(presentationTransitionType: presentationTransitionType)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissalHandler(dismissTransitionType: dismissalTransitionType)
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
}


class PresentationController: UIPresentationController {
    
    var transitionType: CustomPresentationTransitionType?
    
    override var shouldRemovePresentersView: Bool {
        return true
    }
}


protocol CustomTransitionEnabledVC{
    var interactionController: UIPercentDrivenInteractiveTransition? { get set }
    var customTransitionDelegate: TransitioningManager {get set}
}

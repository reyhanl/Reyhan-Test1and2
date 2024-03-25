//
//  ViewController.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import UIKit

class ViewController: UIViewController, CustomTransitionEnabledVC {
    
    var interactionController: UIPercentDrivenInteractiveTransition?
    
    var customTransitionDelegate: TransitioningManager = TransitioningManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addPanGestureRecognizer()
        // Do any additional setup after loading the view.
    }
    
    func addPanGestureRecognizer(){
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleTransition(_:)))
        
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(panGesture)
    }
    
    func presentScanQRVC(){
        let vc = ScanQRViewController()
        interactionController = UIPercentDrivenInteractiveTransition()
        vc.customTransitionDelegate.interactionController = interactionController
        vc.transitioningDelegate = vc.customTransitionDelegate
        vc.customTransitionDelegate.presentationTransitionType = .swipeRight
        vc.customTransitionDelegate.dismissalTransitionType = .swipeLeft
        vc.modalPresentationStyle = .custom
        self.present(vc, animated: true)
    }

    
    @objc func handleTransition(_ gestureRecognizer: UIPanGestureRecognizer){
        let translationX = gestureRecognizer.translation(in: view).x
        let percentageInDecimal = translationX / view.frame.width
        
        switch gestureRecognizer.state {
        case .began:
            presentScanQRVC()
        case .changed:
            interactionController?.update(percentageInDecimal)
        case .ended:
            if percentageInDecimal > 0.5{
                interactionController?.finish()
            }else{
                interactionController?.cancel()
            }
        default:
            break
        }
    }
}


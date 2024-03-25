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
        addPanGestureRecognizer()
        addScanQRButton()
        // Do any additional setup after loading the view.
    }
    
    func addPanGestureRecognizer(){
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleTransition(_:)))
        
        view.backgroundColor = .systemBackground
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(panGesture)
    }
    
    func addScanQRButton(){
        navigationItem.leftBarButtonItem = .init(image: .init(systemName: "qrcode.viewfinder"), style: .done, target: self, action: #selector(presentQRVC))
    }
    
    @objc func presentQRVC(){
        presentScanQRVC(with: false)
    }
    
    func presentScanQRVC(with interaction: Bool){
        let vc = ScanQRRouter.makeComponent(qrCodeHandler: self)
        if interaction{
            interactionController = UIPercentDrivenInteractiveTransition()
        }else{
            interactionController = nil
        }
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
            presentScanQRVC(with: true)
        case .changed:
            interactionController?.update(percentageInDecimal)
        case .ended:
            if percentageInDecimal > 0.5{
                interactionController?.finish()
            }else{
                interactionController?.cancel()
            }
            interactionController = nil
        default:
            break
        }
    }
}

extension ViewController: ScanQRDelegate{
    func successfullyScanQR(transaction: Transaction) {
        dismiss(animated: true)
//        presenter.userDidTransaction(content)
    }
}

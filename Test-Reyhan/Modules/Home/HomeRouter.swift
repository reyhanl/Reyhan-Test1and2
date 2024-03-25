//
//  HomeRouter.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import Foundation
import UIKit

class HomeRouter: HomePresenterToRouterProtocol{
    static func makeComponent() -> HomeViewController {
        var interactor: HomePresenterToInteractorProtocol = HomeInteractor()
        var presenter: HomeViewToPresenterProtocol & HomeInteractorToPresenterProtocol = HomePresenter()
        let view = HomeViewController()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = HomeRouter()
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
    
    func goToQRVC(from: HomeViewController, usingInteraction: Bool) {
        let vc = ScanQRRouter.makeComponent(qrCodeHandler: from)
        if usingInteraction{
            from.interactionController = UIPercentDrivenInteractiveTransition()
        }else{
            from.interactionController = nil
        }
        vc.customTransitionDelegate.interactionController = from.interactionController
        vc.transitioningDelegate = vc.customTransitionDelegate
        vc.customTransitionDelegate.presentationTransitionType = .swipeRight
        vc.customTransitionDelegate.dismissalTransitionType = .swipeLeft
        vc.modalPresentationStyle = .custom
        from.present(vc, animated: true)
    }
    
    func goToTransactionVC(from: HomeViewController, transaction: Transaction, user: User) {
        let vc = TransactionModalVC()
        vc.customTransitionDelegate.presentationTransitionType = .swipeUp
        vc.customTransitionDelegate.dismissalTransitionType = .swipeDown
        vc.transitioningDelegate = vc.customTransitionDelegate
        vc.modalPresentationStyle = .custom
        from.transitioningDelegate = vc.customTransitionDelegate
        vc.setupUI(transaction: transaction, user: user)
        vc.delegate = from
        vc.interactionController = nil
        from.present(vc, animated: true)
    }
}

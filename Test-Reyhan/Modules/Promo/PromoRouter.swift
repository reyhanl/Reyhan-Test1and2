//
//  PromoRouter.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import Foundation

class PromoRouter: PromoPresenterToRouterProtocol{
    static func makeComponent() -> PromoViewController {
        var interactor: PromoPresenterToInteractorProtocol = PromoInteractor()
        var presenter: PromoViewToPresenterProtocol & PromoInteractorToPresenterProtocol = PromoPresenter()
        let view = PromoViewController()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = PromoRouter()
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
    }
    
    func openPromoDetail(from: PromoViewController, promo: Promo){
        let promoDetailVC = PromoDetailViewController()
        if let urlString = promo.detail,
           let url = URL(string: urlString){
            promoDetailVC.setupUI(url: url)
        }
        from.navigationController?.pushViewController(promoDetailVC, animated: true)
    }
}

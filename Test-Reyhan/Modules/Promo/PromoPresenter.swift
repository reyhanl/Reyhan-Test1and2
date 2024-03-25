//
//  PromoPresenter.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import Foundation

class PromoPresenter: PromoViewToPresenterProtocol{
    
    var view: PromoPresenterToViewProtocol?
    var interactor: PromoPresenterToInteractorProtocol?
    var router: PromoPresenterToRouterProtocol?
    
    func viewDidLoad() {
        interactor?.fetchPromos()
    }
    
    func openPromoDetail(from: PromoViewController, promo: Promo) {
        router?.openPromoDetail(from: from, promo: promo)
    }
}

extension PromoPresenter: PromoInteractorToPresenterProtocol{
    
    func result(result: Result<PromoSuccessType, Error>) {
        switch result{
        case .success(let type):
            handleSuccess(type: type)
        case .failure(let error):
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func handleSuccess(type: PromoSuccessType){
        switch type{
        case .fetchPromoSuccess(let promos):
            view?.updatePromos(promos: promos)
        }
    }
}

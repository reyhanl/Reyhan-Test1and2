//
//  PromoMockPresenter.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 26/03/24.
//

import Foundation

class PromoMockPresenter: PromoViewToPresenterProtocol{
    var view: PromoPresenterToViewProtocol?
    
    var router: PromoPresenterToRouterProtocol?
    
    func viewDidLoad() {
        let mockDataProvider = MockDataProvider()
        view?.updatePromos(promos: mockDataProvider.getDummyPromos())
    }
    
    func openPromoDetail(from: PromoViewController, promo: Promo) {
        
    }
    
    
}

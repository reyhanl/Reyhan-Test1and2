//
//  PromoMockPresenter.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 26/03/24.
//

import Foundation

class PromoMockPresenter: PromoViewToPresenterProtocol{
    func numberOfRows() -> Int {
        return 0
    }
    
    func promoForCell(index: Int) -> Promo {
        return Promo(id: 0, name: "", imagesURL: "", detail: "")
    }
    
    var view: PromoPresenterToViewProtocol?
    
    var router: PromoPresenterToRouterProtocol?
    var promos: [Promo] = []
    
    func viewDidLoad() {
        let mockDataProvider = MockDataProvider()
        view?.updatePromos()
    }
    
    func openPromoDetail(from: PromoViewController, index: Int) {
        
    }
    
    
}

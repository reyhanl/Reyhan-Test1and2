//
//  PromoProtocol.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import Combine

protocol PromoViewToPresenterProtocol{
    var view: PromoPresenterToViewProtocol?{get set}
    var router: PromoPresenterToRouterProtocol?{get set}
    
    func viewDidLoad()
    func numberOfRows() -> Int
    func promoForCell(index: Int) -> Promo
    func openPromoDetail(from: PromoViewController, index: Int)
}

protocol PromoPresenterToViewProtocol{
    var presenter: PromoViewToPresenterProtocol?{get set}
    
    func updatePromos()
}

protocol PromoPresenterToInteractorProtocol{
    var presenter: PromoInteractorToPresenterProtocol?{get set}
    
    func fetchPromos() -> AnyPublisher<[Promo], Error>
}

protocol PromoInteractorToPresenterProtocol{
    var interactor: PromoPresenterToInteractorProtocol?{get set}
    
    func result(result: Result<PromoSuccessType, Error>)
}

protocol PromoPresenterToRouterProtocol{
    func openPromoDetail(from: PromoViewController, promo: Promo)
}

enum PromoSuccessType{
    case fetchPromoSuccess([Promo])
}

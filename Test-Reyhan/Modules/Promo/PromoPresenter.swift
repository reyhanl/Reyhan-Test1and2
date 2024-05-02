//
//  PromoPresenter.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import Combine

class PromoPresenter: PromoViewToPresenterProtocol{
    
    var view: PromoPresenterToViewProtocol?
    var interactor: PromoPresenterToInteractorProtocol?
    var router: PromoPresenterToRouterProtocol?
    private var cancellables = Set<AnyCancellable>()

    @Published var promos: [Promo] = []
    
    func viewDidLoad() {
        interactor?.fetchPromos().sink(receiveCompletion: { result in
            switch result {
            case .finished:
                break
            case .failure(let failure):
                print("failure: \(failure.localizedDescription)")
            }
        }, receiveValue: { [weak self] promos in
            self?.promos = promos
            self?.view?.updatePromos()
        }).store(in: &cancellables)
    }
    
    func openPromoDetail(from: PromoViewController, index: Int) {
        router?.openPromoDetail(from: from, promo: promos[index])
    }

    func numberOfRows() -> Int {
        return promos.count
    }
    
    func promoForCell(index: Int) -> Promo {
        return promos[index]
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
            view?.updatePromos()
        }
    }
}

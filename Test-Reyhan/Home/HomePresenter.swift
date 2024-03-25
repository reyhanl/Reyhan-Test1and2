//
//  ViewControllerPresenter.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import Foundation

class HomePresenter: HomeInteractorToPresenterProtocol{
    var interactor: HomePresenterToInteractorProtocol?
    var view: HomePresenterToViewProtocol?
    var router: HomePresenterToRouterProtocol?
    
    func result(result: Result<HomeSuccessType, Error>) {
        switch result{
        case .success(let type):
            handleSuccess(type: type)
        case .failure(let error):
            switch error{
            case CustomError.insufficientBalance:
                view?.presentAlertError(title: "Insufficient balance", message: error.localizedDescription)
            default:
                print("error: \(String(describing: error))")
            }
        }
    }
    
    func handleSuccess(type: HomeSuccessType){
        switch type{
        case .fetchTransactionSucess(let transactions):
            view?.updateTransactions(transactions: transactions)
        case .transactionSuccess:
            interactor?.fetchListOfTransaction()
        case .fetchUserSuccess(let user):
            view?.updateUserInfo(user: user)
        case .topUpSuccess:
            interactor?.fetchUserDetail()
        }
    }
}

extension HomePresenter: HomeViewToPresenterProtocol{
    func updateTransactions() {
        interactor?.fetchListOfTransaction()
    }
    
    func userDidTransaction(transaction: Transaction) {
        interactor?.userDidTransaction(transaction: transaction)
    }
    
    func updateUserDetail() {
        interactor?.fetchUserDetail()
    }
    
    func goToQRVC(from: HomeViewController, usingInteraction: Bool) {
        router?.goToQRVC(from: from, usingInteraction: usingInteraction)
    }
    
    func topUp() {
        interactor?.topUp()
    }
}

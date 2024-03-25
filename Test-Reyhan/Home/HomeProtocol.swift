//
//  HomeProtocol.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import Foundation

protocol HomeViewToPresenterProtocol{
    var view: HomePresenterToViewProtocol?{get set}
    var router: HomePresenterToRouterProtocol?{get set}
    
    func userDidTransaction(transaction: Transaction)
    func updateTransactions()
    func updateUserDetail()
    func goToQRVC(from: HomeViewController, usingInteraction: Bool)
    func topUp()
}

protocol HomePresenterToViewProtocol{
    var presenter: HomeViewToPresenterProtocol?{get set}
    
    func presentAlertError(title: String, message: String)
    func updateTransactions(transactions: [Transaction])
    func updateUserInfo(user: User)
}

protocol HomePresenterToInteractorProtocol{
    var presenter: HomeInteractorToPresenterProtocol?{get set}
    
    func userDidTransaction(transaction: Transaction)
    func fetchListOfTransaction()
    func fetchUserDetail()
    func topUp()
}

protocol HomeInteractorToPresenterProtocol{
    var interactor: HomePresenterToInteractorProtocol?{get set}
    
    func result(result: Result<HomeSuccessType, Error>)
}

protocol HomePresenterToRouterProtocol{
    func goToQRVC(from: HomeViewController, usingInteraction: Bool)
}

enum HomeSuccessType{
    case transactionSuccess
    case topUpSuccess
    case fetchTransactionSucess([Transaction])
    case fetchUserSuccess(User)
}

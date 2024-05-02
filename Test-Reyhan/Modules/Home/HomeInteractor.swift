//
//  HomeInteractor.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import Foundation

class HomeInteractor: HomePresenterToInteractorProtocol{
    var presenter: HomeInteractorToPresenterProtocol?
        
    func userDidTransaction(transaction: Transaction) {
        let stack = CoreDataStack(name: .main)
        let helper = CoreDataHelper(coreDataStack: stack)
        
        do{
            var user = try UserManager.shared.fetchUser()
            if user.balance < transaction.transactionTotal{
                throw CustomError.insufficientBalance
            }
            user.balance -= transaction.transactionTotal
            try UserManager.shared.updateBalance(balance: user.balance)
            try helper.saveNewData(entity: .transaction, object: transaction)
            presenter?.result(result: .success(.transactionSuccess))
        }catch{
            presenter?.result(result: .failure(error))
        }
    }
    
    func fetchListOfTransaction(){
        let stack = CoreDataStack(name: .main)
        let helper = CoreDataHelper(coreDataStack: stack)

        do{
            let transactions: [Transaction] = try helper.fetchItemsToGeneric(entity: .transaction, with: nil)
            presenter?.result(result: .success(.fetchTransactionSucess(transactions)))
        }catch{
            presenter?.result(result: .failure(error))
        }
    }
    
    func fetchUserDetail() {
        do{
            let user = try UserManager.shared.fetchUser()
            presenter?.result(result: .success(.fetchUserSuccess(user)))
        }catch{
            presenter?.result(result: .failure(error))
        }
    }
    
    func topUp() {
        do{
            var user = try UserManager.shared.fetchUser()
            user.balance += 50000
            try UserManager.shared.updateBalance(balance: user.balance)
            print(try UserManager.shared.fetchUser().balance)
            presenter?.result(result: .success(.topUpSuccess))
        }catch{
            presenter?.result(result: .failure(error))
        }
    }
}

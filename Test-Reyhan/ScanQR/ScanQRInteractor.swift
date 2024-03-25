//
//  ScanQRInteractor.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import Foundation

class ScanQRInteractor: ScanQRPresenterToInteractorProtocol{
    var presenter: ScanQRInteractorToPresenterProtocol?
    
    func userDidScanQR(qrString: String) {
        let result = qrString.split(separator: ".").map({String($0)})
        guard let bank = result[safe: 0],
              let transactionID = result[safe: 1],
              let merchant = result[safe: 2],
              let transactionTotal = result[safe: 3],
              let transactionDouble = Double(transactionTotal)
        else{
            presenter?.result(result: .failure(CustomError.unableToScanQRCode))
            return
        }
        let content = Transaction.init(bank: bank, transactionID: transactionID, merchant: merchant, transactionTotal: transactionDouble, date: Date().toString())
        presenter?.result(result: .success(.decodeQR(content)))
    }
}

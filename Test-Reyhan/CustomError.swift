//
//  CustomError.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import Foundation

enum CustomError: String, Error{
    case unableToScanQRCode
    case somethingWentWrong
    case userNotFound
    case insufficientBalance
}

extension CustomError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unableToScanQRCode:
            return NSLocalizedString("QR is not in the right format", comment: "The QR code scanned is not in the right format")
        case .insufficientBalance:
            return NSLocalizedString("You do not have enough balance to complete the transaction", comment: "You do not have enough balance to complete the transaction")
        default:
            return NSLocalizedString("Something went wrong", comment: "Something unexpected occured")
        }
    }
}

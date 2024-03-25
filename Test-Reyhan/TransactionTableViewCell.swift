//
//  TransactionTableViewCell.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import UIKit

class TransactionTableViewCell: UITableViewCell{
    
    lazy var merchantLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addAmountLabel()
        addMerchantLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addMerchantLabel(){
        addSubview(merchantLabel)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: merchantLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: merchantLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: merchantLabel, attribute: .trailing, relatedBy: .lessThanOrEqual, toItem: amountLabel, attribute: .leading, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: merchantLabel, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: 30)
        ])
    }
    
    func addAmountLabel(){
        addSubview(amountLabel)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: amountLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: amountLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -10),
            NSLayoutConstraint(item: amountLabel, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: 30)
        ])
    }
    
    func setupCell(transaction: Transaction){
        merchantLabel.text = transaction.merchant
        amountLabel.text = "\(transaction.transactionTotal)"
    }
}

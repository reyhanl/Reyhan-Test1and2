//
//  ViewController.swift
//  Test-Reyhan
//
//  Created by reyhan muhammad on 25/03/24.
//

import UIKit

class HomeViewController: BaseViewController, CustomTransitionEnabledVC, HomePresenterToViewProtocol {
    
    lazy var noTransactionView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var balanceLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 40)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(NoDataTableViewCell.self, forCellReuseIdentifier: "noDataCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.accessibilityIdentifier = "tableView"
        return tableView
    }()
    lazy var topUpButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(.init(color: .primaryButton), for: .normal)
        button.setBackgroundImage(.init(color: .primaryButtonPressed), for: .selected)
        button.setBackgroundImage(.init(color: .primaryButtonPressed), for: .highlighted)
        button.setTitle("Top up", for: .normal)
        button.addTarget(self, action: #selector(topup), for: .touchUpInside)
        button.layer.cornerRadius = 5
        return button
    }()
    
    var presenter: HomeViewToPresenterProtocol?
    var interactionController: UIPercentDrivenInteractiveTransition?
    var customTransitionDelegate: TransitioningManager = TransitioningManager()
    var balance: Double = 0
    var transactions: [Transaction] = []
    var firstTime: Bool = true
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPanGestureRecognizer()
        addScanQRButton()
        addNoTransactionView()
        addTableView()
        addTopUpButton()
        presenter?.updateUserDetail()
        presenter?.updateTransactions()
        navigationController?.navigationBar.prefersLargeTitles = true
        // Do any additional setup after loading the view.
    }
    
    func addUserDetailView(){
        view.addSubview(balanceLabel)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: balanceLabel, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: balanceLabel, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: balanceLabel, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 100)
        ])
    }
    
    func addTableView(){
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        ])
    }
    
    func addNoTransactionView(){
        view.addSubview(noTransactionView)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: noTransactionView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: noTransactionView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: noTransactionView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.5, constant: 0),
            NSLayoutConstraint(item: noTransactionView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0.5)
        ])
    }
    
    func addTopUpButton(){
        view.addSubview(topUpButton)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: topUpButton, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: -20),
            NSLayoutConstraint(item: topUpButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: topUpButton, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: 50),
            NSLayoutConstraint(item: topUpButton, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 0.8, constant: 0)
        ])
    }
    
    func addPanGestureRecognizer(){
        let panGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleTransition(_:)))
        panGesture.edges = .left
        
        tableView.backgroundColor = .systemBackground
        tableView.isUserInteractionEnabled = true
        tableView.addGestureRecognizer(panGesture)
    }
    
    func addScanQRButton(){
        navigationItem.leftBarButtonItem = .init(image: .init(systemName: "qrcode.viewfinder"), style: .done, target: self, action: #selector(presentQRVC))
    }
    
    func presentAlertError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alertController.addAction(.init(title: "OK", style: .destructive))
        self.present(alertController, animated: true)
    }
    
    func updateTransactions(transactions: [Transaction]) {
        self.transactions = transactions
        tableView.reloadData()
    }
    
    func updateUserInfo(user: User) {
        self.user = user
        self.navigationItem.title = user.balance.getCurrency()
    }
    
    @objc func presentQRVC(){
        presentScanQRVC(usingInteraction: false)
    }
    
    func presentScanQRVC(usingInteraction: Bool){
        presenter?.goToQRVC(from: self, usingInteraction: usingInteraction)
    }

    
    @objc func handleTransition(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer){
        let translationX = gestureRecognizer.translation(in: view).x
        let percentageInDecimal = translationX / view.frame.width
        
        switch gestureRecognizer.state {
        case .began:
            presentScanQRVC(usingInteraction: true)
        case .changed:
            interactionController?.update(percentageInDecimal)
        case .ended:
            if percentageInDecimal > 0.5{
                interactionController?.finish()
            }else{
                interactionController?.cancel()
            }
            interactionController = nil
        default:
            break
        }
    }
    
    @objc func topup(){
        presenter?.topUp()
    }
}

extension HomeViewController: ScanQRDelegate{
    func successfullyScanQR(transaction: Transaction) {
        dismiss(animated: true) { [weak self] in
            guard let self = self, let user = user else{return}
            self.presenter?.goToTransactionVC(from: self, transaction: transaction, user: user)
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if transactions.count == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "noDataCell", for: indexPath) as! NoDataTableViewCell
            tableView.accessibilityIdentifier = "noDataCell"
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TransactionTableViewCell
            cell.setupCell(transaction: transactions[indexPath.row])
            tableView.accessibilityIdentifier = "transactionTableViewCell\(indexPath.row)"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (transactions.count == 0) ? tableView.frame.height:UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count == 0 ? 1:transactions.count
    }
}

extension HomeViewController: TransactionModalDelegate{
    func purchase(transaction: Transaction){
        dismiss(animated: true) { [weak self] in
            guard let self = self else{return}
            self.presenter?.userDidTransaction(transaction: transaction)
        }
    }
}

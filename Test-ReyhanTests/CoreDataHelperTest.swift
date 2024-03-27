//
//  CoreDataHelperTest.swift
//  Test-ReyhanTests
//
//  Created by reyhan muhammad on 26/03/24.
//

import XCTest
import CoreData

final class CoreDataHelperTest: XCTestCase {
    
    var app: XCUIApplication?
    
    var coreDataHelper: CoreDataHelperProtocol?
    var transactions: [Transaction] = []
    var container: DataContainer = .main
    let entity: EntityName = .transaction
    
    override func setUpWithError() throws {
        let container = NSPersistentContainer(name: DataContainer.main.rawValue)
        container.persistentStoreDescriptions[0].url = URL(fileURLWithPath: "/dev/null")
        
        coreDataHelper = CoreDataHelper.init(coreDataStack: .init(persistent: container))
        let mockDataProvider = MockDataProvider()
        let transactions = mockDataProvider.getDummyTransactions()
        self.transactions = transactions
    }

    override func tearDownWithError() throws {
        coreDataHelper = nil
        transactions = []
    }

    
    func testInserTransaction() throws{
        guard let coreDataHelper = coreDataHelper else{return}
        for category in transactions {
            try? coreDataHelper.saveNewData(entity: .transaction, object: category)
        }
        
        do{
            let result: [Transaction] = try coreDataHelper.fetchItemsToGeneric(entity: entity, with: nil)
            print("result: \(result.count)")
            XCTAssert(result.count == transactions.count && result.count > 0, "Data fetched is not matching with data inserted")
            XCTAssert((result.first?.transactionID) == transactions.first?.transactionID)
        }catch{
            print("error: \(error.localizedDescription)")
            throw error
        }
    }
    
    func testDeleteAllDataFromCategory() throws{
        guard let coreDataHelper = coreDataHelper else{return}
        insertDataToContainer()
        let result: [Transaction]? = try? coreDataHelper.fetchItemsToGeneric(entity: entity, with: nil)
        XCTAssert((result?.count) ?? 0 > 0, "Data fetched is zero")
        let _ = try? coreDataHelper.deleteAllRecords(entity: entity)
        
        do{
            let result: [Transaction] = try coreDataHelper.fetchItemsToGeneric(entity: entity, with: nil)
            XCTAssert(result.count == 0, "There is still some data left")
        }catch{
            print("error: \(error.localizedDescription)")
            throw error
        }
        
    }
    
    func insertDataToContainer(){
        guard let coreDataHelper = coreDataHelper else{return}
        for transaction in transactions {
            let _ = try? coreDataHelper.saveNewData(entity: .transaction, object: transaction)
        }
    }
    
    override func tearDown() {
        coreDataHelper = nil
    }
}


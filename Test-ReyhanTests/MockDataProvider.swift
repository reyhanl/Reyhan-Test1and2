//
//  MockDataProvider.swift
//  Test-ReyhanTests
//
//  Created by reyhan muhammad on 26/03/24.
//

import Foundation

class MockDataProvider{
    func getDummyTransactions() -> [Transaction]{
        if let path = getPath(filename: "dummy", ofType: "json"){
            do{
                let url = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: url)
                
                let decoder = JSONDecoder()
                let model = try decoder.decode([Transaction].self, from: data)
                return model
                
            }catch{
                print("error: \(error.localizedDescription)")
            }
        }else{
            print("error: path does not exist")
        }
        return []
    }
    
    func getPath(filename: String, ofType: String) -> String? {
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: filename, ofType: ofType)
        return path
    }
    
    func getDummyPromos() -> [Promo]{
        return [
            .init(id: 1, name: "Promo1", imagesURL: "https://firebasestorage.googleapis.com/v0/b/test-reyhan-f2bc2.appspot.com/o/ELF-Digital%20Banner%2039x69_Fleksi%20Pensiun%20Pra%20Purna%20Generik-FA-230818-01-2.jpg?alt=media&token=1488a70b-2e1d-4d31-8464-7672245e5e1d", detail: "https://firebase.google.com"),
            .init(id: 1, name: "Promo2", imagesURL: "https://firebasestorage.googleapis.com/v0/b/test-reyhan-f2bc2.appspot.com/o/ELF-Digital%20Banner%2039x69_Fleksi%20Pensiun%20Pra%20Purna%20Generik-FA-230818-01-2.jpg?alt=media&token=1488a70b-2e1d-4d31-8464-7672245e5e1d", detail: "https://firebase.google.com"),
            .init(id: 1, name: "Promo3", imagesURL: "https://firebasestorage.googleapis.com/v0/b/test-reyhan-f2bc2.appspot.com/o/ELF-Digital%20Banner%2039x69_Fleksi%20Pensiun%20Pra%20Purna%20Generik-FA-230818-01-2.jpg?alt=media&token=1488a70b-2e1d-4d31-8464-7672245e5e1d", detail: "https://firebase.google.com")
        ]
    }
}

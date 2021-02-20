//
//  tester.swift
//  Ghost Runner
//
//  Created by Nikita on 2/19/21.
//

import Foundation


struct TestDataResponse: Codable {
    var TestData: [TestData] = Array()
}

struct TestData: Codable {
    var ID: String
    var ELE: String
    var LAT: String
    var LNG: String
    var TIME: String
    var DATE: String
}

class Tester {
    
    func readFile() -> Data? {
        do {
            if let filepath = Bundle.main.path(forResource: "test_data", ofType: "json"),
               let jsonData = try String(contentsOfFile: filepath).data(using: .utf8) {
                print("filepath:")
                print(filepath)
                return jsonData
            }
        }
        catch {
            print("error in read")
        }
        return nil
    }
    
    func testParse(jsonData: Data) -> TestDataResponse? {
        do {
            let decoded = try JSONDecoder().decode(TestDataResponse.self, from: jsonData)
            return decoded
        }
        catch {
            print("error in decode")
        }
        return nil
    }
    
    
    
    
    
}

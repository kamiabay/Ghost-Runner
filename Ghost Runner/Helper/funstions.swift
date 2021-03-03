//
//  funstions.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 3/1/21.
//

import Foundation


class Functions {
    
    func randomCode() -> String  {
        let alpha = random(length: 3, base: "abcdefghijklmnopqrstuvwxyz")
        let digit = random(length: 2, base: "0123456789")
        return alpha + digit
    }
    
    private func random(length: Int, base: String) -> String {
        var randomString: String = ""
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }

}



//
//  String.swift
//  quiz master
//
//  Created by Karl Cridland on 01/05/2020.
//  Copyright © 2020 Karl Cridland. All rights reserved.
//

import Foundation

import var CommonCrypto.CC_SHA256_DIGEST_LENGTH
import func CommonCrypto.CC_SHA256
import typealias CommonCrypto.CC_LONG

extension String{
    
    func random() -> String {
      let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ123456789"
      return String((0..<6).map{ _ in letters.randomElement()! })
    }
    
    func codeString() -> String{
        var new = ""
        for c in self{
            if c == "0"{
                new += "O"
            }
            else{
                new += String(c).uppercased()
            }
        }
        return new
    }
    
    func acceptable() -> Bool{
        if (self.count > 0) && (self.count <= 20){
            return true
        }
        return false
    }
    
    func alphanumeric() -> Bool{
        for c in "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"{
            if String(String(c).first!) == self{
                return true
            }
        }
        return false
    }
    
    func first() -> String{
        for c in self{
            return String(c)
        }
        return ""
    }
    
    func encrypt() -> String{
        var myPassword = ""
        myPassword += SHA256(string: self).map { String(format: "%02hhx", $0) }.joined()
        let thePassword = myPassword
        return thePassword
    }
    
    private func SHA256(string: String) -> Data {
        let length = Int(CC_SHA256_DIGEST_LENGTH)
        let messageData = string.data(using:.utf8)!
        var digestData = Data(count: length)
        
        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
                    CC_SHA256(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        return digestData
    }
}

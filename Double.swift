//
//  Double.swift
//  quiz master
//
//  Created by Karl Cridland on 02/05/2020.
//  Copyright © 2020 Karl Cridland. All rights reserved.
//

import Foundation

extension Double{
    
    func decimal(_ places: Int) -> String{
        let parts = String(self).split(separator: ".")
        let whole = String(parts[0])
        let dec = String(String(parts[1]).prefix(places))
        return "\(whole).\(dec)"
    }
}

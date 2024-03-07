//
//  Int.swift
//  quiz master
//
//  Created by Karl Cridland on 03/05/2020.
//  Copyright © 2020 Karl Cridland. All rights reserved.
//

import Foundation

extension Int{
    
    func ordinate() -> String{
        if (self%100 >= 11) && (self%100 <= 13){
            return String(self)+"th"
        }
        else{
            switch self%10 {
            case 1:
                return String(self)+"st"
            case 2:
                return String(self)+"nd"
            case 3:
                return String(self)+"rd"
            default:
                return String(self)+"th"
            }
        }
    }
}

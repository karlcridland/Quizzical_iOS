//
//  Answer.swift
//  quiz master
//
//  Created by Karl Cridland on 29/04/2020.
//  Copyright © 2020 Karl Cridland. All rights reserved.
//

import Foundation
import UIKit

class Answer {
    
    let name: String
    let correct: Bool
    
    init(_ a: String, _ c: Bool) {
        self.name = a
        self.correct = c
    }
}

//
//  UILabel.swift
//  quiz master
//
//  Created by Karl Cridland on 02/05/2020.
//  Copyright © 2020 Karl Cridland. All rights reserved.
//

import Foundation
import UIKit

extension UILabel{
    
    func fontStyle() {
        numberOfLines = 0
        textAlignment = .center
        font = .systemFont(ofSize: 18.0, weight: UIFont.Weight(10.0))
        textColor = .white
    }
}

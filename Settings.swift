//
//  Settings.swift
//  quiz master
//
//  Created by Karl Cridland on 05/05/2020.
//  Copyright © 2020 Karl Cridland. All rights reserved.
//

import Foundation
import UIKit

class Settings {
    
    public static let shared = Settings()
    let defaults = UserDefaults.standard
    
    private init(){
        
    }
    
    func blocked() -> [Int]{
        return defaults.value(forKey: "blocked") as! [Int]
    }
    
    
}

class Share: UIButton{
    override init(frame: CGRect) {
        super .init(frame: frame)
        setImage(UIImage(named: "white share"), for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

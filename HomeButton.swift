//
//  HomeButton.swift
//  quiz master
//
//  Created by Karl Cridland on 03/05/2020.
//  Copyright © 2020 Karl Cridland. All rights reserved.
//

import Foundation
import UIKit

class HomeButton: UIButton {
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setTitle("home", for: .normal)
        titleLabel?.fontStyle()
        style()
        addTarget(self, action: #selector(clearAll), for: .touchUpInside)
    }
    
    @objc func clearAll(){
        let home = homeView()
        home.removeAll()
        home.addSubview(HomeScreen())
        Firebase.shared.inactive()
        Firebase.shared.quizFinished()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

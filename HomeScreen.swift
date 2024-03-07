//
//  HomeScreen.swift
//  quiz master
//
//  Created by Karl Cridland on 02/05/2020.
//  Copyright © 2020 Karl Cridland. All rights reserved.
//

import Foundation
import UIKit

class HomeScreen: UIView {
    init() {
        super .init(frame: CGRect(x: 20, y: 100, width: UIScreen.main.bounds.width-40, height: 400))
//        style()
        
        let join = UIButton(frame: CGRect(x: 0, y: 75, width: UIScreen.main.bounds.width-40, height: 50))
        join.setTitle("join a quiz", for: .normal)
        join.style()
        join.titleLabel!.font = .systemFont(ofSize: 18.0, weight: UIFont.Weight(10.0))
        join.titleLabel!.textColor = .white
        join.addTarget(self, action: #selector(joinQuiz), for: .touchUpInside)
        addSubview(join)
        
        let host = UIButton(frame: CGRect(x: 0, y: 175, width: UIScreen.main.bounds.width-40, height: 50))
        host.setTitle("host a quiz", for: .normal)
        host.style()
        host.titleLabel!.font = .systemFont(ofSize: 18.0, weight: UIFont.Weight(10.0))
        host.titleLabel!.textColor = .white
        host.addTarget(self, action: #selector(hostQuiz), for: .touchUpInside)
        addSubview(host)
        
        let create = UIButton(frame: CGRect(x: 0, y: 275, width: UIScreen.main.bounds.width-40, height: 50))
        create.setTitle("create a quiz", for: .normal)
        create.style()
        create.titleLabel!.font = .systemFont(ofSize: 18.0, weight: UIFont.Weight(10.0))
        create.titleLabel!.textColor = .white
        create.addTarget(self, action: #selector(createQuiz), for: .touchUpInside)
        addSubview(create)
        
        let settings = UIButton(frame: CGRect(x: 0, y: 375, width: UIScreen.main.bounds.width-40, height: 50))
        settings.setTitle("settings", for: .normal)
        settings.style()
        settings.titleLabel!.font = .systemFont(ofSize: 18.0, weight: UIFont.Weight(10.0))
        settings.titleLabel!.textColor = .white
        
//        addSubview(settings)
        
        let image = UIImageView(frame: CGRect(x: 10, y: -50, width: 80, height: 80))
        image.image = UIImage(named: "logo-nb")
        addSubview(image)
        var width = 300
        if width + 100 > Int(frame.width){
            width = Int(frame.width) - 100
        }
        let imaget = UIImageView(frame: CGRect(x: 80, y: -60, width: width, height: 100))
        imaget.image = UIImage(named: "logo-t")
        imaget.contentMode = .scaleAspectFit
        addSubview(imaget)
        
    }
    
    @objc func joinQuiz(){
        removeAll()
        let join = JoinQuiz()
        homeView().addSubview(join)
        print(098)
    }
    
    @objc func hostQuiz(){
        removeAll()
        let host = HostQuiz()
        homeView().addSubview(host)
    }
    
    @objc func createQuiz(){
        removeAll()
        let create = CreateQuiz()
        homeView().addSubview(create)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

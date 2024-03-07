//
//  Background.swift
//  quiz master
//
//  Created by Karl Cridland on 04/05/2020.
//  Copyright © 2020 Karl Cridland. All rights reserved.
//

import Foundation
import UIKit

class Background: UIView{
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        let length = 30
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height

        let image = UIImageView(frame: CGRect(x: (UIScreen.main.bounds.width/2)-90, y: (UIScreen.main.bounds.height/2)-90, width: 180, height: 180))
        image.image = UIImage(named: "logo-nb")
        addSubview(image)
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: { _ in
            for a in 0 ... Int(height/CGFloat(length)){
                for b in 0 ... Int(width/CGFloat(length)){
                    let q = UILabel(frame: CGRect(x: b*length, y: a*length, width: length, height: length))
                    self.addSubview(q)
                    q.text = "?"
                    q.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                    q.transform = CGAffineTransform(rotationAngle: CGFloat.random(in: 0 ... (2*CGFloat.pi)))
                }
            }
            let bg = UIView(frame: frame)
            self.superview!.addSubview(bg)
            bg.backgroundColor = .systemBlue
            
            bg.addSubview(image)
            UIView.animate(withDuration: 0.4, animations: {
                image.frame = CGRect(x: 30, y: 50, width: 80, height: 80)
            })
            Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false, block: { _ in
                bg.fadeOut(0.2)
            })
        })
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

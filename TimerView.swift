//
//  TimerView.swift
//  quiz master
//
//  Created by Karl Cridland on 30/04/2020.
//  Copyright © 2020 Karl Cridland. All rights reserved.
//

import Foundation
import UIKit

class TimerView: UIView {
    
    var d = TimeInterval()
    let time: TimeInterval
    
    init(frame: CGRect, time: TimeInterval) {
        self.time = time
        super .init(frame: frame)
        
        let l = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        layer.cornerRadius = 7.5
        l.layer.cornerRadius = 7.5
        l.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        l.layer.borderWidth = 4.0
        l.backgroundColor = .systemBlue
        clipsToBounds = true
        l.clipsToBounds = true
        
        d = time
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: {timer in
            if self.d <= 0.0{
                timer.invalidate()
            }
            UIView.animate(withDuration: 0.1, animations: {
                l.frame = CGRect(x: frame.width-(frame.width*CGFloat(((100/time)*self.d)))/100, y: 0, width: (frame.width*CGFloat(((100/time)*self.d)))/100, height: frame.height)
            })
            self.d -= 0.1
        })
        
        for a in 0 ... Int(frame.width)/20{
            let bar = UIView(frame: CGRect(x: a*40, y: 0, width: 20, height: Int(frame.height)))
            bar.backgroundColor = .white
            l.addSubview(bar)
            bar.transform = CGAffineTransform(a: 1, b: 0, c: -0.8, d: 1, tx: 0, ty: 0)
        }
        let const = (frame.width-100)
        
        for subview in l.subviews{
            UIView.animate(withDuration: time, animations: {
                subview.center = CGPoint(x: subview.center.x-const, y: subview.center.y)
            })
        }
        
        addSubview(l)
    }
    
    func remaining() -> Int{
        var score = Int(Double(((100/time)*Double(self.d)))*5)
        if score < 0{
            score = 0
        }
        return score + 500
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  UIView.swift
//  quiz master
//
//  Created by Karl Cridland on 01/05/2020.
//  Copyright © 2020 Karl Cridland. All rights reserved.
//

import Foundation
import UIKit

extension UIView{

    func shake(){
        var i = 0
        Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true, block: { timer in
            UIView.animate(withDuration: 0.05, animations: {
                self.transform = CGAffineTransform(translationX: -5, y: 0)
            })
            Timer.scheduledTimer(withTimeInterval: 0.05, repeats: false, block: { timer in
                UIView.animate(withDuration: 0.1, animations: {
                    self.transform = CGAffineTransform(translationX: 5, y: 0)
                })
            })
            if i == 2{
                Timer.scheduledTimer(withTimeInterval: 0.15, repeats: false, block: { _ in
                    UIView.animate(withDuration: 0.05, animations: {
                        self.transform = CGAffineTransform.identity
                    })
                })
                timer.invalidate()
            }
            i += 1
        })
    }
    
    func style(){
        self.layer.cornerRadius = 7.5
        self.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.layer.borderWidth = 4.0
        self.backgroundColor = .systemBlue
//        if self is UIButton{
//            self.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
//        }
        self.backgroundColor = self.backgroundColor!.withAlphaComponent(0.7)
        
    }
    
    func homeView() -> UIView{
        if superview != nil{
            if self.tag == 69{
                return self
            }
            return superview!.homeView()
        }
        else{
            return self
        }
    }
    
    func centered(){
        if superview != nil{
            center = superview!.center
        }
    }
    
    func fadeOut(_ time: TimeInterval){
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0.0
        })
        Timer.scheduledTimer(withTimeInterval: time, repeats: false, block: { _ in
            self.removeFromSuperview()
        })
    }
    
    func lbp()->Bool{
        for sub in subviews{
            if sub is Leaderboard{
                return true
            }
        }
        return false
    }
}

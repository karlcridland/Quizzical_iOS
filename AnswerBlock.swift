//
//  AnswerBlock.swift
//  quiz master
//
//  Created by Karl Cridland on 30/04/2020.
//  Copyright © 2020 Karl Cridland. All rights reserved.
//

import Foundation
import UIKit

class AnswerBlock: UIButton {
    
    private let top = UIButton()
    private let answer: Answer
    var name = String()
    
    let banner = UIView()
    
    init(frame: CGRect, answer: Answer, number: Int) {
        self.answer = answer
        super .init(frame: frame)
        
        banner.frame = CGRect(x: frame.minX+10, y: frame.minY+10, width: frame.width-20, height: frame.height-20)
        
        banner.layer.cornerRadius = 7.5
        banner.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        banner.layer.borderWidth = 4.0
        banner.backgroundColor = .systemBlue
        
        
        let label = UILabel(frame: CGRect(x: 10, y: 10, width: banner.frame.width-20, height: banner.frame.height-20))
        label.text = answer.name
        name = answer.name
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18.0, weight: UIFont.Weight(10.0))
        label.textColor = .white
        
        banner.addSubview(label)
        
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: false, block: { _ in
            if (self.superview != nil){
                self.superview!.addSubview(self.banner)
                self.superview!.sendSubviewToBack(self.banner)
            }
        })
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func correct() -> Bool{
        return answer.correct
    }
    
//    override func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
//        super.addTarget(target, action: action, for: controlEvents)
//        top.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
//        top.addTarget(target, action: action, for: controlEvents)
//        bringSubviewToFront(top)
//    }
    
//    override func removeTarget(_ target: Any?, action: Selector?, for controlEvents: UIControl.Event) {
//        super.removeTarget(target, action: action, for: controlEvents)
//    }
//
//    override func addSubview(_ view: UIView) {
//        super.addSubview(view)
//        bringSubviewToFront(top)
//    }
    
    func letter(int: Int) -> String{
        switch int {
            case 0: return "a"
            case 1: return "b"
            case 2: return "c"
            case 3: return "d"
            case 4: return "e"
            case 5: return "f"
            default: return ""
        }
    }
}

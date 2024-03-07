//
//  Question.swift
//  quiz master
//
//  Created by Karl Cridland on 29/04/2020.
//  Copyright © 2020 Karl Cridland. All rights reserved.
//

import Foundation
import UIKit

class Question {
    
    let title: String
    let interval: TimeInterval
    
    var ready = false
    var answered = false
    var correct = false
    
    var score = Int()
    
    private let answers: [Answer]
    
    init(_ q: String, _ a: [Answer], _ t: TimeInterval) {
        self.title = q
        self.answers = a
        self.interval = t
    }
    
    func ans() -> [Answer]{
        return answers
    }
    
    func prepare(_ frame: CGRect) -> UIView{
        let view = UIView(frame: frame)
        var i = 0
        for answer in answers.shuffled(){
            if answers.count != 2{
                let a = AnswerBlock(frame: CGRect(
                    x: CGFloat(i%2)*(frame.width/2),
                    y: CGFloat((i/2))*frame.height/CGFloat(answers.count%2 + answers.count/2),
                    width: frame.width/2,
                    height: frame.height/(CGFloat(answers.count%2 + answers.count/2))), answer: answer, number: i)
                a.addTarget(self, action: #selector(clicked), for: .allTouchEvents)
                view.addSubview(a)
                if (answers.count%2 == 1) && (i == answers.count-1){
                    a.center = CGPoint(x: view.center.x, y: a.center.y)
                    a.banner.center = a.center
                }
            }
            else{
                let a = AnswerBlock(frame: CGRect(
                    x: 0,
                    y: CGFloat(i) * frame.height/2,
                    width: frame.width,
                    height: 0.8*(frame.height/2)), answer: answer, number: i)
                a.addTarget(self, action: #selector(clicked), for: .allTouchEvents)
                view.addSubview(a)
            }
            
            i += 1
        }
        return view
    }
    
    @objc func clicked(sender: AnswerBlock){
        if sender.correct(){
            correct = true
            sender.banner.backgroundColor = .systemGreen
        }
        else{
            sender.banner.backgroundColor = .systemRed
        }
    }
    
}

//
//  HostQuizPage.swift
//  quiz master
//
//  Created by Karl Cridland on 02/05/2020.
//  Copyright © 2020 Karl Cridland. All rights reserved.
//

import Foundation
import UIKit

class HostQuizPage: UIScrollView {
    
    var questions = [q]()
    var title = String()
    var pause = false
    let wait = UIButton()
    let label = UILabel()
    let code: String
    
    init(_ code: String) {
        self.code = code
        super .init(frame: CGRect(x: 10, y: 100, width: UIScreen.main.bounds.width-20, height: UIScreen.main.bounds.height-130))
        style()
        wait.style()
        wait.backgroundColor = .systemGreen
        wait.titleLabel?.fontStyle()
        wait.setTitle("ready", for: .normal)
        showsVerticalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func ready(){
        label.fontStyle()
        label.text = title
        label.textAlignment = .left
        addSubview(label)
        label.frame = CGRect(x: 20, y: 0, width: frame.width-40, height: 50)
        
        var i = 0
        for question in questions{
            let label = UILabel(frame: CGRect(x: 20, y: 60+(80*i), width: Int(frame.width)-120, height: 70))
            label.text = question.question
            label.fontStyle()
            label.textAlignment = .left
            addSubview(label)
            
            let button = UIButton(frame: CGRect(x: Int(frame.width)-80, y: 60+(80*i), width: 60, height: 70))
            button.setTitle("ready", for: .normal)
            button.titleLabel!.fontStyle()
            button.accessibilityLabel = question.path
            button.tag = Int(question.time)
            button.addTarget(self, action: #selector(clicked), for: .touchUpInside)
            addSubview(button)
            
            i += 1
        }
        contentSize = CGSize(width: frame.width, height: CGFloat(i*80)+60)
    }
    
    @objc func clicked(sender: UIButton){
        let block = UIView(frame: sender.frame)
        sender.superview!.addSubview(block)
        Firebase.shared.scores(self)
        wait.backgroundColor = .systemRed
        wait.setTitle("waiting", for: .normal)
        if !pause{
            sender.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
            pause = true
            Firebase.shared.questionReady(sender.accessibilityLabel!)
            Timer.scheduledTimer(withTimeInterval: TimeInterval(sender.tag), repeats: false, block: { _ in
                self.pause = false
                self.wait.backgroundColor = .systemGreen
                self.wait.setTitle("ready", for: .normal)
            })
        }
        
    }
}

struct q{
    var question: String
    var time: Double
    var path: String
}

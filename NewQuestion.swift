//
//  NewQuestion.swift
//  quiz master
//
//  Created by Karl Cridland on 02/05/2020.
//  Copyright © 2020 Karl Cridland. All rights reserved.
//

import Foundation
import UIKit

class NewQuestion: UIView {
    
    var question = Question("", [], 0.0)
    var answers = [Answer]()
    let title = UITextField()
    var ans = [UITextField]()
    private let origin: CGRect
    private let qnumber = UILabel()
    var seconds = 5
    var expand = UIButton()
    var expanded = true
    
    let delete = UIButton()
    let secondsLabel = UILabel()
    
    override init(frame: CGRect) {
        self.origin = frame
        super .init(frame: frame)
        style()
        clipsToBounds = true
        qnumber.frame = CGRect(x: 20, y: 20, width: frame.width-40, height: 30)
        qnumber.fontStyle()
        qnumber.textAlignment = .left
        addSubview(qnumber)
        expand = QButton(frame: qnumber.frame, q: self)
        addSubview(expand)
        delete.setTitle("delete", for: .normal)
        delete.backgroundColor = .systemRed
        delete.titleLabel?.fontStyle()
        delete.frame = CGRect(x: frame.width-85, y: 20, width: 70, height: 30)
        delete.layer.cornerRadius = 6.0
        addSubview(delete)
        title.frame = CGRect(x: 20, y: 70, width: frame.width-40, height: 30)
        title.font = .systemFont(ofSize: 18.0, weight: UIFont.Weight(10.0))
        let background = UIView(frame: CGRect(x: 10, y: 70, width: frame.width-20, height: 30))
        background.backgroundColor = .white
        background.layer.cornerRadius = 4
        addSubview(background)
        addSubview(title)
        let answersLabel = UILabel(frame: CGRect(x: 20, y: 110, width: frame.width-40, height: 30))
        answersLabel.text = "Answers:"
        addSubview(answersLabel)
        answersLabel.fontStyle()
        answersLabel.textAlignment = .left
        title.textColor = .black
        secondsLabel.frame = CGRect(x: 20, y: 400, width: frame.width-40, height: 30)
        secondsLabel.text = "Duration: \(seconds) seconds"
        addSubview(secondsLabel)
        secondsLabel.fontStyle()
        secondsLabel.textAlignment = .left
        
        let less = UIButton(frame: CGRect(x: frame.width-90, y: 400, width: 30, height: 30))
        let more = UIButton(frame: CGRect(x: frame.width-50, y: 400, width: 30, height: 30))
        less.style()
        more.style()
        less.addTarget(self, action: #selector(decrease), for: .touchUpInside)
        more.addTarget(self, action: #selector(increase), for: .touchUpInside)
        less.setTitle("-", for: .normal)
        more.setTitle("+", for: .normal)
        less.titleLabel?.fontStyle()
        more.titleLabel?.fontStyle()
        addSubview(less)
        addSubview(more)
        
        for i in 0 ..< 6{
            let a = UITextField(frame: CGRect(x: 20, y: 150+CGFloat(i)*40, width: frame.width-50, height: 30))
            a.font = .systemFont(ofSize: 18.0, weight: UIFont.Weight(10.0))
            ans.append(a)
            let b = UIView(frame: CGRect(x: 10, y: 150+CGFloat(i)*40, width: frame.width-20, height: 30))
            b.layer.cornerRadius = 4
            b.backgroundColor = .white
            addSubview(b)
            addSubview(a)
            let correct = UIView(frame: CGRect(x: frame.width-45, y: 5, width: 20, height: 20))
            correct.layer.cornerRadius = 10.0
            b.addSubview(correct)
            if i == 0{
                correct.backgroundColor = .systemGreen
            }
            else{
                correct.backgroundColor = .systemRed
            }
        }
        
        for a in ans{
            a.textColor = .black
        }
    }
    
    func acceptable() -> Bool{
        var i = 0
        for answer in ans{
            if answer.text!.count > 0{
                i += 1
            }
        }
        if (i >= 2) && (title.text!.count > 0){
            return true
        }
        else{
            shake()
            return false
        }
    }
    
    @objc func increase(){
        if seconds < 20{
            seconds += 1
        }
        secondsLabel.text = "Duration: \(seconds) seconds"
    }
    
    @objc func decrease(){
        if seconds > 5{
            seconds -= 1
        }
        secondsLabel.text = "Duration: \(seconds) seconds"
    }
    
    func number(_ i: Int){
        qnumber.text = "Question \(i):"
    }
    
    func all() -> [UITextField]{
        var n = ans
        n.append(title)
        return n
    }
    
    func finished() -> Question{
        answers.removeAll()
        var i = 0
        for a in ans{
            if i == 0{
                answers.append(Answer(a.text!, true))
            }
            else{
                answers.append(Answer(a.text!, false))
            }
            i += 1
        }
        return Question(title.text!, answers, TimeInterval(seconds))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class QButton: UIButton{
    
    let question: NewQuestion
    
    init(frame: CGRect, q: NewQuestion) {
        self.question = q
        super .init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

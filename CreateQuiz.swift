//
//  CreateQuiz.swift
//  quiz master
//
//  Created by Karl Cridland on 02/05/2020.
//  Copyright © 2020 Karl Cridland. All rights reserved.
//

import Foundation
import UIKit

class CreateQuiz: UIScrollView {
    
    var questions = [NewQuestion]()
    var title = UITextField()
    var password = UITextField()
    
    init() {
        super .init(frame: CGRect(x: 10, y: 50, width: UIScreen.main.bounds.width-20, height: UIScreen.main.bounds.height-50))
        let question = NewQuestion(frame: CGRect(x: 10, y: 200, width: frame.width-20, height: 400))
        let question1 = NewQuestion(frame: CGRect(x: 10, y: 200, width: frame.width-20, height: 400))
        title.font = .systemFont(ofSize: 18, weight: UIFont.Weight(rawValue: 10))
        title.text = "title"
        title.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        password.font = .systemFont(ofSize: 18, weight: UIFont.Weight(rawValue: 10))
        password.text = "password"
        password.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        title.addTarget(self, action: #selector(titleClickOn), for: .editingDidBegin)
        title.addTarget(self, action: #selector(titleClickOff), for: .editingDidEnd)
        password.addTarget(self, action: #selector(passwordClickOn), for: .editingDidBegin)
        password.addTarget(self, action: #selector(passwordClickOff), for: .editingDidEnd)
        questions.append(question)
        questions.append(question1)
        clipsToBounds = false
        display()
        showsVerticalScrollIndicator = false
        NotificationCenter.default.addObserver(self, selector: #selector(handle(keyboardShowNotification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    @objc func display(){
        removeAll()
        let home = HomeButton(frame: CGRect(x: 10, y: 0, width: 80, height: 40))
        addSubview(home)
        home.setTitle("back", for: .normal)
        let label = UILabel(frame: CGRect(x: 100, y: 0, width: frame.width-200, height: 40))
        label.fontStyle()
        label.text = "new quiz"
        label.style()
        label.clipsToBounds = true
        addSubview(label)
        let submit = UIButton(frame: CGRect(x: frame.width-90, y: 0, width: 80, height: 40))
        submit.style()
        submit.titleLabel?.fontStyle()
        addSubview(submit)
        submit.setTitle("submit", for: .normal)
        submit.addTarget(self, action: #selector(submitQuiz), for: .touchUpInside)
        let bkg = UIView(frame: CGRect(x: 10, y: 55, width: frame.width-20, height: 30))
        bkg.backgroundColor = .white
        bkg.layer.cornerRadius = 4.0
        addSubview(bkg)
        let bkg2 = UIView(frame: CGRect(x: 10, y: 105, width: frame.width-20, height: 30))
        bkg2.backgroundColor = .white
        bkg2.layer.cornerRadius = 4.0
        addSubview(bkg2)
        title.frame = CGRect(x: 20, y: 50, width: frame.width-40, height: 40)
        password.frame = CGRect(x: 20, y: 100, width: frame.width-40, height: 40)
        addSubview(title)
        addSubview(password)
        var i = 0
        var e = 0
        for question in questions{
            if questions.count == 1{
                question.delete.removeFromSuperview()
            }
            else{
                question.addSubview(question.delete)
            }
            question.delete.tag = i
            question.delete.addTarget(self, action: #selector(removeQuestion), for: .touchUpInside)
            question.frame = CGRect(x: 10, y: CGFloat(i)*470 + 150 - CGFloat(e)*380, width: frame.width-20, height: 450)
            if !question.expanded{
                question.frame = CGRect(x: 10, y: CGFloat(i)*470 + 150 - CGFloat(e)*380, width: frame.width-20, height: 70)
                e += 1
            }
            question.number(i+1)
            question.expand.addTarget(self, action: #selector(expand), for: .touchUpInside)
            addSubview(question)
            i += 1
        }
        
        let new = UIButton(frame: CGRect(x: frame.width/2 - 30, y: CGFloat(i)*470 + 150 - CGFloat(e)*380, width: 60, height: 60))
        addSubview(new)
        new.style()
        new.layer.cornerRadius = 30
        new.setTitle("+", for: .normal)
        new.titleLabel?.fontStyle()
        new.addTarget(self, action: #selector(addQuestion), for: .touchUpInside)
        contentSize = CGSize(width: frame.width, height: CGFloat(i)*470 + 210 - CGFloat(e)*380)
        var fields = [UITextField]()
        fields.append(title)
        fields.append(password)
        for newq in questions{
            for f in newq.all(){
                fields.append(f)
            }
        }
        for field in fields{
            field.addTarget(self, action: #selector(resigned), for: .editingDidEnd)
            field.accessibilityElements = fields
        }
    }
    
    @objc func resigned(sender: UITextField){
        let fields = sender.accessibilityElements! as! [UITextField]
        var a = false
        for field in fields{
            if field.resignFirstResponder(){
                a = true
            }
        }
        if a{
            frame = CGRect(x: 10, y: 50, width: UIScreen.main.bounds.width-20, height: UIScreen.main.bounds.height-50)
        }
    }
    
    @objc func expand(sender: QButton){
        UIView.animate(withDuration: 0.2, animations: {
            if sender.question.expanded{
                sender.question.frame = CGRect(x: sender.question.frame.minX, y: sender.question.frame.minY, width: sender.question.frame.width, height: 70)
                for subview in self.subviews{
                    if subview.frame.minY > sender.question.frame.minY{
                        if (subview is NewQuestion) || (subview is UIButton){
                            subview.center = CGPoint(x: subview.center.x, y: subview.center.y - 380)
                        }
                    }
                }
            }
            else{
                sender.question.frame = CGRect(x: sender.question.frame.minX, y: sender.question.frame.minY, width: sender.question.frame.width, height: 450)
                for subview in self.subviews{
                    if subview.frame.minY > sender.question.frame.minY{
                        if (subview is NewQuestion) || (subview is UIButton){
                            subview.center = CGPoint(x: subview.center.x, y: subview.center.y + 380)
                        }
                    }
                }
            }
        })
        sender.question.expanded = !sender.question.expanded
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false, block: { _ in
            self.display()
        })
    }
    
    @objc func submitQuiz(){
        var i = 0
        for question in questions{
            if question.acceptable(){
                i += 1
            }
        }
        if i == questions.count{
            if title.text != "title"{
                if password.text != "password"{
                    var q = [Question]()
                    for question in questions{
                        q.append(question.finished())
                    }
                    Firebase.shared.upload(title: title.text!, password: password.text!, questions: q, view: homeView())
                }
                else{
                    password.shake()
                }
            }
            else{
                title.shake()
            }
            if password.text == "password"{
                password.shake()
            }
        }
    }
    
    @objc func addQuestion(){
        let new = NewQuestion(frame: CGRect(x: 10, y: 200, width: frame.width-20, height: 400))
        questions.append(new)
        display()
    }
    
    @objc func removeQuestion(sender: UIButton){
        questions.remove(at: sender.tag)
        let temp = contentOffset
        display()
        contentOffset = temp
        UIView.animate(withDuration: 0.2, animations: {
            if self.contentOffset.y > self.contentSize.height - self.frame.height{
                self.contentOffset = CGPoint(x: 0, y: self.contentSize.height - self.frame.height)
            }
            if self.contentSize.height < self.frame.height{
                self.contentOffset = CGPoint(x: 0, y: 0)
            }
        })
    }
    
    @objc private func handle(keyboardShowNotification notification: Notification) {
        if let userInfo = notification.userInfo, let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            frame = CGRect(x: 10, y: 50, width: UIScreen.main.bounds.width-20, height: UIScreen.main.bounds.height-keyboardRectangle.height-70)
        }
    }
    
    @objc func titleClickOn(){
        if title.text == "title"{
            title.text = ""
            title.textColor = .black
        }
    }
    
    @objc func titleClickOff(){
        if title.text! == ""{
            title.text = "title"
            title.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
    }
    
    @objc func passwordClickOn(){
        if password.text == "password"{
            password.text = ""
            password.textColor = .black
            password.textContentType = .password
            password.isSecureTextEntry = true
        }
    }
    
    @objc func passwordClickOff(){
        if password.text! == ""{
            password.text = "password"
            password.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            password.textContentType = .none
            password.isSecureTextEntry = false
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

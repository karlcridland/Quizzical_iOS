//
//  JoinQuiz.swift
//  quiz master
//
//  Created by Karl Cridland on 02/05/2020.
//  Copyright © 2020 Karl Cridland. All rights reserved.
//

import Foundation
import UIKit

class JoinQuiz: UIView {
    
    var keys = [UITextField]()
    let button = UIButton()
    let sTitle = UILabel()
    let cancel = HomeButton(frame: CGRect(x: 0, y: 120, width: (UIScreen.main.bounds.width-20)/2, height: 80))
    
    init() {
        super .init(frame: CGRect(x: 10, y: 150, width: UIScreen.main.bounds.width-20, height: 200))
        style()
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width-20, height: 50))
        title.fontStyle()
        title.text = "Enter code:"
        addSubview(title)
        let width = (UIScreen.main.bounds.width-90)/6
        for a in 0...5{
            let key = UITextField(frame: CGRect(x: CGFloat(a)*(width+10)+10, y: 70, width: width, height: 50))
            keys.append(key)
            addSubview(key)
            key.backgroundColor = .white
            key.textAlignment = .center
            key.addTarget(self, action: #selector(nextBox), for: .editingChanged)
            key.addTarget(self, action: #selector(clickedOn), for: .editingDidBegin)
            key.autocapitalizationType = .none
            key.font = UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight(10.0))
            key.textColor = .black
        }
        keys[0].becomeFirstResponder()
        
        
        sTitle.frame = CGRect(x: (UIScreen.main.bounds.width-20)/2, y: 120, width: (UIScreen.main.bounds.width-20)/2, height: 80)
        sTitle.text = "submit"
        sTitle.fontStyle()
        addSubview(sTitle)
        
        button.frame = sTitle.frame
        addSubview(button)
        button.addTarget(self, action: #selector(submit), for: .touchUpInside)
        
        addSubview(cancel)
        cancel.layer.borderWidth = 0
        cancel.backgroundColor = .clear
        cancel.setTitle("back", for: .normal)
    }
    
    @objc func clickedOn(sender: UITextField){
        sender.text = ""
    }
    
    @objc func nextBox(){
        var i = 0
        var h = -1
        for key in keys{
            key.text = key.text!.first().uppercased()
            if key.isFirstResponder{
                if key.text!.count > 0{
                    h = i
                }
            }
            i += 1
        }
        if h >= 0{
            if h+1 == keys.count{
                outOfBoxes(h)
            }
            else{
                keys[h+1].becomeFirstResponder()
                keys[h+1].text = ""
            }
        }
    }
    
    func outOfBoxes(_ h: Int){
        keys[h].resignFirstResponder()
    }
    
    func input(_ code: String){
        if code.count == 6{
            var i = 0
            for key in keys{
                key.text = code.codeString().atIndex(i)
                i += 1
            }
        }
    }
    
    @objc func submit(){
        var code = ""
        for letter in keys{
            code += letter.text!
        }
        if code.count != 6{
            shake()
        }
        else{
            Firebase.shared.availableQuiz(code, self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension String{
    func atIndex(_ i: Int) -> String{
        var j = 0
        for c in self{
            if i == j{
                return String(c)
            }
            j += 1
        }
        return ""
    }
}

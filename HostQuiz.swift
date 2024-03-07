//
//  HostQuiz.swift
//  quiz master
//
//  Created by Karl Cridland on 02/05/2020.
//  Copyright © 2020 Karl Cridland. All rights reserved.
//

import Foundation
import UIKit

class HostQuiz: JoinQuiz {
    
    let pword = UITextField()
    
    override init() {
        super .init()
        for key in keys{
            key.center = CGPoint(x: key.center.x, y: key.center.y-25)
        }
        pword.textColor = .black
        let pTitle = UILabel(frame: CGRect(x: 0, y: 100, width: frame.width, height: 40))
        pTitle.fontStyle()
        pTitle.text = "Enter Password:"
        addSubview(pTitle)
        
        sTitle.center = CGPoint(x: sTitle.center.x, y: sTitle.center.y+60)
        button.frame = sTitle.frame
        
        let bkgrnd = UIView(frame: CGRect(x: 10, y: 150, width: frame.width-20, height: 40))
        bkgrnd.backgroundColor = .white
        pword.frame = CGRect(x: 20, y: 150, width: frame.width-40, height: 40)
        addSubview(bkgrnd)
        addSubview(pword)
        
        pword.textContentType = .password
        pword.isSecureTextEntry = true
        pword.font = UIFont.systemFont(ofSize: 20.0, weight: UIFont.Weight(10.0))
        
        frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height+50)
        cancel.frame = CGRect(x: 0, y: frame.height-70, width: (UIScreen.main.bounds.width-20)/2, height: 80)
    }
    
    override func submit() {
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
    
    override func outOfBoxes(_ h: Int) {
        pword.becomeFirstResponder()
    }
    
    func password() -> String{
        return pword.text!.encrypt()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


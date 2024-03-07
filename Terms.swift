//
//  Terms.swift
//  quiz master
//
//  Created by Karl Cridland on 04/05/2020.
//  Copyright © 2020 Karl Cridland. All rights reserved.
//

import Foundation
import UIKit

class Terms: UIView {
    
    let textView = UITextView()
    var tick = UIButton()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        textView.isEditable = false
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: 60))
        title.fontStyle()
        title.text = "Terms & Conditions"
        addSubview(title)
        if let filepath = Bundle.main.path(forResource: "EULA", ofType: "txt") {
            do {
                let contents = try String(contentsOfFile: filepath)
                textView.text = contents
            } catch {
                // contents could not be loaded
            }
        } else {
            // example.txt not found!
        }
        style()
        backgroundColor = .systemBlue
        textView.frame = CGRect(x: 10, y: 60, width: frame.width-20, height: frame.height-200)
        textView.backgroundColor = .clear
        textView.textColor = .white
        addSubview(textView)
        
        let label = UILabel(frame: CGRect(x: 70, y: frame.height-140, width: frame.width-80, height: 90))
        label.fontStyle()
        label.textAlignment = .left
        label.text = "I have read through the above agreement and agree to not produce objectionable or abusive content"
        addSubview(label)
        label.font = .systemFont(ofSize: 14.0, weight: UIFont.Weight(10))
        
        tick = tickbox(frame: CGRect(x: 20, y: frame.height-110, width: 30, height: 30))
        addSubview(tick)
        
        let confirm = UIButton(frame: CGRect(x: 0, y: frame.height-60, width: frame.width, height: 50))
        confirm.setTitle("confirm", for: .normal)
        confirm.titleLabel?.fontStyle()
        addSubview(confirm)
        confirm.addTarget(self, action: #selector(confirmed), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func confirmed(){
        if (tick as! tickbox).ticked{
            self.fadeOut(0.1)
            Settings.shared.defaults.set(true, forKey: "terms")
            Firebase.shared.newUser()
        }
        else{
            shake()
        }
    }
}

private class tickbox: UIButton {
    
    var ticked = false
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        style()
        setTitle("✓", for: .normal)
        titleLabel?.font = .systemFont(ofSize: 15, weight: UIFont.Weight(14))
        setTitleColor(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1), for: .normal)
        addTarget(self, action: #selector(click), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func click(){
        ticked = !ticked
        if ticked{
            setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        }
        else{
            setTitleColor(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1), for: .normal)
        }
    }
}

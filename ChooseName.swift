//
//  ChooseName.swift
//  quiz master
//
//  Created by Karl Cridland on 01/05/2020.
//  Copyright © 2020 Karl Cridland. All rights reserved.
//

import Foundation
import UIKit

class ChooseName: UIView {
    
    private let round: Round
    private let input = UITextField()
    let button = UIButton()
    let title = UILabel()
    var started = false
    let home = HomeButton(frame: CGRect(x: 10, y: 10, width: 100, height: 40))
    let share = UIView()
    
    func quizName(_ name: String){
        round.title = name
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: share.frame.width-55, height: share.frame.height))
        label.fontStyle()
        label.textAlignment = .left
        label.text = name
        share.addSubview(label)
    }
    
    init(frame: CGRect, round: Round) {
        self.round = round
        super .init(frame: frame)
        
        backgroundColor = .systemBlue
        layer.cornerRadius = 7.5
        layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        layer.borderWidth = 4.0
        
        title.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height/2 - 15)
        title.text = "Enter your name:"
        title.numberOfLines = 0
        title.textAlignment = .center
        title.font = .systemFont(ofSize: 18.0, weight: UIFont.Weight(10.0))
        title.textColor = .white
        
        let b = UIView(frame: CGRect(x: 10, y: frame.height/2 - 15, width: frame.width-20, height: 30))
        b.layer.cornerRadius = 4.0
        b.backgroundColor = .white
        
        input.frame = CGRect(x: 20, y: frame.height/2 - 15, width: frame.width-40, height: 30)
        input.becomeFirstResponder()
        input.font = UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight(10.0))
        input.textColor = .black
        
        let buttontitle = UILabel(frame: CGRect(x: 10, y: frame.height - 60, width: frame.width-20, height: 60))
        buttontitle.text = "continue"
        buttontitle.numberOfLines = 0
        buttontitle.textAlignment = .center
        buttontitle.font = .systemFont(ofSize: 18.0, weight: UIFont.Weight(10.0))
        buttontitle.textColor = .white
        
        button.frame = CGRect(x: 10, y: frame.height - 60, width: frame.width-20, height: 60)
        button.accessibilityElements = [self]
        
        addSubview(buttontitle)
        addSubview(button)
        addSubview(title)
        addSubview(b)
        addSubview(input)
        
        share.style()
        share.clipsToBounds = true
        Firebase.shared.quizTitle(round.getQuiz(), self)
        
        home.frame = CGRect(x: frame.minX, y: frame.minY - 50, width: 100, height: 40)
        share.frame = CGRect(x: frame.minX + 110, y: frame.minY - 50, width: UIScreen.main.bounds.width - (frame.minX + 130), height: 40)
        let shareButton = Share(frame: CGRect(x: share.frame.width-32.5, y: 7.5, width: 25, height: 25))
        
        shareButton.addTarget(self, action: #selector(shared), for: .touchUpInside)
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: { _ in
            if self.superview != nil{
                self.superview!.addSubview(self.home)
                self.superview!.addSubview(self.share)
                self.share.addSubview(shareButton)
            }
        })
    }
    
    @objc func shared(){
        print(3987)
        // text to share
        let text = "Quizzical code: \(round.getQuiz())! Compete with me! com.quizzical://?\(round.getQuiz())"

        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.homeView() // so that iPads won't crash

        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop ]

        // present the view controller
        let main = self.homeView().accessibilityElements![0] as! UIViewController
        main.present(activityViewController, animated: true, completion: nil)
    }
    
    func waiting(){
        var i = 0
        removeAll()
        superview!.addSubview(self.home)
        addSubview(title)
        UIView.animate(withDuration: 0.3, animations: {
            self.title.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        })
        Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true, block: { timer in
            if self.started == true{
                timer.invalidate()
            }
            self.title.text = "Waiting for quiz to start"
            for _ in 0 ... i{
                self.title.text = self.title.text!+"."
            }
            i += 1
            if i == 3{
                i = 0
            }
        })
    }
    
    func get() -> String{
        return input.text!
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

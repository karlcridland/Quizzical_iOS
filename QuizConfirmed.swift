//
//  QuizConfirmed.swift
//  quiz master
//
//  Created by Karl Cridland on 04/05/2020.
//  Copyright © 2020 Karl Cridland. All rights reserved.
//

import Foundation
import UIKit

class QuizConfirmed: UIView {
    
    let code: String
    let password: String
    
    init(code: String, password: String) {
        self.code = code
        self.password = password
        super .init(frame: CGRect(x: 10, y: 100, width: UIScreen.main.bounds.width-20, height: 300))
        style()
        let complete = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: 50))
        complete.fontStyle()
        complete.text = "quiz uploaded"
        addSubview(complete)
        let unique = UILabel(frame: CGRect(x: 0, y: 50, width: frame.width, height: 50))
        unique.fontStyle()
        unique.text = "your unique code to share:"
        addSubview(unique)
        let width = (frame.width - 70)/6
        var i = 0
        for a in code{
            let box = UILabel(frame: CGRect(x: CGFloat(i)*(width+10)+10, y: 100, width: width, height: 60))
            addSubview(box)
            box.text = String(a)
            box.backgroundColor = .white
            box.fontStyle()
            box.textColor = .black
            i += 1
        }
        let playnow = UILabel(frame: CGRect(x: 0, y: 160, width: frame.width, height: 70))
        playnow.fontStyle()
        playnow.text = "Would you like to play now?"
        addSubview(playnow)
        let no = HomeButton(frame: CGRect(x: 0, y: 210, width: frame.width/2, height: 90))
        addSubview(no)
        no.setTitle("no", for: .normal)
        no.layer.borderWidth = 0
        no.backgroundColor = .clear
        let yes = UIButton(frame: CGRect(x: frame.width/2, y: 210, width: frame.width/2, height: 90))
        yes.setTitle("yes", for: .normal)
        yes.titleLabel?.fontStyle()
        addSubview(yes)
        yes.addTarget(self, action: #selector(playNow), for: .touchUpInside)
        
        let shareButton = Share(frame: CGRect(x: UIScreen.main.bounds.width-65, y: 15, width: 25, height: 25))
        shareButton.addTarget(self, action: #selector(share), for: .touchUpInside)
        addSubview(shareButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func playNow(){
        let host = HostQuiz()
        host.pword.text = password
        homeView().addSubview(host)
        host.isHidden = true
        Firebase.shared.availableQuiz(code, host)
    }
    
    @objc func share(){

        // text to share
        let text = "Quizzical code: \(code)! Join my quiz and beat your friends. com.quizzical://?\(code)"

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
}

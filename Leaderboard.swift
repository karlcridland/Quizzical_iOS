//
//  Leaderboard.swift
//  quiz master
//
//  Created by Karl Cridland on 03/05/2020.
//  Copyright © 2020 Karl Cridland. All rights reserved.
//

import Foundation
import UIKit

class Leaderboard: UIScrollView {
    
    var isExpanded = false
    var scores: [user]
    var button = UIButton()
    
    init(frame: CGRect, _ scores: [user]) {
        self.scores = scores
        super .init(frame: frame)
        button = LeaderButton(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), self)
        button.setTitle("leaderboard", for: .normal)
        button.titleLabel!.fontStyle()
        addSubview(button)
        style()
        backgroundColor = .systemBlue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ scores: [user]){
        self.scores = scores
        displayScores()
    }
    
    func displayScores(){
        var i = 0
        removeAll()
        let blocked = Settings.shared.blocked()
        let id = Settings.shared.defaults.value(forKey: "id") as! Int
        for player in scores.sorted(by: {$0.score > $1.score}){
            if !blocked.contains(player.id){
                let labelLeft = UILabel(frame: CGRect(x: 20, y: CGFloat(i)*(40)+10, width: frame.width-60, height: 30))
                labelLeft.text = "\(i+1). \(player.name)"
                labelLeft.fontStyle()
                let labelRight = UILabel(frame: CGRect(x: 20, y: CGFloat(i)*(40)+10, width: frame.width-80, height: 30))
                labelRight.text = "\(Double(player.score)/100)"
                labelRight.fontStyle()
                labelLeft.textAlignment = .left
                labelRight.textAlignment = .right
                let report = UIButton(frame: CGRect(x: frame.width-50, y: CGFloat(i)*(40)+10, width: 40, height: 30))
                report.setTitle("•••", for: .normal)
                report.accessibilityElements = [player]
                report.addTarget(self, action: #selector(reported), for: .touchUpInside)
                addSubview(labelLeft)
                addSubview(labelRight)
                if player.id != id{
                    addSubview(report)
                }
                else{
                    labelLeft.textColor = .systemYellow
                    labelRight.textColor = .systemYellow
                }
                i += 1
            }
        }
        contentSize = CGSize(width: frame.width, height: CGFloat(i)*(40)+20)
        addSubview(button)
        button.setTitle("", for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: frame.width-50, height: [contentSize.height, frame.height].max()!)
        bringSubviewToFront(button)
    }
    
    @objc func reported(sender: UIButton){
        let back = UIButton(frame: homeView().frame)
        homeView().addSubview(back)
        homeView().addSubview(ConfirmBlock(frame: CGRect(x: 0, y: UIScreen.main.bounds.height-230, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*2), player: sender.accessibilityElements![0] as! user, back, leaderboard: self))
    }
}

class LeaderButton: UIButton{
    
    let leaderboard: Leaderboard
    
    init(frame: CGRect, _ leaderboard: Leaderboard) {
        self.leaderboard = leaderboard
        super .init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

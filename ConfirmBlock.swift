//
//  ConfirmBlock.swift
//  quiz master
//
//  Created by Karl Cridland on 05/05/2020.
//  Copyright © 2020 Karl Cridland. All rights reserved.
//

import Foundation
import UIKit

class ConfirmBlock: UIView {
    
    let player: user
    private let back: UIButton
    private let leaderboard: Leaderboard
    var playing = false
    
    init(frame: CGRect, player: user, _ back: UIButton, leaderboard: Leaderboard) {
        self.player = player
        self.back = back
        self.leaderboard = leaderboard
        super .init(frame: CGRect(x: frame.minX, y: UIScreen.main.bounds.height, width: frame.width, height: frame.height))
        UIView.animate(withDuration: 0.3, animations: {
            self.frame = frame
        })
        backgroundColor = .systemGray4
        layer.cornerRadius = 8.0
        
        let report = UIButton(frame: CGRect(x: 5, y: 5, width: frame.width-10, height: 60))
        report.setTitle("report", for: .normal)
        report.setTitleColor(.systemRed, for: .normal)
        addSubview(report)
        report.layer.cornerRadius = 4.0
        report.backgroundColor = .white
        report.addTarget(self, action: #selector(reported), for: .touchUpInside)
        
        let block = UIButton(frame: CGRect(x: 5, y: 70, width: frame.width-10, height: 60))
        block.setTitle("block", for: .normal)
        block.setTitleColor(.systemRed, for: .normal)
        addSubview(block)
        block.layer.cornerRadius = 4.0
        block.backgroundColor = .white
        block.addTarget(self, action: #selector(blocked), for: .touchUpInside)
        
        let cancel = UIButton(frame: CGRect(x: 5, y: 135, width: frame.width-10, height: 60))
        cancel.setTitle("cancel", for: .normal)
        cancel.setTitleColor(.black, for: .normal)
        addSubview(cancel)
        cancel.layer.cornerRadius = 4.0
        cancel.backgroundColor = .white
        cancel.addTarget(self, action: #selector(remove), for: .touchUpInside)
        back.addTarget(self, action: #selector(remove), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func blocked(){
        Firebase.shared.blockUser(String(player.id), leaderboard: leaderboard)
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { _ in
            if self.playing{
                self.homeView().removeAll()
                self.homeView().addSubview(HomeScreen())
            }
            self.homeView().addSubview(BlockNotification())
        })
        removeFromSuperview()
    }
    
    @objc func reported(){
        Firebase.shared.reportUser(String(player.id), leaderboard: leaderboard)
        removeFromSuperview()
    }
    
    @objc func remove(){
        removeFromSuperview()
    }
    
    override func removeFromSuperview() {
        back.removeFromSuperview()
        UIView.animate(withDuration: 0.3, animations: {
            self.frame = CGRect(x: self.frame.minX, y: UIScreen.main.bounds.height, width: self.frame.width, height: self.frame.height)
        })
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { _ in
            super.removeFromSuperview()
        })
    }
}

class BlockNotification: UIView{
    
    init() {
        super .init(frame: CGRect(x: 10, y: -60, width: UIScreen.main.bounds.width-20, height: 60))
        style()
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: 60))
        label.fontStyle()
        label.text = "User has been blocked."
        addSubview(label)
        UIView.animate(withDuration: 0.5, animations: {
            self.frame = CGRect(x: 10, y: 30, width: UIScreen.main.bounds.width-20, height: 60)
        })
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { _ in
            UIView.animate(withDuration: 0.5, animations: {
                self.frame = CGRect(x: 10, y: -60, width: UIScreen.main.bounds.width-20, height: 60)
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
                    self.removeFromSuperview()
                })
            })
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

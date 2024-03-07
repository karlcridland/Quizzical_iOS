//
//  Round.swift
//  quiz master
//
//  Created by Karl Cridland on 29/04/2020.
//  Copyright © 2020 Karl Cridland. All rights reserved.
//

import Foundation
import GoogleMobileAds
import UIKit

class Round: UIView {
    
    private var questions = [Question]()
    
    private var game: String
    private var code = String()
    private var name = String()
    var users = [user]()
    private var current_score = 0
    var playing = false
    var title = String()
    let home = HomeButton()
    var author = Int()
    
    var currentPosition = 0
    
    init(_ game: String) {
        self.game = game
        super .init(frame: CGRect(x: 0, y: 50, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-100))
    }
    
    func start(){
        let form = ChooseName(frame: CGRect(x: 20, y: 120, width: frame.width-40, height: 150), round: self)
        addSubview(form)
        form.button.addTarget(self, action: #selector(submit), for: .touchUpInside)
    }
    
    @objc func submit(sender: UIButton){
        let form = sender.accessibilityElements![0] as! ChooseName
        if form.get().acceptable(){
            nextQuestion()
            form.waiting()
            
            Firebase.shared.join(self,form.get())
        }
        else{
            form.shake()
        }
    }
    
    func join(_ code: String, _ name: String){
        self.code = code
        self.name = name
    }
    
    func append(_ question: Question){
        questions.append(question)
    }
    
    func nextQuestion(){
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
            var i = 1
            var a = 0
            for question in self.questions{
                if !question.answered && question.ready{
                    timer.invalidate()
                    self.play(question: question, round: i)
                    break
                }
                if question.answered{
                    a += 1
                }
                if a == self.questions.count{
                    let new = UIButton(frame: self.home.frame)
                    new.style()
                    new.titleLabel?.fontStyle()
                    new.setTitle("home", for: .normal)
                    new.addTarget(self, action: #selector(self.playAd), for: .touchUpInside)
                    self.home.removeFromSuperview()
                    self.addSubview(new)
                    timer.invalidate()
                    Firebase.shared.quizFinished()
                }
                i += 1
            }
        })
    }
    
    func reset(){
        for question in questions{
            question.answered = false
        }
    }
    
    @objc func reportBadWord(){
        let back = UIButton(frame: homeView().frame)
        homeView().addSubview(back)
        let c = ConfirmBlock(frame: CGRect(x: 0, y: UIScreen.main.bounds.height-230, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*2), player: user(name: "", id: author, score: 0), back, leaderboard: Leaderboard(frame: .zero, []))
        homeView().addSubview(c)
        c.playing = true
    }
    
    @objc func playAd(){
        print("play advertisement")
        (homeView().accessibilityElements![0] as! ViewController).interst()
    }
    
    func play(question: Question, round: Int){
        playing = true
        self.removeAll()
        home.frame = CGRect(x: 10, y: 5, width: 100, height: 40)
        addSubview(home)
        let report = UIButton(frame: CGRect(x: frame.width-110, y: 5, width: 100, height: 40))
        report.tag = -1
        report.style()
        report.setTitle("report", for: .normal)
        report.titleLabel?.fontStyle()
        report.backgroundColor = .systemRed
        report.addTarget(self, action: #selector(reportBadWord), for: .touchUpInside)
        addSubview(report)
        let timer = TimerView(frame: CGRect(x: 10, y: 120, width: UIScreen.main.bounds.width-20, height: 40), time: question.interval)
        let title = UILabel(frame: CGRect(x: 10, y: 50, width: UIScreen.main.bounds.width-20, height: 70))
        title.numberOfLines = 0
        title.font = UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight(10.0))
        title.text = question.title
        title.textAlignment = .center
        title.textColor = .white
        
        addSubview(title)
        let q = question.prepare(CGRect(x: 0, y: 170, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-310))
        for s in q.subviews{
            if s is AnswerBlock{
                (s as! AnswerBlock).addTarget(self, action: #selector(cls), for: .touchUpInside)
                (s as! AnswerBlock).accessibilityElements = [question,timer]
            }
        }
        addSubview(q)
        addSubview(timer)
        Timer.scheduledTimer(withTimeInterval: question.interval+0.5, repeats: false, block: { _ in
            question.answered = true
            self.removeAll()
            Firebase.shared.position(self, self.current_score)
            title.removeFromSuperview()
            self.nextQuestion()
            self.playing = false
        })
        bringSubviewsToFront([home,report])
    }
    
    @objc func cls(sender: AnswerBlock){
        let question = sender.accessibilityElements![0] as! Question
        question.answered = sender.correct()
        let timer = sender.accessibilityElements![1] as! TimerView
        question.score = timer.remaining()
        if question.correct{
            current_score += question.score
        }
        let block = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        addSubview(block)
        Firebase.shared.updateScore(game, code, current_score, self)
        bringSubviewsToFront([home])
    }
    
    func bringSubviewsToFront(_ views: [UIButton]) {
        for view in views{
            bringSubviewToFront(view)
        }
    }
    
    func getQuiz() -> String{
        return game
    }
    
    func getCode() -> String{
        return code
    }
    
    func top10(_ scores: [user]) -> Leaderboard {
        addSubview(home)
        home.frame = CGRect(x: 20, y: frame.height/2 - 150, width: UIScreen.main.bounds.width/2 - 25, height: 40)
        let b = Leaderboard(frame: CGRect(x: UIScreen.main.bounds.width/2 + 5, y: frame.height/2 - 150, width: UIScreen.main.bounds.width/2 - 25, height: 40), scores)
        b.style()
        b.button.addTarget(self, action: #selector(leaderboard), for: .touchUpInside)
        for sub in b.subviews{
            if sub is UIButton{
                b.bringSubviewToFront(sub)
            }
        }
        return b
    }
    
    @objc func leaderboard(sender: LeaderButton){
        if sender.leaderboard.isExpanded{
            UIView.animate(withDuration: 0.2, animations: {
                sender.leaderboard.removeAll()
                sender.leaderboard.frame = CGRect(x: UIScreen.main.bounds.width/2 + 5, y: self.frame.height/2 - 150, width: UIScreen.main.bounds.width/2 - 25, height: 40)
                sender.leaderboard.button.frame = CGRect(x: 0, y: 0, width: sender.leaderboard.frame.width, height: sender.leaderboard.frame.height)
                sender.leaderboard.addSubview(sender.leaderboard.button)
                sender.leaderboard.button.setTitle("leaderboard", for: .normal)
            })
        }
        else{
            UIView.animate(withDuration: 0.2, animations: {
                sender.leaderboard.removeAll()
                sender.leaderboard.frame = CGRect(x: 20, y: self.frame.height/2 - 100, width: UIScreen.main.bounds.width-40, height: 200)
                sender.leaderboard.displayScores()
                sender.leaderboard.addSubview(sender.leaderboard.button)
            })
        }
        sender.leaderboard.isExpanded = !sender.leaderboard.isExpanded
    }
    
    func score() -> UIView{
        let view = UIView(frame: CGRect(x: 20, y: frame.height/2 - 100, width: UIScreen.main.bounds.width-40, height: 200))
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 7.5
        view.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.layer.borderWidth = 4.0
        var s = 0
        var a = 0
        for question in questions{
            if question.correct{
                s += question.score
            }
            if question.answered{
                a += 1
            }
        }
        let label = UILabel(frame: CGRect(x: 10, y: 10, width: view.frame.width-20, height: 180))
        label.text = "player: \(name)\n\nscore: \(Double(s)/100)\n\nposition: \(currentPosition.ordinate())"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18.0, weight: UIFont.Weight(10.0))
        label.textColor = .white
        view.addSubview(label)
        return view
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIView{
    @objc func removeAll(){
        for s in self.subviews{
            if !(s is GADBannerView) && !(s is Background){
                s.removeFromSuperview()
            }
        }
    }
}

class bannerButton: UIButton {
    
    let banner: GADBannerView!
    
    init(frame: CGRect, banner: GADBannerView!) {
        self.banner = banner
        super .init(frame: frame)
        self.backgroundColor = .black
        self.setTitle("X", for: .normal)
        self.addTarget(self, action: #selector(remove), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func remove(){
        banner.removeFromSuperview()
    }
}

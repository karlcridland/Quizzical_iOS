//
//  Firebase.swift
//  quiz master
//
//  Created by Karl Cridland on 01/05/2020.
//  Copyright © 2020 Karl Cridland. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Firebase {
    
    public static let shared = Firebase()
    
    var active = false
    var current = active(quiz: "", name: "")
    private var hosting = ""
    
    private init(){
        
    }
    
    struct active {
        var quiz: String
        var name: String
    }
    
    func quizTitle(_ code: String, _ form: ChooseName){
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("quiz/\(code)/title").observeSingleEvent(of: .value, with: {(snapshot) in
            if let title = snapshot.value as? String{
                form.quizName(title)
            }
        })
    }
    
    func questions(_ code: String) -> Round{
        let round = Round(code)
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("quiz/\(code)/author").observeSingleEvent(of: .value, with: {(snap) in
            if let author = snap.value as? Int{
                round.author = author
            }
        })
        ref.child("quiz/\(code)/questions").observeSingleEvent(of: .value, with: {(snapshot) in
            for question in snapshot.children.allObjects as! [DataSnapshot]{
                let q = question.childSnapshot(forPath: "question").value as? String
                if q != nil{
                    var answers = [Answer]()
                    for a in question.childSnapshot(forPath: "answers").children.allObjects as! [DataSnapshot]{
                        let b = a.value as? String
                        if b != nil{
                            if a.key == "1"{
                                answers.append(Answer(b!, true))
                            }
                            else{
                                answers.append(Answer(b!, false))
                            }
                        }
                    }
                    let t = question.childSnapshot(forPath: "time").value as? Int
                    if t != nil{
                        let new = Question(q!, answers, Double(t!))
                        round.append(new)
                        self.observe("quiz/\(code)/questions/\(question.key)/go", question: new)
                    }
                }
            }
            self.observe("quiz/\(code)/reset", round: round)
            round.start()
        })
        return round
    }
    
    func join(_ round: Round, _ name: String){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("quiz/\(round.getQuiz())/").observeSingleEvent(of: .value, with: {(snapshot) in
            let id = Settings.shared.defaults.value(forKey: "id") as! Int
            
            for user in snapshot.childSnapshot(forPath: "players").children.allObjects as! [DataSnapshot]{
                if let nid = user.childSnapshot(forPath: "id").value as? Int{
                    if nid == id{
                        ref.child("quiz/\(round.getQuiz())/players/\(user.key)/").removeValue()
                    }
                }
            }
            let author = snapshot.childSnapshot(forPath: "author").value as? Int
            if author != nil{
                ref.child("users/\(author!)/blocked").observeSingleEvent(of: .value, with: {(snapshot) in
                    let list = self.decodeBlocked(snapshot.value as? String)
                    if !list.contains(id){
                        let all = snapshot.childSnapshot(forPath: "players").children.allObjects as! [DataSnapshot]
                        var allCodes = [String]()
                        for a in all{
                            allCodes.append(a.key)
                        }
                        while true{
                            let code = "".random()
                            if !allCodes.contains(code){
                                round.join(code, name)
                                ref.child("quiz/\(round.getQuiz())/players/\(code)/name").setValue(name)
                                ref.child("quiz/\(round.getQuiz())/players/\(code)/ready").setValue(true)
                                ref.child("quiz/\(round.getQuiz())/players/\(code)/score").setValue(0)
                                ref.child("quiz/\(round.getQuiz())/players/\(code)/id").setValue(Settings.shared.defaults.value(forKey: "id"))
                                self.current.name = code
                                self.current.quiz = round.getQuiz()
                                break
                            }
                        }
                    }
                    else{
                        round.homeView().removeAll()
                        round.homeView().addSubview(HomeScreen())
                    }
                })
            }
        })
    }
    
    private func decodeBlocked(_ csv: String?) -> [Int]{
        var list = [Int]()
        if csv != nil{
            let all = csv!.split(separator: ",")
            for user in all{
                list.append(Int(user)!)
            }
            return list
        }
        else{
            return []
        }
        
    }
    
    func player(_ round: Round, _ quiz: String){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("quiz/\(quiz)/players/\(round.getCode())").observeSingleEvent(of: .value, with: {(snapshot) in
            
        })
    }
    
    func position(_ round: Round, _ score: Int){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("quiz/\(round.getQuiz())/players/").observe(.value, with: {(snapshot) in
            let all = snapshot.children.allObjects as! [DataSnapshot]
            var scores = [Int]()
            var users = [user]()
            for a in all{
                let active = a.childSnapshot(forPath: "ready").value as? Bool
                if active != nil{
                    if active!{
                        let score = a.childSnapshot(forPath: "score").value as? Int
                        if score != nil{
                            scores.append(score!)
                            let name = a.childSnapshot(forPath: "name").value as? String
                            if name != nil{
                                let id = a.childSnapshot(forPath: "id").value as? Int
                                if id != nil{
                                    users.append(user(name: name!, id: id!, score: score!))
                                }
                            }
                        }
                    }
                }
            }
            var i = 1
            for s in scores.sorted().reversed(){
                if s == score{
                    round.currentPosition = i
                    break
                }
                i += 1
            }
            if !round.playing{
                round.addSubview(round.score())
            }
            self.filterAbuse(users, round)
        })
        
    }
    
    func scores(_ host: HostQuizPage){
        var users = [user]()
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("quiz/\(host.code)/players").observe(.value, with: {(snapshot) in
            for player in snapshot.children.allObjects as! [DataSnapshot]{
                if let id = player.childSnapshot(forPath: "id").value as? Int{
                    if self.contains(users, id){
                        if let score = player.childSnapshot(forPath: "score").value as? Int{
                            for u in users{
                                if u.id == id{
                                    if let name = player.childSnapshot(forPath: "name").value as? String{
                                        let t = user(name: name, id: u.id, score: score)
                                        users = self.removeUser(id, users)
                                        users.append(t)
                                    }
                                }
                            }
                        }
                    }
                    else{
                        if let score = player.childSnapshot(forPath: "score").value as? Int{
                            if let name = player.childSnapshot(forPath: "name").value as? String{
                                users.append(user(name: name, id: id, score: score))
                            }
                        }
                    }
                }
            }
            self.filterAbuse(users, host)
        })
    }
    
    func filterAbuse(_ users: [user], _ host: HostQuizPage){
        var new = users
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("users/").observeSingleEvent(of: .value, with: {(players) in
            for player in players.children.allObjects as! [DataSnapshot]{
                let flagged = player.childSnapshot(forPath: "flagged").value as? Bool
                if flagged != nil{
                    if flagged!{
                        new = self.removeUser(Int(player.key)!, new)
                    }
                }
            }
            var contains = false
            var l = UIScrollView()
            for sub in host.homeView().subviews{
                if sub is Leaderboard{
                    contains = true
                    l = sub as! Leaderboard
                }
            }
            if !contains{
                let lead = Leaderboard(frame: CGRect(x: 10, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width-20, height: UIScreen.main.bounds.height-180), new)
                lead.displayScores()
                lead.backgroundColor = .systemBlue
                let clear = UIButton(frame: CGRect(x: UIScreen.main.bounds.width-110, y: 100, width: 100, height: 40))
                clear.addTarget(self, action: #selector(self.removeLeaderboard), for: .touchUpInside)
                clear.accessibilityElements = [lead]
                clear.style()
                clear.titleLabel?.fontStyle()
                clear.setTitle("clear", for: .normal)
                host.homeView().addSubview(clear)
                host.homeView().addSubview(lead)
                UIView.animate(withDuration: 0.5, animations: {
                    lead.transform = CGAffineTransform(translationX: 0, y: -(UIScreen.main.bounds.height-150))
                })
            }
            else{
                (l as! Leaderboard).update(new)
            }
        })
    }
    
    @objc func removeLeaderboard(_ sender: UIButton){
        sender.fadeOut(0.1)
        let l = sender.accessibilityElements![0] as! Leaderboard
        UIView.animate(withDuration: 0.5, animations: {
            l.frame = CGRect(x: 10, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width-20, height: UIScreen.main.bounds.height-180)
        })
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            l.removeFromSuperview()
        })
    }
    
    private func contains(_ users: [user], _ id: Int) -> Bool{
        for user in users{
            if user.id == id{
                return true
            }
        }
        return false
    }
    
    func filterAbuse(_ users: [user], _ round: Round){
        var new = users
        let id = Settings.shared.defaults.value(forKey: "id") as! Int
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("users/").observe(.value, with: {(players) in
            for player in players.children.allObjects as! [DataSnapshot]{
                if let flagged = player.childSnapshot(forPath: "flagged").value as? Bool{
                    if flagged {
                        if Int(player.key)! != id{
                            new = self.removeUser(Int(player.key)!, new)
                        }
                    }
                }
            }
            if round.lbp(){
                for sub in round.homeView().subviews{
                    if sub is Leaderboard{
                        (sub as! Leaderboard).update(new)
                    }
                }
            }
            else{
                if !round.playing{
                    round.addSubview(round.top10(new))
                }
            }
        })
    }
    
    private func removeUser(_ id: Int, _ users: [user]) -> [user]{
        var new = [user]()
        for u in users{
            if u.id != id{
                new.append(u)
            }
        }
        return new
    }
    
    func availableQuiz(_ quiz: String, _ form: JoinQuiz){
        var valid = false
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("quiz/").observeSingleEvent(of: .value, with: {(snapshot) in
            for q in snapshot.children.allObjects as! [DataSnapshot]{
                if q.key == quiz.codeString(){
                    valid = true
                }
            }
            if valid{
                let view = form.homeView()
                view.removeAll()
                view.addSubview(Firebase.shared.questions(quiz))
            }
            else{
                form.shake()
            }
        })
    }
    
    func questionReady(_ path: String){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child(path).setValue(true)
    }
    
    func availableQuiz(_ quiz: String, _ form: HostQuiz){
        var valid = false
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("quiz/").observeSingleEvent(of: .value, with: {(snapshot) in
            for q in snapshot.children.allObjects as! [DataSnapshot]{
                if q.key == quiz.codeString(){
                    valid = true
                }
            }
            if valid{
                let password = snapshot.childSnapshot(forPath: "\(quiz)/password").value as? String
                if password != nil{
                    if password! == form.password(){
                        let view = form.homeView()
                        view.removeAll()
                        
                        let page = HostQuizPage(quiz)
                        let home = HomeButton(frame: CGRect(x: 10, y: 50, width: (UIScreen.main.bounds.width-20)/2-5, height: 40))
                        home.addTarget(self, action: #selector(self.hostLeftQuiz), for: .touchUpInside)
                        home.accessibilityLabel = quiz
                        view.addSubview(home)
                        view.addSubview(page.wait)
                        page.wait.frame = CGRect(x: (UIScreen.main.bounds.width-20)/2+15, y: 50, width: (UIScreen.main.bounds.width-20)/2-5, height: 40)
                        view.addSubview(page)
                        let t = snapshot.childSnapshot(forPath: "\(quiz)/title").value as? String
                        if t != nil{
                            page.title = t!
                        }
                        self.hosting = quiz
                        var i = 1
                        for question in snapshot.childSnapshot(forPath: "\(quiz)/questions").children.allObjects as! [DataSnapshot]{
                            let title = question.childSnapshot(forPath: "question").value as? String
                            if title != nil{
                                let time = question.childSnapshot(forPath: "time").value as? Int
                                if time != nil{
                                    page.questions.append(q(question: title!, time: Double(time!), path: "quiz/\(quiz)/questions/\(i)/go"))
                                }
                            }
                            i += 1
                        }
                        page.ready()
                        
                        var ref: DatabaseReference!
                        ref = Database.database().reference()
                        ref.child("quiz/\(quiz)/active").setValue(true)
                        for a in 1 ..< i{
                            ref.child("quiz/\(quiz)/questions/\(a)/go").setValue(false)
                        }
                        self.playerCount(quiz, page)
                    }
                }
                else{
                    form.shake()
                }
            }
            else{
                form.shake()
            }
        })
    }
    
    func playerCount(_ code: String, _ host: HostQuizPage){
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("quiz/\(code)/players").observe(.value, with: {(snapshot) in
            let players = snapshot.children.allObjects as! [DataSnapshot]
            var i = 0
            for player in players{
                let ready = player.childSnapshot(forPath: "ready").value as? Bool
                if ready != nil{
                    if ready!{
                        i += 1
                    }
                }
            }
            
            switch i{
            case 0:
                host.label.text = "\(host.title)"
                break
            case 1:
                host.label.text = "\(host.title) - \(i) player"
                break
            default:
                host.label.text = "\(host.title) - \(i) players"
            }
        })
    }
    
    func report(_ code: String){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("quiz/\(code)/flagged").setValue(true)
    }
    
    func updateScore(_ quiz: String, _ player: String, _ score: Int, _ round: Round){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("quiz/\(quiz)/players/\(player)/score").setValue(score)
        
    }
    
    func inactive(){
        if current.quiz.count > 0 && current.name.count > 0{
            var ref: DatabaseReference!
            ref = Database.database().reference()
            ref.child("quiz/\(current.quiz)/players/\(current.name)/ready").setValue(false)
        }
        if hosting.count != 0{
            var ref: DatabaseReference!
            ref = Database.database().reference()
            ref.child("quiz/\(hosting)/active").setValue(false)
        }
    }
    
    func reactive(){
        if current.quiz.count > 0 && current.name.count > 0{
            var ref: DatabaseReference!
            ref = Database.database().reference()
            ref.child("quiz/\(current.quiz)/players/\(current.name)/ready").setValue(true)
        }
        if hosting.count != 0{
            var ref: DatabaseReference!
            ref = Database.database().reference()
            ref.child("quiz/\(hosting)/active").setValue(true)
        }
    }
    
    func observe(_ path: String, question: Question){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child(path).observe(.value, with: {(snapshot) in
            let b = snapshot.value as? Bool
            if b != nil{
                question.ready = b!
            }
        })
    }
    
    func record(_ url: String){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("test").setValue(url)
    }
    
    func observe(_ path: String, round: Round){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child(path).observe(.value, with: {(snapshot) in
            let b = snapshot.value as? Bool
            if b != nil{
                if b!{
                    round.reset()
                }
            }
        })
    }
    
    @objc func hostLeftQuiz(_ sender: UIButton){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("quiz/\(sender.accessibilityLabel!)/reset").setValue(true)
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: { _ in
            ref.child("quiz/\(sender.accessibilityLabel!)/reset").setValue(false)
        })
        ref.child("quiz/\(sender.accessibilityLabel!)/questions").observeSingleEvent(of: .value, with: {(snapshot) in
            let questions = snapshot.children.allObjects as! [DataSnapshot]
            for question in questions{
                ref.child("quiz/\(sender.accessibilityLabel!)/questions/\(question.key)/go").setValue(false)
            }
        })
    }
    
    func upload(title: String, password: String, questions: [Question], view: UIView) {
        var code = "".random()
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("quiz").observeSingleEvent(of: .value, with: {(snapshot) in
            var codes = [String]()
            for c in snapshot.children.allObjects as! [DataSnapshot]{
                codes.append(c.key)
            }
            while codes.contains(code){
                code = code.random()
            }
            ref.child("quiz/\(code)/active").setValue(false)
            ref.child("quiz/\(code)/title").setValue(title)
            ref.child("quiz/\(code)/password").setValue(password.encrypt())
            ref.child("quiz/\(code)/author").setValue(Settings.shared.defaults.value(forKey: "id"))
            var i = 1
            for question in questions{
                ref.child("quiz/\(code)/questions/\(i)/go").setValue(false)
                ref.child("quiz/\(code)/questions/\(i)/reset").setValue(false)
                ref.child("quiz/\(code)/questions/\(i)/question").setValue(question.title)
                ref.child("quiz/\(code)/questions/\(i)/time").setValue(Int(question.interval))
                var j = 1
                for answer in question.ans(){
                    if answer.name.count > 0{
                        ref.child("quiz/\(code)/questions/\(i)/answers/\(j)").setValue(answer.name)
                        j += 1
                    }
                }
                i += 1
            }
            view.removeAll()
            view.addSubview(QuizConfirmed(code: code, password: password))
        })
    }
    
    func newUser(){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("users").observeSingleEvent(of: .value, with: {(snapshot) in
            let id = (snapshot.children.allObjects as! [DataSnapshot]).count + 1
            Settings.shared.defaults.setValue(id, forKey: "id")
            ref.child("users/\(id)/flagged").setValue(false)
            self.blockList()
        })
    }
    
    func reportUser(_ user: String, leaderboard: Leaderboard){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("users/\(user)/flagged").setValue(true)
    }
    
    func blockUser(_ user: String, leaderboard: Leaderboard){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let id = Settings.shared.defaults.value(forKey: "id") as! Int
        ref.child("users/\(id)").observeSingleEvent(of: .value, with: {(snapshot) in
            if let blocked = snapshot.childSnapshot(forPath: "blocked").value as? String{
                ref.child("users/\(id)/blocked").setValue("\(blocked),\(user)")
                ref.child("users/\(user)/flagged").setValue(true)
            }
            else{
                ref.child("users/\(id)/blocked").setValue("\(user)")
                ref.child("users/\(user)/flagged").setValue(true)
            }
            self.blockList()
            leaderboard.update(self.removeUser(Int(user)!, leaderboard.scores))
            leaderboard.addSubview(leaderboard.button)
        })
    }
    
    func blockList(){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("user/\(Settings.shared.defaults.value(forKey: "id") as! Int)/blocked").observe(.value, with: {(snapshot) in
            var list = [Int]()
            let csv = snapshot.value as? String
            if csv != nil{
                let all = csv!.split(separator: ",")
                for user in all{
                    list.append(Int(user)!)
                }
            }
            Settings.shared.defaults.set(list, forKey: "blocked")
        })
    }
    
    func quizFinished(){
        current.quiz = ""
        current.name = ""
    }
    
}

struct user{
    var name: String
    var id: Int
    var score: Int
}

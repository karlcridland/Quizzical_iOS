//
//  ViewController.swift
//  quiz master
//
//  Created by Karl Cridland on 29/04/2020.
//  Copyright © 2020 Karl Cridland. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController, GADInterstitialDelegate {

    let homescreen = HomeScreen()
    var bannerView: GADBannerView!
    var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBlue
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: { _ in
            self.home()
            self.view.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        })
        if Settings.shared.defaults.value(forKey: "id") != nil{
            Firebase.shared.blockList()
        }
        view.addSubview(Background(frame: view.frame))
        
        view.tag = 69
        view.accessibilityElements = [self]
        
        let block = UIView(frame: view.frame)
        view.addSubview(block)
//        Settings.shared.defaults.set(nil, forKey: "terms")
        if (Settings.shared.defaults.value(forKey: "terms")) == nil{
            var i = 0
            Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { timer in
                if i == 10{
                    timer.invalidate()
                }
                self.view.bringSubviewToFront(block)
                i += 1
            })
            let terms = Terms(frame: CGRect(x: 20, y: 150, width: view.frame.width-40, height: view.frame.height-250))
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
                self.view.addSubview(terms)
                block.removeFromSuperview()
            })
        }

        interstitial = GADInterstitial(adUnitID: "ca-app-pub-0389206817632911/9959122322")
        let request = GADRequest()
        interstitial.load(request)
        interstitial.delegate = self
        
    }

    func createAndLoadInterstitial() -> GADInterstitial {
      let new = GADInterstitial(adUnitID: "ca-app-pub-0389206817632911/9959122322")
      new.delegate = self
      new.load(GADRequest())
      return new
    }
    
    func interst(){
        if interstitial.isReady {
            view.removeAll()
            view.addSubview(HomeScreen())
            interstitial.present(fromRootViewController: self)
        }
    }
    
    func adjustAd(_ view: UIView){
        view.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height-view.frame.height/2 - 25)
    }
    
    func home(){
        view.addSubview(homescreen)
    }
    
    /// Tells the delegate an ad request succeeded.
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
      print("interstitialDidReceiveAd")
    }

    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
      print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    /// Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
      print("interstitialWillPresentScreen")
    }

    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
      print("interstitialWillDismissScreen")
    }

    /// Tells the delegate the interstitial had been animated off the screen.
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
    }

    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
      print("interstitialWillLeaveApplication")
    }

}

//0x7fa1f52179a0

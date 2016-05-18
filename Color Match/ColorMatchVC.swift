//
//  ColorMatchVC.swift
//  
//
//  Created by Henry Goodwin on 14/05/2016.
//
//

import UIKit
import Spring
import iAd

class ColorMatchVC: UIViewController, ADBannerViewDelegate, ADInterstitialAdDelegate {
    var interAd = ADInterstitialAd()
    var interAdView: UIView = UIView()
    var closeButton = UIButton(type: UIButtonType.System) as UIButton
    
    @IBOutlet var stack: UIStackView!
    @IBOutlet weak var colorView: SpringView!
    
    @IBOutlet var btn1: Button!
    @IBOutlet weak var btn2: Button!
    @IBOutlet weak var btn3: Button!
    @IBOutlet weak var btn4: Button!
    @IBOutlet var adBannerView: ADBannerView?
    
    @IBOutlet weak var l1: UIButton!
    @IBOutlet weak var scoreLBL: UILabel!
    
    var monsterHappy = false
    var score = 0
    var bounciness: CGFloat = 8.0
    
    var previousNumber: UInt32?
    
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    
    var penaltys = 0
    
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    
    var viewColor: String!
    
    var timer: NSTimer!
    
    var highscore = 0
    var rep = 0
    
    @IBOutlet weak var highscoreLbl: UILabel!
    @IBOutlet weak var scoreLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rep = 0
        
        self.canDisplayBannerAds = true
        self.adBannerView?.delegate = self
        self.adBannerView?.hidden = true
        
        scoreLBL.text = "\(score)"
        
        scoreLBL.adjustsFontSizeToFitWidth = true
        
        colorView.layer.cornerRadius = 20
        colorView.clipsToBounds = true
        
        colorView.backgroundColor = UIColor.Orange()
        
        btn1.color = viewColor
        btn2.color = viewColor
        btn3.color = viewColor
        btn4.color = viewColor
        
        stack.hidden = true
        scoreLbl.hidden = true
        
        closeButton.frame = CGRectMake(20, 80, 25, 25)
        closeButton.layer.cornerRadius = closeButton.frame.size.width/2
        closeButton.layer.masksToBounds = true
        closeButton.setTitle("x", forState: .Normal)
        closeButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        closeButton.backgroundColor = UIColor.whiteColor()
        closeButton.layer.borderColor = UIColor.blackColor().CGColor
        closeButton.layer.borderWidth = 1
        closeButton.addTarget(self, action: #selector(ColorMatchVC.close(_:)), forControlEvents: UIControlEvents.TouchDown)

        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ColorMatchVC.correctTapped), name: "CorrectPressed", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ColorMatchVC.wrongTapped), name: "WrongPressed", object: nil)
        
        let highscoreDefults = NSUserDefaults.standardUserDefaults()
        
        if (highscoreDefults.valueForKey("Highscore") != nil) {
            
            highscore = highscoreDefults.valueForKey("Highscore") as! NSInteger
            highscoreLbl.text = "Highscore: \(highscore)"
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func close(sender: UIButton) {
        closeButton.removeFromSuperview()
        interAdView.removeFromSuperview()
        adBannerView?.hidden = false
        rep = 0
    }
    
    func loadAd() {
         NSLog("interstitialAdbannerViewWillLoadAd")
        interAd = ADInterstitialAd()
        interAd.delegate = self
    }
    
    func interstitialAdDidLoad(interstitialAd: ADInterstitialAd!) {
        NSLog("interstitialAdViewDidLoadAd")
        
        interAdView = UIView()
        interAdView.frame = self.view.bounds
        view.addSubview(interAdView)
        
        interAd.presentInView(interAdView)
        UIViewController.prepareInterstitialAds()
        
        interAdView.addSubview(closeButton)
        
        
    }
    
    func interstitialAdDidUnload(interstitialAd: ADInterstitialAd!) {
        
    }
    
    func interstitialAd(interstitialAd: ADInterstitialAd!, didFailWithError error: NSError!) {
        NSLog("interstitialAd")
        print(error.localizedDescription)
        
        closeButton.removeFromSuperview()
        interAdView.removeFromSuperview()
        
    }
    
    @IBAction func startL1(sender:UIButton) {
        
        correct()
        stack.hidden = false
        l1.hidden = true
        highscoreLbl.hidden = true
        scoreLbl.hidden = true
        
        penaltys = 0
        score = 0
        scoreLBL.text = "\(score)"
        
        
    }
    
    @IBAction func alertBtn(sender: UIButton) {
        
        let alertView = UIAlertController(title: "Color Match", message: "Match the Color of the View to the Text", preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alertView, animated: true, completion: nil)
        
    }
    
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func bannerViewWillLoadAd(banner: ADBannerView!) {
        NSLog("bannerViewWillLoadAd")
    }
    
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        NSLog("bannerViewDidLoadAd")
        self.adBannerView?.hidden = false //now show banner as ad is loaded
    }
    
    
    func bannerViewActionDidFinish(banner: ADBannerView!) {
        NSLog("bannerViewDidLoadAd")
        
    }
    
    
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        NSLog("bannerViewActionShouldBegin")
        
        return true
    }
    
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        NSLog("bannerView")
    }
    
    
    func correctTapped() {
        
        print("Right")
        pop()
        correct()
        score = score + 1
        scoreLBL.text = "\(score)"
    }
    
    
    func wrongTapped() {
        
        print("Wrong")
        monsterHappy = false
        shake()
        startTimer()
        changeGameState()
        
        
    }
    
    func correct() {
        
        monsterHappy = true
        startTimer()
        changeGameState()
        
    }
    
    func shake() {
        
        colorView.animation = "swing"
        colorView.curve = "easeInOut"
        colorView.duration = 0.5
        colorView.force = 0.3
        colorView.animate()
        
    }
    
    func pop() {
        
        colorView.animation = "pop"
        colorView.curve = "easeInOut"
        colorView.duration = 0.5
        colorView.force = 0.2
        colorView.animate()
        
    }
    
    func startTimer() {
        
        if timer != nil {
            
            timer.invalidate()
        }
        
        if score <= 15 {
            
            timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(ColorMatchVC.changeGameState), userInfo: nil, repeats: true)
            
            print("3.0")
            
        } else if score <= 30 {
            
            timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: #selector(ColorMatchVC.changeGameState), userInfo: nil, repeats: true)
            
            print("2.0")
            
        } else if score <= 50  {
            
            timer = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: #selector(ColorMatchVC.changeGameState), userInfo: nil, repeats: true)
            
            print("1.5")
            
        } else {
            
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ColorMatchVC.changeGameState), userInfo: nil, repeats: true)
            
            print("1")
            
            
        }
        
    }
    
    func monsterUH() {
        
        penaltys = penaltys + 1
        
        monsterH()
        
        if penaltys == 0 {
            
            img1.alpha = OPAQUE
            img2.alpha = OPAQUE
            img3.alpha = OPAQUE
            
            
        } else if penaltys == 1 {
            img1.alpha = DIM_ALPHA
            img2.alpha = OPAQUE
            img3.alpha = OPAQUE
            
        } else if penaltys == 2 {
            img1.alpha = DIM_ALPHA
            img2.alpha = DIM_ALPHA
            img3.alpha = OPAQUE
            
        } else if penaltys >= 3 {
            img1.alpha = DIM_ALPHA
            img2.alpha = DIM_ALPHA
            img3.alpha = DIM_ALPHA
            gameOver()
            
        }
        
    }
    
    
    func monsterH() {
        
        var randomNumber = arc4random_uniform(4)
        while previousNumber == randomNumber {
            randomNumber = arc4random_uniform(4)
        }
        previousNumber = randomNumber
        
        // 0 or 1
        
        if randomNumber == 0 {
            
            colorView.backgroundColor = UIColor.Blue()
            viewColor = "Blue"
            
        } else if randomNumber == 1 {
            
            colorView.backgroundColor = UIColor.Orange()
            viewColor = "Orange"
            
            
        } else if randomNumber == 2 {
            
            colorView.backgroundColor = UIColor.Green()
            viewColor = "Green"
            
        } else {
            
            colorView.backgroundColor = UIColor.Red()
            viewColor = "Red"
            
        }
        
        btn1.color = viewColor
        btn2.color = viewColor
        btn3.color = viewColor
        btn4.color = viewColor
        
        monsterHappy = false
        
        
        
    }
    
    
    func changeGameState() {
        
        if !monsterHappy {
            
            monsterUH()
            
        } else {
            
            monsterH()
            
        }
        
    }
    
    func gameOver() {
        
        timer.invalidate()
        if rep != 3 {
            rep = rep + 1
        }
        
        stack.hidden = true
        l1.hidden = false
        img1.alpha = OPAQUE
        img2.alpha = OPAQUE
        img3.alpha = OPAQUE
        
        scoreLbl.hidden = false
        highscoreLbl.hidden = false
        
        print(rep)
        if rep == 3 {
            adBannerView?.hidden = true
            loadAd()
            rep = 0
        }

        scoreLbl.text = "Score: \(score)"
        
        if (score > highscore) {
            
            highscore = score
            highscoreLbl.text = "Highscore: \(highscore)"
            
            let highscoreDefults = NSUserDefaults.standardUserDefaults()
            highscoreDefults.setValue(highscore, forKey: "Highscore")
            highscoreDefults.synchronize()
        }
    }
}
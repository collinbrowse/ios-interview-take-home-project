//
//  ViewController.swift
//  Cognition Bootcamp
//
//  Created by Greg DeJong on 10/8/20.
//

import UIKit
import Firebase



class ViewController: UIViewController {

    private var tapCount: Int = 0
    private var tapCountGoal: Int = 3
    private var startDate: Date?
    private var endDate: Date?
    private var timeInterval: TimeInterval?
    private var reactionTime: Double?
    private var startTime: CFAbsoluteTime?
    private var endTime: CFAbsoluteTime?
    private var timer: Timer?
    private var stopwatchTime: Double = 0
    
    @IBOutlet var tapButton: UIButton!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var ringOneImageView: UIImageView!
    @IBOutlet var ringTwoImageView: UIImageView!
    @IBOutlet var ringThreeImageView: UIImageView!
    @IBOutlet var ringFourImageView: UIImageView!
    @IBOutlet var timeLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapButton.isEnabled = false
        startButton.isHidden = false
        timeLabel.isHidden = true
        startAnimatingRings()
    }
    
    
    override func viewDidLayoutSubviews() {
        setUpStartButton()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToCompletionModal" {
            let vc = segue.destination as? CompletionModalViewController
            vc?.totalTime = timeInterval
            vc?.reactionTime = reactionTime
        }
    }
    
    
    @IBAction func tryAgain(_ unwindSegue: UIStoryboardSegue) {
        tapCount = 0
        tapButton.isEnabled = false
        startButton.isHidden = false
        timeLabel.isHidden = true
        stopwatchTime = 0
    }
    
    
    @IBAction func didTapStartButton(_ sender: Any) {
        tapButton.isEnabled = true
        startButton.isHidden = true
        timeLabel.isHidden = false
        startTimer()
    }
    
    
    @IBAction func didTouchTapButton(_ sender: Any) {
        //CFAbsoluteTimeGetCurrent()
        tapCount = tapCount + 1
        if tapCount >= tapCountGoal {
            endTime = CFAbsoluteTimeGetCurrent()
            tapButton.isEnabled = false
            calculateTestStatistics()
            updateTimeLabelToSubmittedTime()
            presentModalScreen()
            timer?.invalidate()
            timer = nil
        }
    }
    
    
    @objc func updateTimer() {
        stopwatchTime = stopwatchTime + Double(0.0001)
        let mainString = String(format: "%.3f", stopwatchTime) + "s"
        timeLabel.attributedText = mainString.formatTimeLabel(time: stopwatchTime, isAltColorDark: false)
    }
    
    
    
    private func startTimer() {
        startTime = CFAbsoluteTimeGetCurrent()
        timer = Timer.scheduledTimer(timeInterval: 0.0001, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    
    private func calculateTestStatistics() {
        if let startTime = startTime, let endTime = endTime {
            timeInterval = endTime - startTime
            reactionTime = timeInterval! / Double(tapCountGoal)
        }
    }
    
    
    private func updateTimeLabelToSubmittedTime() {
        if timeInterval != nil {
            let s = String(format: "%.3f", timeInterval!) + "s"
            timeLabel.attributedText = s.formatTimeLabel(time: timeInterval!, isAltColorDark: false)
        }
    }
    
    
    private func presentModalScreen() {
        let when = DispatchTime.now() + 0.3
        DispatchQueue.main.asyncAfter(deadline: when) {            
            self.performSegue(withIdentifier: "goToCompletionModal", sender: self)
        }
    }
    
    
    private func setUpStartButton() {
        startButton.addVLCornerRadius()
        startButton.addGoldGradientBackground()
        startButton.bringSubviewToFront(startButton.imageView!) // Bring the button image to the front
    }
    
    
    private func startAnimatingRings() {
        let ringOneAnimation = CABasicAnimation(keyPath: "transform.rotation")
        ringOneAnimation.fromValue = 0
        ringOneAnimation.toValue =  Double.pi * 2.0
        ringOneAnimation.duration = 4
        ringOneAnimation.repeatCount = .infinity
        ringOneAnimation.isRemovedOnCompletion = false
        ringOneImageView.layer.add(ringOneAnimation, forKey: "spin")
        
        let ringTwoAnimation = CABasicAnimation(keyPath: "transform.rotation")
        ringTwoAnimation.fromValue = Double.pi * 2.0
        ringTwoAnimation.toValue =  0
        ringTwoAnimation.duration = 8
        ringTwoAnimation.repeatCount = .infinity
        ringTwoAnimation.isRemovedOnCompletion = false
        ringTwoImageView.layer.add(ringTwoAnimation, forKey: "spin")
        
        let ringThreeAnimation = CABasicAnimation(keyPath: "transform.rotation")
        ringThreeAnimation.fromValue = 0
        ringThreeAnimation.toValue =  Double.pi * 2.0
        ringThreeAnimation.duration = 8
        ringThreeAnimation.repeatCount = .infinity
        ringThreeAnimation.isRemovedOnCompletion = false
        ringThreeImageView.layer.add(ringThreeAnimation, forKey: "spin")
        
        let ringFourAnimation = CABasicAnimation(keyPath: "transform.rotation")
        ringFourAnimation.fromValue = 0
        ringFourAnimation.toValue =  Double.pi * 2.0
        ringFourAnimation.duration = 8
        ringFourAnimation.repeatCount = .infinity
        ringFourAnimation.isRemovedOnCompletion = false
        ringFourImageView.layer.add(ringFourAnimation, forKey: "spin")
    }
}


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
    private var tapCountGoal: Int = 30
    private var stopwatchTime: Double = 0
    private var startDate: Date?
    private var endDate: Date?
    private var totalTime: TimeInterval?
    private var reactionTime: Double?
    private var startTime: CFAbsoluteTime?
    private var endTime: CFAbsoluteTime?
    private var timer: Timer?
    
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
        // Set up the buttons AFTER viewDidLoad so the background gradient can be properly set
        setUpStartButton()
    }
    
    
    /// Prepare for the segue "goToCompletionModal
    /// Inject the totalTime and reactionTime of the user's score
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToCompletionModal" {
            let vc = segue.destination as? CompletionModalViewController
            vc?.totalTime = totalTime
            vc?.reactionTime = reactionTime
        }
    }
    
    
    /// Responds to the user tapping Try Again or Quit from LeaderboardViewController
    /// Resets the tapButton, startButton, timeLabel, stopwatchTime and tapCount to their original state
    /// Starts animating the 4 rings
    ///
    /// - parameters: The Unwind Segue
    @IBAction func tryAgain(_ unwindSegue: UIStoryboardSegue) {
        tapButton.isEnabled = false
        startButton.isHidden = false
        timeLabel.isHidden = true
        stopwatchTime = 0
        tapCount = 0
        startAnimatingRings()
    }
    
    
    /// Did Touch Up Inside on the Start Button
    /// Enable the tap button
    /// Swap the StartButton with the TimeLabel
    @IBAction func didTapStartButton(_ sender: Any) {
        tapButton.isEnabled = true
        startButton.isHidden = true
        timeLabel.isHidden = false
        startTimer()
    }
    
    
    
    /// Did Touch Down on the Tap Button
    /// Once the tapCountGoal is met:
    /// Record the absolute time and calculate the users totalTime
    /// Stop animating rings
    /// Invalidate the time
    /// Present the Modal Screen
    @IBAction func didTouchTapButton(_ sender: Any) {
        
        tapCount = tapCount + 1
        if tapCount >= tapCountGoal {
            endTime = CFAbsoluteTimeGetCurrent()
            tapButton.isEnabled = false
            calculateTestStatistics()
            updateTimeLabelToSubmittedTime()
            presentModalScreen()
            stopAnimatingRings()
            timer?.invalidate()
            timer = nil
        }
    }
    
    
    /// Respond to updates from Timer
    /// Increment the time by 0.0001
    @objc func updateTimer() {
        guard let startTime = startTime else { return }
        stopwatchTime = CFAbsoluteTimeGetCurrent() - startTime
        //stopwatchTime = stopwatchTime + Double(0.2)
        let mainString = String(format: "%.3f", stopwatchTime) + "s"
        timeLabel.attributedText = mainString.formatTimeLabel(time: stopwatchTime, isAltColorDark: false)
    }
    
    
    /// Record the absolute time when the user starts
    /// Create a timer object and start listening for updates at updateTime
    private func startTimer() {
        startTime = CFAbsoluteTimeGetCurrent()
        timer = Timer.scheduledTimer(timeInterval: 0.013, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    
    /// Perform the calculation for the user's totalTime and reactionTime
    private func calculateTestStatistics() {
        if let startTime = startTime, let endTime = endTime {
            totalTime = endTime - startTime
            reactionTime = totalTime! / Double(tapCountGoal)
        }
    }
    
    
    /// Display the users totalTime. This function swaps the displayed time from the Timer with the calculated totalTime
    private func updateTimeLabelToSubmittedTime() {
        if totalTime != nil {
            let s = String(format: "%.3f", totalTime!) + "s"
            timeLabel.attributedText = s.formatTimeLabel(time: totalTime!, isAltColorDark: false)
        }
    }
    
    
    /// Display the modal screen with a slight delay
    private func presentModalScreen() {
        let when = DispatchTime.now() + 0.15
        DispatchQueue.main.asyncAfter(deadline: when) {            
            self.performSegue(withIdentifier: "goToCompletionModal", sender: self)
        }
    }
    
    
    /// Perform initials set up for the Start Button
    /// Add corner radius and gradient background
    private func setUpStartButton() {
        startButton.addVLCornerRadius()
        startButton.addGoldGradientBackground()
        startButton.bringSubviewToFront(startButton.imageView!) // Bring the button image to the front
    }
    
    
    /// Start animating the four rings using CABasicAnimation
    /// Adds the AnimationLayer to the imageViews
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
    
    
    /// Removes the animation layer from the Image View
    private func stopAnimatingRings() {
        ringOneImageView.layer.removeAllAnimations()
        ringTwoImageView.layer.removeAllAnimations()
        ringThreeImageView.layer.removeAllAnimations()
        ringFourImageView.layer.removeAllAnimations()
    }
}


//
//  CompletionModalViewController.swift
//  Cognition Bootcamp
//
//  Created by Collin Browse on 11/9/21.
//

import UIKit

class CompletionModalViewController: UIViewController {
    
    var totalTime: Double?
    var reactionTime: Double?
    private var initials: String?
    private let dashedLineLayer = CAShapeLayer()
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var dashedLineView: UIView!
    @IBOutlet var informationLabel: UILabel!
    @IBOutlet var initalsTextField: UITextField!
    @IBOutlet var saveButton: UIButton!
    
    
    override func viewDidLoad() {
        backgroundView.layer.cornerRadius = 10
        setUpTimeLabel()
        setUpDashedLine()
        setUpInitialsTextField()
    }
    

    override func viewDidLayoutSubviews() {
        // Set up the buttons AFTER viewDidLoad so the background gradient can be properly set
        setUpSaveButton()
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        // Force the dotted line to update color when switching between light/dark mode
        dashedLineLayer.strokeColor = UIColor.background1.cgColor
        dashedLineLayer.display()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToLeaderboard" {
            // Send across the necessary data for a new score
            guard let initials = initials, let time = totalTime, let reaction = reactionTime else {
                fatalError("Some How the initials and time are not set")
            }
            
            let vc = segue.destination as! LeaderboardViewController
            let newScore = UserScore(initials: initials, totalTime: time, createdAt: Date(), reactionTime: reaction)
            vc.addNewScore(newScore.dictionary)
        }
    }
    

    /// IBAction: Editing Changed
    /// Records the current textField.text as initials
    ///
    /// - parameters:The UITextField
    @IBAction func initialsTextFieldChanged(_ sender: UITextField) {
        initials = sender.text
        
        // Not Working and not enough time to figure out why.
        // The IBAction below works correctly
        if let initials = initials, initials.count > 1 {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false 
        }
    }
    
    
    /// IBAction: Did End On Exit
    /// Records the current textField.text as initials
    /// Enables the save button if more than 1 character was entered
    /// Resigns the Text Field as first responder
    ///
    /// - parameters: The UITextField
    @IBAction func initialsSubmitted(_ sender: UITextField) {
        initials = sender.text
        if let initials = initials, initials.count > 1 {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
        initalsTextField.resignFirstResponder()
    }
    
    
    /// IBAction: didTouchUpInside
    /// Performs the segue "goToLeaderboard"
    ///
    /// - parameters: the UIButton
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToLeaderboard", sender: self)
    }
    
    
    /// Set the text of the time label with formatted colors. Uses timeLabel.attributedText
    func setUpTimeLabel() {
        guard let time = totalTime?.roundedUp() else { return }
        let s = String(format: "%.3f", time) + "s"
        timeLabel.attributedText = s.formatTimeLabel(time: time, isAltColorDark: true)
    }
        
    
    /// Format the UIView as a DashedLine
    private func setUpDashedLine() {
        
        dashedLineLayer.strokeColor = UIColor.background1.cgColor
        dashedLineLayer.lineWidth = 2
        dashedLineLayer.lineDashPattern = [3, 4]
        let start = CGPoint(x: dashedLineView.bounds.minX, y: dashedLineView.bounds.minY)
        let end = CGPoint(x: dashedLineView.bounds.maxX, y: dashedLineView.bounds.minY)
        let path = CGMutablePath()
        path.addLines(between: [start, end])
        dashedLineLayer.path = path
        dashedLineLayer.display()
        dashedLineView.layer.addSublayer(dashedLineLayer)
    }
    
    
    /// Set the delegate for initialsTextField
    private func setUpInitialsTextField() {
        initalsTextField.delegate = self
    }
    
    
    /// Perform save button set up for view did load
    /// Disable the save button to start
    /// Add gradient and corner radius
    private func setUpSaveButton() {
        saveButton.isEnabled = false
        saveButton.addVLCornerRadius()
        saveButton.addGoldGradientBackground()
    }
}


/// Extension to add UITextFieldDelegate methods
extension CompletionModalViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Only allow a character to be entered if:
        // Length < 3 && it is a character in the alphabet (A-Za-z)
        let maxLength = 3
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string) as NSString
        
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z].*", options: [])
            if regex.firstMatch(in: string, options: [], range: NSMakeRange(0, string.count)) != nil {
                return false
            }
        }
        catch {
            print("ERROR parsing regex")
        }
        
        return newString.length <= maxLength
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        true
    }
}

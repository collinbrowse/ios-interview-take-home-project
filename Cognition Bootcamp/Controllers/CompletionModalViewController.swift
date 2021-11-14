//
//  CompletionModalViewController.swift
//  Cognition Bootcamp
//
//  Created by Collin Browse on 11/9/21.
//

import UIKit


class CompletionModalViewController: UIViewController {
    
    var initials: String?
    var totalTime: Double?
    var createdAt: Date?
    var reactionTime: Double?
    let dashedLineLayer = CAShapeLayer()
    
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
        setUpSaveButton()
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        // Force the Line to update color when switching between light/dark mode
        dashedLineLayer.strokeColor = UIColor.background1.cgColor
        dashedLineLayer.display()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToLeaderboard" {
            
            guard let initials = initials, let time = totalTime, let reaction = reactionTime else {
                fatalError("Some How the initials and time are not set")
            }
            
            let vc = segue.destination as! LeaderboardViewController
            let newScore = UserScore(initials: initials, totalTime: time, createdAt: Date(), reactionTime: reaction)
            vc.addNewScore(newScore.dictionary)
        }
    }
    

    @IBAction func initialsTextFieldChanged(_ sender: UITextField) {
        initials = sender.text
    }
    
    
    // Did End On Exit
    @IBAction func initialsSubmitted(_ sender: UITextField) {
        
        if let initials = initials, !initials.isEmpty {
            saveButton.isEnabled = true
        }
        
        initalsTextField.resignFirstResponder()
    }
    
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToLeaderboard", sender: self)
    }
    
    

    func setUpTimeLabel() {
        guard let time = totalTime?.roundedUp() else { return }
        let s = String(format: "%.3f", time) + "s"
        timeLabel.attributedText = s.formatTimeLabel(time: time, isAltColorDark: true)
    }
        
    
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
    
    
    private func setUpInitialsTextField() {
        initalsTextField.delegate = self
    }
    
    
    private func setUpSaveButton() {
        saveButton.isEnabled = false
        saveButton.addVLCornerRadius()
        saveButton.addGoldGradientBackground()
    }
}


extension CompletionModalViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 3
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        true
    }
}

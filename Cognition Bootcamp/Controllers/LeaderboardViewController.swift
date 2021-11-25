//
//  LeaderboardViewController.swift
//  Cognition Bootcamp
//
//  Created by Collin Browse on 11/10/21.
//

import UIKit
import Firebase
import FirebaseFirestore

class LeaderboardViewController: UIViewController {
    
    private var leaderboard: [UserScore] = []
    private var newestScoreCreatedAt: Date?
    private let dateFormatter = DateFormatter()
    
    @IBOutlet var iconsView: UIView!
    @IBOutlet var podiumIcon: UIImageView!
    @IBOutlet var usersIcon: UIImageView!
    @IBOutlet var timeIcon: UIImageView!
    @IBOutlet var leaderboardTableView: UITableView!
    @IBOutlet var quitButton: UIButton!
    @IBOutlet var tryAgainButton: UIButton!
    
    
    override func viewDidLoad() {
        leaderboardTableView.dataSource = self
        leaderboardTableView.delegate = self
        dateFormatter.dateFormat = "YY, MMM d, HH:mm:ss"
        setUpIcons()
        currentLeaderboard()
    }
    
    
    override func viewDidLayoutSubviews() {
        // Set up the buttons AFTER viewDidLoad so the background gradient can be properly set
        setUpButtons()
    }

    
    /// Calls the Network Manager to add a new score in Firestore. If successful, sets the instance variable
    ///  newestScoreCreatedAt with the Date object of the newest created score
    ///
    /// - Parameters: newScore: [String: Any]
    ///     - A dictionary that contains the information for a new score. The keys should be: initials, createdAt, totalTime, reactionTime
    public func addNewScore(_ newScore: [String : Any]) {
        NetworkManager.shared.addNewScore(newScore) { [weak self] didAddNewScore in
            guard let self = self else { return }
            if didAddNewScore {
                self.newestScoreCreatedAt = newScore["createdAt"] as? Date
            }
        }
    }
    
    
    /// Gets the Current Leaderboard
    /// If a completion handler returns, set the instance variable leaderboard.
    /// Then reload the tableview with the new data
    private func currentLeaderboard() {
        NetworkManager.shared.getCurrentLeaderboard { [weak self] leaderboard in
            guard let self = self else { return }
            self.leaderboard = leaderboard
            DispatchQueue.main.async {
                self.leaderboardTableView.reloadData()
            }
        }
    }
    
    
    /// Set the images for accessory icons
    private func setUpIcons() {
        podiumIcon.setImageColor(color: UIColor.systemGray)
        usersIcon.setImageColor(color: UIColor.systemGray)
        timeIcon.setImageColor(color: UIColor.systemGray)
    }
    
    
    /// Add Corner Radius, Background and Border to IB Buttons: tryAgainButton, quitButton
    private func setUpButtons() {
        tryAgainButton.addVLCornerRadius()
        tryAgainButton.addGoldGradientBackground()
        quitButton.addVLCornerRadius()
        quitButton.layer.borderColor = UIColor.gold.cgColor
        quitButton.layer.borderWidth = 1
    }
}


/// An extension to handle UITableViewDataSource and UITableViewDelegate methods
extension LeaderboardViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Only ever show the top 10 on the leaderboard
        return 10
    }


    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Set a headerView to add spacing between cells
        let headerView = UIView()
        return headerView
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Each cell gets the positionLabel, initialsLabel, timeLabel, label colors, backgroundColor and border set
        let cell = leaderboardTableView.dequeueReusableCell(withIdentifier: LeaderboardTableViewCell.reuseID) as! LeaderboardTableViewCell
        cell.layer.borderColor = nil
        cell.backgroundColor = nil
        cell.frame.size.height += 1
        cell.clipsToBounds = true
        if indexPath.section >= leaderboard.count {
            cell.positionLabel.text = "\(indexPath.section + 1)"
            cell.initialsLabel.text = "---"
            cell.timeLabel.text = "---"
            cell.backgroundColor = .clear
            if traitCollection.userInterfaceStyle == .light {
                cell.layer.borderColor = UIColor.background2.cgColor
            } else {
                cell.layer.borderColor = UIColor.silver.cgColor
            }
            cell.layer.borderWidth = 2
        } else {
            cell.positionLabel.text = "\(indexPath.section + 1)"
            cell.initialsLabel.text = leaderboard[indexPath.section].initials
            cell.timeLabel.text = "\(leaderboard[indexPath.section].totalTime.roundedUp())s"
            
            let newDate = self.dateFormatter.string(from: self.newestScoreCreatedAt ?? Date())
            let leaderboardDate = self.dateFormatter.string(from: leaderboard[indexPath.section].createdAt)
            if newDate == leaderboardDate {
                cell.backgroundColor = UIColor(named: "Background1Flipped")
                cell.timeLabel.textColor = UIColor.background1
                cell.initialsLabel.textColor = UIColor.background1
                cell.layer.borderWidth = 2
            } else {
                cell.backgroundColor = .background2
                cell.layer.borderWidth = 0
                cell.timeLabel.textColor = UIColor(named: "Background1Flipped")
                cell.initialsLabel.textColor = UIColor(named: "Background1Flipped")
            }
        }
        
        return cell
    }
}

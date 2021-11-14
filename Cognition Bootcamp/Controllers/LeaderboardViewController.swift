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
    
    var leaderboard: [UserScore] = []
    var cellSpacing: CGFloat = 20.0
    var newestScoreCreatedAt: Date?
    let dateFormatter = DateFormatter()
    
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
        setUpButtons()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }

    
    public func addNewScore(_ newScore: [String : Any]) {
        NetworkManager.shared.addNewScore(newScore) { [weak self] didAddNewScore in
            guard let self = self else { return }
            if didAddNewScore {
                self.newestScoreCreatedAt = newScore["createdAt"] as? Date
            }
        }
    }
    
    
    private func currentLeaderboard() {
        NetworkManager.shared.getCurrentLeaderboard { [weak self] leaderboard in
            guard let self = self else { return }
            self.leaderboard = leaderboard
            DispatchQueue.main.async {
                self.leaderboardTableView.reloadData()
            }
        }
    }
    
    
    private func setUpIcons() {
        podiumIcon.setImageColor(color: UIColor.systemGray)
        usersIcon.setImageColor(color: UIColor.systemGray)
        timeIcon.setImageColor(color: UIColor.systemGray)
    }
    
    
    private func setUpButtons() {
        tryAgainButton.addVLCornerRadius()
        tryAgainButton.addGoldGradientBackground()
        quitButton.layer.borderColor = UIColor.gold.cgColor
        quitButton.layer.borderWidth = 1
        quitButton.addVLCornerRadius()
    }
}


extension LeaderboardViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }


    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerView = UIView()
        
        return headerView
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
            cell.layer.borderColor = UIColor.background2.cgColor
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
            } else {
                cell.backgroundColor = .background2
                cell.timeLabel.textColor = UIColor(named: "Background1Flipped")
                cell.initialsLabel.textColor = UIColor(named: "Background1Flipped")
            }
        }
        
        return cell
    }
}

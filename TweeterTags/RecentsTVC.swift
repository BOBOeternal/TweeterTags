//
//  RecentsTVC.swift
//  TweeterTags
//
//  Created by Joy on 2022/12/3.
//

import UIKit

class RecentsTVC: UITableViewController {
    
    var recentArr:[String]? {
        return UserDefaults.standard.object(forKey: "recentSearches") as? [String]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reloadTVC()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.reloadTVC()
//        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTVC), name: NSNotification.Name.UIApplication.willEnterForegroundNotification, object: nil )
    }
    @objc func reloadTVC() {
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (recentArr != nil) {
            return recentArr!.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recentCell" , for: indexPath) //as! RecentCell
        cell.textLabel?.text = recentArr![indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recentToTweetTVC" {
            if let destination =  segue.destination as? TweetsTVC{
                if let cell =  sender as? UITableViewCell{
                    destination.twitterQueryText = (cell.textLabel?.text)!
                }
            }
        }
    }
}


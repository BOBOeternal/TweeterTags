//
//  TweetsTVC.swift
//  TweeterTags
//
//  Created by Joy on 2022/11/25.
//

import UIKit

class TweetsTVC: UITableViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var twitterQueryTextField: UITextField!{
        didSet {
            twitterQueryTextField.delegate = self
            twitterQueryTextField.text = twitterQueryText
        }
    }
    
    
    var tweets = [[TwitterTweet]]() { didSet{ self.tableView.reloadData() } }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        twitterQueryText = textField.text!
        twitterQueryTextField.resignFirstResponder()
        return true
    }
    
    var twitterQueryText : String = "#ucd"{
        didSet{
            let defaults = UserDefaults.standard
            var recentArr = [String]()
            if let tempArr = defaults.object(forKey: "recentSearches") as? [String] {
                recentArr = tempArr
                if recentArr.count >= 100 {
                    recentArr.removeLast()
                }
            }
            if(recentArr.last != twitterQueryText && twitterQueryText != "#ucd"){
                if (recentArr.contains(twitterQueryText)) {
                    if let index = recentArr.firstIndex(of: twitterQueryText) {
                        recentArr.remove(at: index)
                    }
                }
                recentArr.append(twitterQueryText)
            }
            defaults.set(recentArr, forKey: "recentSearches")
            twitterQueryTextField?.text = twitterQueryText
            tweets.removeAll()
            self.tableView.reloadData()
            refresh()
        }
    }
    
    
    private var twitterRequest: TwitterRequest?
    
    @objc private func refresh() {
        let request = TwitterRequest(search: twitterQueryText, count: 40)
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
            request.fetchTweets { (newTweets) -> Void in
                if newTweets.count > 0 {
                    self.twitterRequest = request
                    DispatchQueue.main.async { () -> Void in
                        self.tweets.insert(newTweets, at: 0)
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        refresh()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tweets.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweeterCell", for: indexPath) as! TweetTVCell
        cell.tweet = tweets[indexPath.section][indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tweetsToMentionsTVC"{
            if let destination =  segue.destination as? MentionsTVC{
                if let index = self.tableView.indexPathForSelectedRow{
                    destination.showTweet = tweets[index.section][index.row]
                }
            }
        }
    }
}


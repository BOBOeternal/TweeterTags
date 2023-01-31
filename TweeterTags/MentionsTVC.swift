//
//  MentionsTVC.swift
//  TweeterTags
//
//  Created by Joy on 2022/12/3.
//

import UIKit

class MentionsTVC: UITableViewController {
    
    var showTweet: TwitterTweet?
    let mentionType = ["Images","URLs","Hashtags","Users"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = showTweet?.user.name
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.mentionType.count
    }
    
    // to set the numbers of rows for each sections, the first one is for the image, second for urls, third for hashtags and the fourth is for usermentions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return (showTweet?.media.count)!
        case 1:
            return (showTweet?.urls.count)!
        case 2:
            return (showTweet?.hashtags.count)!
        case 3:
            return (showTweet?.userMentions.count)!
        default:
            return 0
        }
    }
    
    // set the title for each section, and if there's no items in it, the title won't be shown
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            if((showTweet?.media.count)! > 0){
                return self.mentionType[section]
            } else {
                return ""
            }
        } else if (section == 1) {
            if((showTweet?.urls.count)! > 0){
                return self.mentionType[section]
            } else {
                return ""
            }
        } else if (section == 2) {
            if((showTweet?.hashtags.count)! > 0){
                return self.mentionType[section]
            } else {
                return ""
            }
        } else if (section == 3 ) {
            if((showTweet?.userMentions.count)! > 0){
                return self.mentionType[section]
            } else {
                return ""
            }
        }
        return ""
    }
    
    // to show the data for each row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell",for: indexPath) as! ImageCell
            if let url: URL = showTweet?.media[indexPath.row].url{
                print(url.absoluteString)
                do {
                    let data = try Data(contentsOf: url)
                    cell.imageView?.image = UIImage(data: data)
                } catch {
                    print("Received this error:\n\(error.localizedDescription)")
                }
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "urlCell",for: indexPath) as! URLTVCell
            cell.textLabel?.text = showTweet!.urls[indexPath.row].keyword
            print(showTweet!.urls[indexPath.row].keyword)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "hashtagCell",for: indexPath) as! HashtagTVCell
            cell.textLabel?.text = showTweet!.hashtags[indexPath.row].keyword
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "mentionCell",for: indexPath) as! MentionTVCell
            cell.textLabel?.text = showTweet!.userMentions[indexPath.row].keyword
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "",for: indexPath) as UITableViewCell
            return cell
        }
    }
    
    // to resize the image cell
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            return CGFloat(350)
        } else {
            return UITableView.automaticDimension
        }
    }
    
    // to open links in safari
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 1) {
            if let url = URL(string: (showTweet?.urls[indexPath.row].keyword)!) {
                UIApplication.shared.open(url as URL)
            }
        }
    }
    
    // to make segue work
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if( sender as? ImageVC) != nil {
            if segue.identifier == "showPicture" {
                if let destination =  segue.destination as? ImageVC{
                    if self.tableView.indexPathForSelectedRow != nil{
                        destination.title = showTweet?.user.screenName
                        destination.imageURL = (showTweet?.media[0].url)!
                    }
                }
            }
        } else if let mediaCall = sender as? MentionTVCell {
            if segue.identifier == "mentionToTweetsTVC" {
                if let destination =  segue.destination as? TweetsTVC{
                    if self.tableView.indexPathForSelectedRow != nil{
                        destination.twitterQueryText = (mediaCall.textLabel?.text!)!
                    }
                }
            }
        } else if let cell = sender as? HashtagTVCell {
            if segue.identifier == "hashtagToTweetsTVC" {
                if let destination =  segue.destination as? TweetsTVC{
                    if self.tableView.indexPathForSelectedRow != nil{
                        destination.twitterQueryText = (cell.textLabel?.text!)!
                    }
                }
            }
        }
    }
}

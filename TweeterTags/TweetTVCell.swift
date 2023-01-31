//
//  TweetCell.swift
//  TweeterTags
//
//  Created by Joy on 2022/11/29.
//

import UIKit

class TweetTVCell: UITableViewCell {
    
    @IBOutlet weak var tImage: UIImageView!
    @IBOutlet weak var tDate: UILabel!
    @IBOutlet weak var tName: UILabel!
    @IBOutlet weak var tText: UILabel!
    
    // to let it get tweet everytime it is called
    var tweet: TwitterTweet? { didSet { getTweet() } }
    
    func getTweet() {
        if let showTweet = self.tweet {
            // to set tName as user name
            tName?.text = String(describing: showTweet.user)
            // to get the user profile photo
            if let imageURL = showTweet.user.profileImageURL {
                if let imageData = try? Data(contentsOf: imageURL){
                //if let imageData = try? UIApplication.shared.open(imageURL as URL) {
                    tImage.image = UIImage(data: imageData)
                }
            }
            // to retrieve date data and set its format
            let formatter = DateFormatter()
            if Date().timeIntervalSince(showTweet.created as Date) > (86400-1) {
                formatter.dateStyle = DateFormatter.Style.medium
            } else {
                formatter.timeStyle = DateFormatter.Style.short
            }
            tDate?.text = formatter.string(from: showTweet.created as Date)
            
            // to retrieve content of the tweet and string colours by their type
            if tText?.text != nil  {
                let attributedString = NSMutableAttributedString(string: showTweet.text)
                for url in showTweet.urls {
                    let range = url.nsrange
                    attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: range)
                }
                for hashtag in showTweet.hashtags {
                    let range = hashtag.nsrange
                    attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: range)
                }
                for mention in showTweet.userMentions {
                    let range = mention.nsrange
                    attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.green, range: range)
                }
                tText?.attributedText = attributedString
            }
        }
    }
}

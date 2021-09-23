//
//  TableViewCell.swift
//  disLab
//
//  Created by Yabuki Shodai on 2021/09/08.
//

import UIKit

class CustomTableViewCell: UITableViewCell {


    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categryLabel: UILabel!

    var timeString = String()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setCell(userName:String,title:String,date:Double,categry:String) {
        self.usernameLabel.text = userName
        self.titleLabel.text = title
        categryLabel.text = categry
        self.dateLabel.text = changeUnixToNSDate(dateUnix:date)
      }
    func changeUnixToNSDate(dateUnix:Double) -> String{
        let date = NSDate(timeIntervalSince1970: dateUnix)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日HH時mm分"
        timeString = formatter.string(from: date as Date)
        return timeString
    }
    

    
}



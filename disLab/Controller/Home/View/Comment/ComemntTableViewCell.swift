//
//  ComemntTableViewCell.swift
//  disLab
//
//  Created by Yabuki Shodai on 2021/09/16.
//

import UIKit

class ComemntTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var moreButton: UIButton!
    var titleString = String()
    
    var commentID = String()
    var cellisOpen = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        print("------------------------")
        print(titleString)
        print(titleString.count)

        print("------------------------")
        if titleString.count <= 22{
            moreButton.setTitle("", for: .normal)
        }
        // Configure the view for the selected state
    }
    func setCell(userName:String,commentTitle:String,commentID:String) {
        userNameLabel.text = userName
        commentLabel.text = commentTitle
        self.commentID = commentID
        titleString = commentTitle
    }
    
    @IBAction func doComment(_ sender: Any) {
        print("コメント画面に遷移")
    }
    @IBAction func tapMore(_ sender: Any) {
        cellisOpen = !cellisOpen
        print(cellisOpen)

        print(titleString.count,titleString)
        if cellisOpen == true{
            print("コメントopen")
            commentLabel.numberOfLines = 0
            moreButton.setTitle("閉じる", for: .normal)
            
        }
        else if cellisOpen == false{
            commentLabel.numberOfLines = 1
            print("コメントclose")
            moreButton.setTitle("もっと見る", for: .normal)
        }
        update()
    }
   
    weak var delegate: CustomCellUpdater?
    func update() {
        
        delegate?.updateTableView()
    }
}

protocol CustomCellUpdater: class {
    func updateTableView()
}




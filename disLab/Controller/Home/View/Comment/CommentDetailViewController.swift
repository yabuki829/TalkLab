//
//  CommentDetailViewController.swift
//  disLab
//
//  Created by Yabuki Shodai on 2021/09/16.
//

import UIKit

class CommentDetailViewController: UIViewController {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var commentTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    let userDefaults = UserDefaults.standard
    var commentTitleString = String()
    //コメントタイトルを書いたUserのidのこと
    var commenterID = String()
    var commentID = String()
    var postID = String()
    var userName = String()
    
    var commentArray = [DataSetsComments]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username.text = "\(commenterID)さんの回答"
        commentTitle.text = commentTitleString
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "ComemntTableViewCell", bundle: nil )
        tableView.register(nib, forCellReuseIdentifier: "ComemntTableViewCell")
        self.navigationController?.navigationBar.titleTextAttributes
            = [NSAttributedString.Key.font: UIFont(name: "Times New Roman", size: 15)!]
        textView.layer.borderWidth = 1.0    // 枠線の幅
        textView.layer.cornerRadius = 8.0
        setting()
        getComment()
    }
    override func viewWillLayoutSubviews() {
        viewHeight.constant = commentTitle.frame.height +  username.frame.height + 800
        
    }
    func setting(){
        
//      ローカルデータからuserIDとuser名を取得
        let IDString = userDefaults.object(forKey: "userID")
        
        if let userName = userDefaults.object(forKey: "userName"){
            self.userName = userName as! String
        }
        else{
            self.userName = IDString as! String
        }
        print(userName)
    }
    
    @IBAction func sendComment(_ sender: Any) {
        print("send")
        
        
        if textView.text.isEmpty == false{
            if let comment = textView.text{
                let sendDB = sendDBModel(commentID: commentID, comment:comment , postID: postID, userName: self.userName)
                sendDB.sendCommentToComment()
                tableView.reloadData()
                textView.text = ""
            }
            
        }
    }
    
    func getComment(){
        
        let getComment = getDBModel(commentID: commentID, postID: postID)
        getComment.delegate = self
        getComment.getCommentToComment()
        print(commentArray.count)
    }
}




extension CommentDetailViewController: UITableViewDelegate,UITableViewDataSource,tableViewUpdater,CustomCellUpdater{
    func updateTableView() {
        print("reload")
        tableView.reloadData()
    }
    
    func updateDiscTableView(post: Array<DataSetDocuments>) {}
    
    func updateCommentTableView(post: Array<DataSetsComments>) {
        commentArray = []
        commentArray.append(contentsOf: post)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComemntTableViewCell", for: indexPath) as! ComemntTableViewCell
        cell.delegate = self
        cell.setCell(userName: commentArray[indexPath.row].userName, commentTitle: commentArray[indexPath.row].comment , commentID: commentArray[indexPath.row].commentID)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
  
            return UITableView.automaticDimension
//        return 300
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}

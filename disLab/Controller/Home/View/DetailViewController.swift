//
//  DetailViewController.swift
//  disLab
//
//  Created by Yabuki Shodai on 2021/08/31.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class DetailViewController: UIViewController {

    
    
    @IBOutlet weak var reportButton: UIBarButtonItem!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var discription: UITextView!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var tableview: UITableView! 
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    var isfollow = false
    var database = Firestore.firestore()

    var commentArray = [DataSetsComments]()
    
   var postArrayinDetail = [DataSetDocuments]()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let nib = UINib(nibName: "ComemntTableViewCell", bundle: nil )
        tableview.register(nib, forCellReuseIdentifier: "ComemntTableViewCell")
        tableview.delegate = self
        tableview.dataSource = self
        print("遷移後です")
        if Auth.auth().currentUser?.uid == postArrayinDetail[0].userID{
            reportButton.isEnabled = false
            reportButton.tintColor = UIColor.white
        }
        
        getComments()
        assignData()
        checkFollow()
      
      
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        if tableview.contentSize.height + titleLabel.frame.height + discription.frame.height  > 600{
            viewHeight.constant = titleLabel.frame.height + discription.frame.height  + 800
           
        }
        self.navigationController?.navigationBar.titleTextAttributes
            = [NSAttributedString.Key.font: UIFont(name: "Times New Roman", size: 15)!]
      
        
        
    }
    

    @IBAction func moveUserProfile(_ sender: Any) {
        let profileVC = storyboard?.instantiateViewController(withIdentifier: "profile") as! ProfileViewController
        profileVC.userID = postArrayinDetail[0].userID
        navigationController!.pushViewController(profileVC, animated: true)
    }
    @IBAction func tapCategory(_ sender: Any) {
        //カテゴリーの一覧に遷移する
        print("カテゴリー一覧に遷移します")
        let categoryVC = storyboard?.instantiateViewController(withIdentifier: "category") as! CategoryViewController
        categoryVC.category = String(categoryButton.currentTitle!)
        navigationController!.pushViewController(categoryVC, animated: true)
    }
    @IBAction func commentButton(_ sender: Any) {
        print("コメント画面に遷移します。")
        let commentVC = storyboard?.instantiateViewController(withIdentifier: "commentPost") as! CommentPostViewController
        //postid title
    

   
        commentVC.postID = postArrayinDetail[0].postID
        commentVC.discussionTitle =  postArrayinDetail[0].title
        navigationController!.pushViewController(commentVC, animated: true)
    }
    @IBAction func report(_ sender: Any) {
        alertReport()
        print("aaaa")
    }
    @IBAction func doFollowOrUnfollow(_ sender: Any) {
       
        isfollow = !isfollow
        
        let yourUserID = postArrayinDetail[0].userID
        let isRelation = Relation(yourUserID: yourUserID)
        if isfollow == true {
            print("followしました")
          
            isRelation.follow()
            followButton.setTitle("フォロー中", for: .normal)
        }
        else {
            print("フォローを外しました")
            isRelation.unFollow()
            followButton.setTitle("フォローする", for: .normal)
        }
        
     
    }
    func assignData(){
        //postArrayinDetailを対応するlabelやbuttonに割り当てる
        usernameButton.setTitle(postArrayinDetail[0].userName, for: .normal)
        titleLabel.text = postArrayinDetail[0].title
        discription.text = postArrayinDetail[0].discription
        categoryButton.setTitle(postArrayinDetail[0].category, for: .normal)
        
    }
    func getComments(){
        let getComment = getDBModel(postID:postArrayinDetail[0].postID)
        getComment.delegate = self
        getComment.getCommentData()
    }

    func checkFollow(){
        print("checkします")
        let myUserID = Auth.auth().currentUser?.uid
        let yourUserID =  postArrayinDetail[0].userID
        if myUserID == yourUserID {
            print("呼ばれてます。")
            followButton.isHidden = true
        }
        else{
            
            database.collection("Users").document(myUserID!).collection("Follow").document(yourUserID).getDocument { [self] (snap, error) in
                if let error = error {
                   print(error)
                }
                print("1")
                guard let data = snap?.data() else { return }
                print("2")
                isfollow = (data["Follow"] != nil)
                if isfollow == true {
                    print("followしています")
                    followButton.setTitle("フォロー中", for: .normal)
                }
                else{
                    print("していません")
                    followButton.setTitle("フォローする", for: .normal)
                }
               
            }
        }
    }

    func alertReport(){
        let userID = Auth.auth().currentUser?.uid
        let yourUserID = postArrayinDetail[0].userID
        let title = postArrayinDetail[0].title
        let discription = postArrayinDetail[0].discription
        if userID != yourUserID{
            
            let myAlert: UIAlertController = UIAlertController(title: "通報", message: "通報内容を選択してください", preferredStyle: .alert)
            
         
            let alertA = UIAlertAction(title: "嫌がらせ/差別/誹謗中傷", style: .default) { [self] action in
    //        Todo:firebase にreportを保存する
                let report = "嫌がらせ/差別/誹謗中傷"
               
                let reportViolation = Report(report: report, userID: userID!, yourUserID: yourUserID, title: title, discription: discription)
                reportViolation.Violation()
                OKAlert(title: "完了", message: "報告が完了しました")
                print("嫌がらせ/差別/誹謗中傷")
                
            }
            let alertB = UIAlertAction(title: "文章がわかりにくい", style: .default) { [self] action in
                let report = "文章がわかりにくい"
                let reportViolation = Report(report: report, userID: userID!, yourUserID: yourUserID, title: title, discription: discription)
                reportViolation.Violation()
                OKAlert(title: "完了", message: "報告が完了しました")
                print("文章がわかりにくい")
            }
            let alertC = UIAlertAction(title: "内容が事実と著しく異なる", style: .default) { [self] action in
                let report = "内容が著しく事実と異なる"
                let reportViolation = Report(report: report, userID: userID!, yourUserID: yourUserID, title: title, discription: discription)
                
                reportViolation.Violation()
                OKAlert(title: "完了", message: "報告が完了しました")
                print("内容が事実と異なる")
            }
            let alertD = UIAlertAction(title: "性的表現/わいせつな投稿", style: .default) { [self] action in
                print("性的表現")
                let report = "性的表現"
                let reportViolation = Report(report: report, userID: userID!, yourUserID: yourUserID, title: title, discription: discription)
                
                reportViolation.Violation()
                OKAlert(title: "完了", message: "報告が完了しました")
            }
            let alertE = UIAlertAction(title: "その他不適切な投稿", style: .default) { [self] action in
                print("不適切な投稿")
                let report = "不適切な投稿"
                let reportViolation = Report(report: report, userID: userID!, yourUserID: yourUserID, title: title, discription: discription)
                
                reportViolation.Violation()
                OKAlert(title: "完了", message: "報告が完了しました")
            }
            let cancelAlert = UIAlertAction(title: "キャンセル", style: .cancel) { action in
                print("キャンセル")
            }

            // OKのActionを追加する.
            myAlert.addAction(alertA)
            myAlert.addAction(alertB)
            myAlert.addAction(alertC)
            myAlert.addAction(alertD)
            myAlert.addAction(alertE)
            myAlert.addAction(cancelAlert)
            

            // UIAlertを発動する.
            present(myAlert, animated: true, completion: nil)
        }else{
            OKAlert(title: "報告", message: "自分の投稿は通報できません。")
        }
    }
    func OKAlert(title:String,message:String){
        let myAlert: UIAlertController = UIAlertController(title:title, message: message, preferredStyle: .alert)
        let oklAlert = UIAlertAction(title: "OK", style: .cancel)
        myAlert.addAction(oklAlert)
        present(myAlert, animated: true, completion: nil)
    }
    
}


extension DetailViewController: UITableViewDelegate,UITableViewDataSource,tableViewUpdater,CustomCellUpdater{
    func updateDiscTableView(post: Array<DataSetDocuments>) {}
    
    func updateCommentTableView(post: Array<DataSetsComments>) {
        commentArray = []
        commentArray.append(contentsOf: post)
        tableview.reloadData()
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
        let commentVC = storyboard?.instantiateViewController(withIdentifier: "comment") as! CommentDetailViewController
        commentVC.commentTitleString = commentArray[indexPath.row].comment
        commentVC.commenterID = commentArray[indexPath.row].userName
        commentVC.commentID = commentArray[indexPath.row].commentID
        commentVC.postID = commentArray[indexPath.row].postID
        navigationController!.pushViewController(commentVC, animated: true)

    }
    func updateTableView() {
        tableview.reloadData()
    }
}

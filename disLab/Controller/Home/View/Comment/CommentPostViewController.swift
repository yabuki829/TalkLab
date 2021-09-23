//
//  CommentViewController.swift
//  disLab
//
//  Created by Yabuki Shodai on 2021/09/02.
//コメント(回答)を投稿するためのコントローラー


import UIKit

class CommentPostViewController: UIViewController{
    
    var postID = String()
    var discussionTitle = String()
    
    @IBOutlet weak var responseTextView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    let userDefaults = UserDefaults.standard
    var userName = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        responseTextView.layer.cornerRadius = 10.0
        responseTextView.layer.masksToBounds = true
        responseTextView.layer.borderWidth = 0.2
        responseTextView.layer.borderColor = UIColor.darkGray.cgColor
        
        titleLabel.text = discussionTitle
        setting()
        // Do any additional setup after loading the view.
    }
   
    @IBAction func sendComment(_ sender: Any) {
        print("送信")
        if responseTextView.text != nil{
            alertAndSendDB()
        }
        
    }
    func setting(){

//        ローカルデータからuserIDとuser名を取得
        let IDString = userDefaults.object(forKey: "userID")
        
        if let userName = userDefaults.object(forKey: "userName"){
            self.userName = userName as! String
        }
        else{
            self.userName = IDString as! String
        }
    }
    func alertAndSendDB(){
        //部品のアラートを作る
        let alertController = UIAlertController(title: "注意", message: "コメントは二度と削除できませんがよろしいですか？", preferredStyle: UIAlertController.Style.alert)
        
        //OKボタン追加
        let okAction = UIAlertAction(title: "はい", style: UIAlertAction.Style.default, handler:{ [self] (action: UIAlertAction!) in
            let sendComment = sendDBModel(comment: responseTextView.text, postid: postID, userName:self.userName )
            sendComment.sendComment()
            
            print("投稿が完了しました")
            //アラートが消えるのと画面遷移が重ならないように0.5秒後に画面遷移するようにしてる
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                // 0.5秒後に実行したい処理
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        )
        let noAction = UIAlertAction(title: "いいえ", style: UIAlertAction.Style.default, handler:{ (action: UIAlertAction!) in
                return
            }
        )

           alertController.addAction(okAction)
            alertController.addAction(noAction)

         present(alertController, animated: true, completion: nil)
    }
    
}





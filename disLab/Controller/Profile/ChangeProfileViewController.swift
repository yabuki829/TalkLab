//
//  ChangeProfileViewController.swift
//  disLab
//
//  Created by Yabuki Shodai on 2021/09/10.
//

import UIKit


class ChangeProfileViewController: UIViewController {

    var userProfile = [UserInfo]()
    
    
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var introductionTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.text = userProfile[0].userName
        introductionTextField.text = userProfile[0].introduction
        // Do any additional setup after loading the view.
    }

    @IBAction func saveUserInfo(_ sender: Any) {
        if introductionTextField.text!.count >= 20 && userNameTextField.text!.count >= 10 {
            print("規定の文字数を超えています")
            return
        }
        var userName =  userNameTextField.text
        var intro =  introductionTextField.text
        if userName?.isEmpty == true && intro?.isEmpty == true{
            print("未入力のため")
            print("デフォルトのprofileを代入します")
            userName = userProfile[0].userID
            intro = "フォローよろしくお願いします。"
        }
        
            let changeDB = ChangeDB(userid: userProfile[0].userID, userName: userName!, Introduction: intro!)
            changeDB.changeProfile()
            self.navigationController?.popViewController(animated: true)
        
    }

    
}

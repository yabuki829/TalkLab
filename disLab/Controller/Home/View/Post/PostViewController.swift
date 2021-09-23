//
//  PostViewController.swift
//  disLab
//
//  Created by Yabuki Shodai on 2021/08/17.
//

import UIKit


class PostViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var discreiputiontextField: UITextView!
    
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    let userDefaults = UserDefaults.standard
    let category = ["芸能","社会","ビジネス","政治","法律","金融","企業","コンピューター","歴史","健康","恋愛","勉強","サイエンス","趣味","その他"]
    var selectedCategory = String()
    var indicator = UIActivityIndicatorView()
    var userName = String()
    var userID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        setting()
        ui()
    }
    
    @IBAction func postDiscription(_ sender: Any) {
        //title discription category が入力されていれば
        if titleTextField.text?.isEmpty == true {
           alert(alertType: "titleisEmpty")
        }
        if discreiputiontextField.text.isEmpty == true{
            alert(alertType: "discriptionisEmpty")
        }
        if discreiputiontextField.textColor == UIColor.lightGray{
            alert(alertType: "discriptionisEmpty")
        }
        if let title = titleTextField.text, let discription = discreiputiontextField.text {
           
            let sendDB = sendDBModel(userID:userID,title: title, discription: discription, category: selectedCategory, userName: userName)
            sendDB.postDiscription()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func setting(){
        
//        ローカルデータからuserIDとuser名を取得
        let IDString = userDefaults.object(forKey: "userID")
        self.userID = IDString as! String
        
        if let userName = userDefaults.object(forKey: "userName"){
            self.userName = userName as! String
        }
        else{
            self.userName = IDString as! String
        }
    }
    func ui(){
        selectedCategory = category[category.count / 2 - 2]
        titleTextField.layer.borderWidth = 1.0
        discreiputiontextField.layer.borderWidth = 1.0
        discreiputiontextField.layer.cornerRadius = 8.0
        categoryPicker.selectRow(category.count / 2 - 2, inComponent: 0, animated: false)
    }
    
    func alert(alertType:String){
        if alertType == "titleisEmpty"{
            let alert = UIAlertController(title: "報告", message:"タイトルが入力されていません", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if alertType == "discriptionisEmpty"{
            let alert = UIAlertController(title: "報告", message:"内容が入力されていません", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if alertType == "complete"{
            let alert = UIAlertController(title: "報告", message:"投稿が完了しました", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
  
}

extension PostViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if discreiputiontextField.textColor == UIColor.lightGray {
            discreiputiontextField.text = nil
            discreiputiontextField.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if discreiputiontextField.text.isEmpty {
            discreiputiontextField.text = """
            補足情報や意見を書きましょう。
            「結論」　「回答」　➡︎　「根拠」 「理由」　を意識しましょう。

            """
            discreiputiontextField.textColor = UIColor.lightGray
        }
    }

}


extension PostViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return  category.count
    }
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        
        return category[row]
    }
     
    // UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
    
        selectedCategory = category[row]
    }
}

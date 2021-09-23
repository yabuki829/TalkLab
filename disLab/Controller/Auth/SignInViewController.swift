//
//  SignInViewController.swift
//  disLab
//
//  Created by Yabuki Shodai on 2021/08/10.
//

import UIKit
import LTMorphingLabel
import FirebaseFirestore
import FirebaseAuth

class SignInViewController: UIViewController, UITextFieldDelegate  ,LTMorphingLabelDelegate {

    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    let userDefaults = UserDefaults.standard
    var ableString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_@."
    @IBOutlet weak var textLabel: LTMorphingLabel!
    
    private var timer: Timer?
       //String配列のindex用
       private var index: Int = 0
       //表示するString配列
    private let textList = ["討論で新たな","考えを学ぶアプリ"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = userDefaults.string(forKey: "user-info") {
          print(user)
        }
        textLabel.morphingEffect = .scale
        textLabel.textColor  = .darkGray
        view.backgroundColor = .systemGray6
        let tapGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
                tapGR.cancelsTouchesInView = false
                self.view.addGestureRecognizer(tapGR)
        setUpUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            let HomeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Home")
            HomeVC.modalPresentationStyle = .fullScreen
            present(HomeVC, animated: true, completion: nil)
        }
            //タイマーの追加
            timer = Timer.scheduledTimer(timeInterval: 3.0,
                                         target: self,
                                         selector: #selector(update(timer:)), userInfo: nil,
                                         repeats: true)
            timer?.fire()
        }
        
        override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
            timer!.invalidate()
           
        }
        
    @objc func update(timer: Timer) {
        if index >= textList.count {
            textLabel.text = "Dis LaB"
            timer.invalidate()
        }
        else{
            textLabel.text = textList[index]
            
        }
        index += 1
        
      

}
    @objc func dismissKeyboard() {
           self.view.endEditing(true)
    }
    
    private func setUpUI(){
    
        addEmailTextField()
        addpasswordTextField()
        addSigninLabel()
        addSigninButton()
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.count > 0 {
            var allowedCharacters = CharacterSet(charactersIn: ableString)
            allowedCharacters.insert(charactersIn: " -")

            let unwantedStr = string.trimmingCharacters(in: allowedCharacters) // 入力可能な文字を全て取り去った文字列に文字があれば、テキスト変更できないFalseを返す。
            if unwantedStr.count == 0 {
                
                return true
            } else {
                print("unable")
                print(unwantedStr)
                emailTextField.text = ""
                return false
            }
        } else {
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        return true
    }
    func addEmailTextField(){
        let emailWidth: CGFloat = 250
        let emailHeight: CGFloat = 30
        let posX: CGFloat = (self.view.bounds.width - emailWidth)/2
        let posY: CGFloat = (self.view.bounds.height - emailHeight)/3
        
        // UITextFieldを作成する.
        emailTextField = UITextField(frame: CGRect(x: posX, y: posY, width: emailWidth, height: emailHeight))
        
        // 表示する文字を代入する.
        emailTextField.placeholder = "Email"
        emailTextField.autocorrectionType = .no
        // 枠を表示する.
        emailTextField.borderStyle = .roundedRect
        emailTextField.keyboardType = .emailAddress
        emailTextField.delegate = self
        // クリアボタンを追加.
        emailTextField.clearButtonMode = .whileEditing
        
        // Viewに追加する
        self.view.addSubview(emailTextField)
        
        let emailLabel = UILabel(frame: CGRect(x: posX , y: posY - emailHeight , width:200 , height: 30))
        emailLabel.text = "メールアドレス"
        emailLabel.shadowColor = UIColor.gray
        emailLabel.textColor = UIColor.darkGray
        // Textを中央寄せにする.
        emailLabel.textAlignment = NSTextAlignment.left
        self.view.addSubview(emailLabel)
    }
    func addpasswordTextField(){
        let passwordWidth: CGFloat = 250
        let passwordHeight: CGFloat = 30
        let posX: CGFloat = (self.view.bounds.width - passwordWidth)/2
        let posY: CGFloat = (self.view.bounds.height)/2.3
        
        // UITextFieldを作成する.
        passwordTextField = UITextField(frame: CGRect(x: posX, y: posY, width: passwordWidth, height: passwordHeight))
        passwordTextField.delegate = self
        // 表示する文字を代入する.
        
        passwordTextField.placeholder = "Password"
        passwordTextField.keyboardType = .alphabet  //
        passwordTextField.isSecureTextEntry = true
        // 枠を表示する.
        passwordTextField.borderStyle = .roundedRect
        
        // クリアボタンを追加.
        passwordTextField.clearButtonMode = .whileEditing
        
        // Viewに追加する
        self.view.addSubview(passwordTextField)
        
        let passwordLabel = UILabel(frame: CGRect(x: posX , y: posY - passwordHeight , width:200 , height: 30))
        passwordLabel.text = "パスワード"
        passwordLabel.shadowColor = UIColor.gray
        passwordLabel.textColor = UIColor.darkGray
        // Textを中央寄せにする.
        passwordLabel.textAlignment = NSTextAlignment.left
        self.view.addSubview(passwordLabel)  
    }
    func addSigninLabel(){
        let posX: CGFloat = (self.view.bounds.width)/8.0
        let posY: CGFloat = (self.view.bounds.height)/6.0
        let label = UILabel(frame: CGRect(x: posX , y: posY , width:300 , height: 50))
        label.font = UIFont.systemFont(ofSize: 30)
        label.text = "Sign In With Email"
        label.font.withSize(30)
        //        label.textColor = UIColor.blue
        label.textAlignment = NSTextAlignment.left
        self.view.addSubview(label)
    }
    private func addSigninButton(){
        let signupButton = UIButton()
        
        // ボタンのサイズ.
        let bWidth: CGFloat = 200
        let bHeight: CGFloat = 50
        
        // ボタンのX,Y座標.
        let posX: CGFloat = self.view.frame.width/2 - bWidth/2
        let posY: CGFloat = self.view.frame.height/1.7 - bHeight/2
        
        // ボタンの設置座標とサイズを設定する.
        signupButton.frame = CGRect(x: posX, y: posY, width: bWidth, height: bHeight)
        
        // ボタンの背景色を設定.
        signupButton.backgroundColor = UIColor.orange
        
        // ボタンの枠を丸くする.
        signupButton.layer.masksToBounds = true
        
        // コーナーの半径を設定する.
        signupButton.layer.cornerRadius = 20.0
        
        // タイトルを設定する(通常時).
        signupButton.setTitle("Sign In", for: .normal)
        signupButton.setTitleColor(UIColor.white, for: .normal)
        
        // タイトルを設定する(ボタンがハイライトされた時).
        signupButton.setTitle("Sign In", for: .highlighted)
        signupButton.setTitleColor(UIColor.black, for: .highlighted)
        
        // ボタンにタグをつける.
        signupButton.tag = 1
        
        // イベントを追加する
        signupButton.addTarget(self, action: #selector(self.onClickSigninButton(sender:)), for: .touchUpInside)
        
        // ボタンをViewに追加.
        self.view.addSubview(signupButton)
        
        
        
        
        let label = UILabel(frame: CGRect(x: 50 , y: posY + 120 , width:230 , height: 30))
        label.text = "アカウントをお持ちでない方は"
        label.textAlignment = NSTextAlignment.center
        self.view.addSubview(label)
        
        let moveToSignin = UIButton()
        moveToSignin.setTitle("こちら", for: .normal)
        moveToSignin.setTitleColor(UIColor.link, for: .normal)
        moveToSignin.setTitle("こちら", for: .highlighted)
        moveToSignin.setTitleColor(UIColor.lightGray, for: .highlighted)
        moveToSignin.frame = CGRect(x: 50 + 230 , y: posY + 120 , width: 100, height: 30)
        moveToSignin.addTarget(self, action: #selector(self.movetoSigninPage(sender:)),        for: .touchUpInside)
        self.view.addSubview(moveToSignin)
        
    }
    
    @objc internal func onClickSigninButton(sender: UIButton) {
        if let userEmail = emailTextField.text,let userPassword = passwordTextField.text{
            print("signin")
            signIn(email: userEmail, password: userPassword)
        }
    }
    
    func signIn(email: String,password:String){
        
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if let error = error {
                    print(error.localizedDescription)
                    let errorAlert = UIAlertController(title: "エラー", message: error.localizedDescription, preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(errorAlert, animated: true, completion: nil)
                }
                self.userDefaults.set(Auth.auth().currentUser?.uid, forKey: "userID")
                if let user = result?.user {
                    let HomeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Home")
                    HomeVC.modalPresentationStyle = .fullScreen
                    self.present(HomeVC, animated: true, completion: nil)
                }
            }
    }
    
    @objc internal func movetoSigninPage(sender: UIButton) {
        print("Sign Up　に遷移する")
        let SignUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUp")
        present(SignUpVC, animated: true, completion: nil)
    }
    
}

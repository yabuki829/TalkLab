import UIKit
import LTMorphingLabel
import FirebaseFirestore
import FirebaseAuth

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    var emailAlertLabel: UILabel!
    var passwordAlertLabel: UILabel!
    var ableString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_@."
    var userEmail = String()
    var userPassword = String()
    var checkBox = UIButton()
    var check = false
    var database = Firestore.firestore()
    let userDefaults = UserDefaults.standard
    @IBOutlet weak var textLabel: LTMorphingLabel!
    
    private var timer: Timer?
    //String配列のindex用
    private var index: Int = 0
    //表示するString配列
    private let textList = ["DisLaBで","新しい考えを","学びましょう",]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        textLabel.textColor  = .darkGray
        textLabel.morphingEffect = .scale
        view.backgroundColor = .systemGray6
        let tapGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGR.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGR)
        setUpUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //タイマーの追加
        timer = Timer.scheduledTimer(timeInterval: 3.0,
                                     target: self,
                                     selector: #selector(update(timer:)), userInfo: nil,
                                     repeats: true)
        timer?.fire()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        timer?.invalidate()
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
            var allowedCharacters = CharacterSet(charactersIn: ableString) // 入力可能な文字
            allowedCharacters.insert(charactersIn: " -")
            
            let unwantedStr = string.trimmingCharacters(in: allowedCharacters) // 入力可能な文字を全て取り去った文字列に文字があれば、テキスト変更できないFalseを返す。
            if unwantedStr.count == 0 {
                return true
            } else {
                return false
            }
        } else {
            return true
        }
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordValidate()
        emailVAlidate()
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
        // 枠を表示する.
        emailTextField.borderStyle = .roundedRect
        emailTextField.keyboardType = .alphabet
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
        print("posY: \(posY)")
        emailAlertLabel = UILabel(frame: CGRect(x: posX - 5 , y: posY + emailHeight + 5, width:300 , height: 30))
        emailAlertLabel.textColor = UIColor.red
        emailAlertLabel.text = ""
        self.view.addSubview(emailAlertLabel)
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
        passwordTextField.textContentType = .newPassword
        passwordTextField.isSecureTextEntry = true
        // 枠を表示する.
        passwordTextField.borderStyle = .roundedRect
        
        // クリアボタンを追加.
        passwordTextField.clearButtonMode = .whileEditing
        
        // Viewに追加する
        self.view.addSubview(passwordTextField)
        
        passwordAlertLabel = UILabel(frame: CGRect(x: posX - 5 , y: posY + 5  + passwordHeight , width:300 , height: 30))
        passwordAlertLabel.textColor = UIColor.red
        self.view.addSubview(passwordAlertLabel)
    
        
        
        let passwordLabel = UILabel(frame: CGRect(x: posX , y: posY - passwordHeight , width:200 , height: 30))
        passwordLabel.text = "パスワード(8文字以上)"
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
        label.text = "Sign Up With Email"
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
        signupButton.setTitle("Sign Up", for: .normal)
        signupButton.setTitleColor(UIColor.white, for: .normal)
        
        // タイトルを設定する(ボタンがハイライトされた時).
        signupButton.setTitle("Sign Up", for: .highlighted)
        signupButton.setTitleColor(UIColor.black, for: .highlighted)
        // ボタンにタグをつける.
        signupButton.tag = 1
        
        // イベントを追加する
        signupButton.addTarget(self, action: #selector(SignUpViewController.onClickSigninButton(sender:)),        for: .touchUpInside)
        
        // ボタンをViewに追加.
        self.view.addSubview(signupButton)
        
        checkBox = UIButton(frame: CGRect(x: self.view.frame.width/2 - 50 - 30  , y: posY + 65 , width: 30, height: 30))
        checkBox.layer.borderWidth = 2
        checkBox.layer.borderColor = UIColor.gray.cgColor
        checkBox.setImage(UIImage(systemName: "square"), for: .normal)
        checkBox.addTarget(self, action: #selector(self.tapCheckBox(sender:)), for: .touchUpInside)
        
        
        
        self.view.addSubview(checkBox)
        let termsOfUseButton = UIButton(frame: CGRect(x: self.view.frame.width/2 - 50 , y: posY + 65 , width: 100, height: 30))
        termsOfUseButton.setTitle("利用規約", for: .normal)
        termsOfUseButton.setTitleColor(UIColor.black, for: .normal)
        
        termsOfUseButton.addTarget(self, action: #selector(self.termsOfUsePage(sender:)),        for: .touchUpInside)
        self.view.addSubview(termsOfUseButton)
        
    }
    @objc internal func tapCheckBox(sender: UIButton) {
        check = !check
        if check == true {
            checkBox.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
           
        }
        else if check == false {
            checkBox.setImage(UIImage(systemName: "square"), for: .normal)
        }
        
       
     
    }
    
    
    
    
    @objc internal func onClickSigninButton(sender: UIButton) {
        //emailとpasswordがfirebaseに保存されればHomeに画面遷移する。
        passwordValidate()
        emailVAlidate()
        if userEmail.isEmpty == false ,userPassword.isEmpty == false {
            print("aaaaa")
            register(email: userEmail, password: userPassword)
        }
            
        
    }
    @objc internal func termsOfUsePage(sender: UIButton) {
        print("利用規約")
        //Signinに画面遷移する
    }
    func passwordValidate(){
        if passwordTextField.text?.isEmpty == true {
            passwordAlertLabel.text = "パスワードを入力してください"
            return
        }
        if  passwordTextField.text!.count < 8   {
            passwordAlertLabel.text = "8文字以上で入力してください"
            
            return
        }
        userPassword = passwordTextField.text!
        
        passwordAlertLabel.text = ""
    }
    func emailVAlidate(){
        if emailTextField.text?.isEmpty == true {
            emailAlertLabel.text = "メールアドレスを入力してください"
            return
        }
        userEmail = emailTextField.text!
        emailAlertLabel.text = ""
    }
    func register(email: String, password: String){
        Auth.auth().createUser(withEmail: userEmail , password: userPassword) { [weak self] Result, Error in
            print("aaaaa")
            if let error = Error {
                print(error)
                let errorAlert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(errorAlert, animated: true, completion: nil)
                return
                
            }
            if let user = Result?.user {
              
                print(user)
                print("aaa")
                print(type(of: user))
                self!.sendEmailVerification(to: user)
            }
        }
    }
    func sendEmailVerification(to user: User){
        print("-----------------")
        print(user)
        user.sendEmailVerification(completion: { (error) in
            if error != nil {
                print(error?.localizedDescription)
                let errorAlert = UIAlertController(title: "報告", message: error?.localizedDescription, preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
              
                return
            }
           print("oooookkkkkk")
            self.userDefaults.set(Auth.auth().currentUser?.uid, forKey: "userID")
            let okAlert = UIAlertController(title: "仮登録を行いました。", message: "入力したメールアドレス宛に確認メールを送信しました。確認後SignIn画面でSignInしてください", preferredStyle: .alert)
            
            let confirmAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                (action: UIAlertAction!) -> Void in
                print("OK")
                self.database.collection("Users").document(Auth.auth().currentUser!.uid).setData(
                    ["userID":Auth.auth().currentUser!.uid]
                )
               
               
            })
            okAlert.addAction(confirmAction)
            self.present(okAlert, animated: true, completion: nil)
            
            
        })

    }
}

extension UITextField {
    func disableAutoFill() {
        if #available(iOS 12, *) {
            textContentType = .oneTimeCode
        } else {
            textContentType = .init(rawValue: "")
        }
    }
}

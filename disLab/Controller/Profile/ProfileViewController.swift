import UIKit
import FirebaseAuth
import FirebaseFirestore

class ProfileViewController: UIViewController {
    
    var database = Firestore.firestore()
    var isfollow = false
    var userID = String()
    var postArray = [DataSetDocuments]()
    var userInfo = [UserInfo]()
    
    @IBOutlet weak var changeProfileButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var signOutButton: UIBarButtonItem!
    @IBOutlet weak var introductionLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var followAndUnFollowButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
       
        
        let nib = UINib(nibName: "CustomTableViewCell", bundle: nil )
        tableView.register(nib, forCellReuseIdentifier: "CustomTableViewCell")
        
        if userID.isEmpty == true{
            userID = Auth.auth().currentUser!.uid
            followAndUnFollowButton.isHidden = true
        }
        else{
            checkFollow()
            changeProfileButton.isHidden = true
            signOutButton.isEnabled = false
            signOutButton.tintColor = .clear
        }
       
        getUserInfo()
        getDoc()
       
        
    }

    @IBAction func SignOut(_ sender: Any) {
        let SigninVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignIn")
        do {
               try Auth.auth().signOut()
            SigninVC.modalPresentationStyle = .fullScreen
            present(SigninVC, animated: true, completion: nil)
            print("サインアウトしました。")
           } catch let error {
               print(error)
                print("エラー")
           }
        
    }
    @IBAction func changeUserName(_ sender: Any) {
        //名前を変更する
        print("名前を変更します")
        let changeVC = storyboard?.instantiateViewController(withIdentifier: "change") as! ChangeProfileViewController
        let newData = UserInfo(userID: Auth.auth().currentUser!.uid, userName:userNameLabel.text! , introduction: introductionLabel.text! )
        //変更ページに遷移する
        
        changeVC.userProfile.append(newData)
        navigationController!.pushViewController(changeVC, animated: true)
    }
    
    @IBAction func checkFollow(_ sender: Any) {
        //こちらがフォローしてる人の名前を一覧表示
        print("フォロー画面へ遷移します")
    }
    
    @IBAction func checkFollower(_ sender: Any) {
        //フォローしてくれてる人を一覧で表示する
        print("フォロワー画面へ遷移します")
    }
    @IBAction func tapFollow(_ sender: Any) {
        isfollow = !isfollow
        
        let yourUserID = userID
        let isRelation = Relation(yourUserID: yourUserID)
        if isfollow == true {
            print("followしました")
          
            isRelation.follow()
            followAndUnFollowButton.setTitle("フォロー中", for: .normal)
        }
        else {
            print("フォローを外しました")
            isRelation.unFollow()
            followAndUnFollowButton.setTitle("フォローする", for: .normal)
        }
    }
}

extension ProfileViewController :UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        cell.setCell(userName: postArray[indexPath.row].userName, title:  postArray[indexPath.row].title, date:  postArray[indexPath.row].createdAt , categry:  postArray[indexPath.row].category)
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "detail") as! DetailViewController
        //遷移する際にpostArray[index.row]を連れていく
        
        let newData = DataSetDocuments(
            userID: postArray[indexPath.row].userID,
            userName: postArray[indexPath.row].userName,
            postID: postArray[indexPath.row].postID,
            title: postArray[indexPath.row].title,
            discription: postArray[indexPath.row].discription,
            category: postArray[indexPath.row].category,
            createdAt: postArray[indexPath.row].createdAt,
            isOpen: postArray[indexPath.row].isOpen)
        
        detailVC.postArrayinDetail.append(newData)
        navigationController!.pushViewController(detailVC, animated: true)
        
        
    }
}


extension ProfileViewController{
   
    func getDoc(){
        database.collection("Users").document(userID).collection("Post").order(by:"createdAt", descending: true).addSnapshotListener{ (querySnapshot, err) in
            self.postArray = []
            if let err = err {
                print("エラー\(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    
                    if let userID = data["userID"],
                       let postID = data["postID"],
                       let discription = data["discription"],
                       let title = data["title"],
                       let createdAt = data["createdAt"],
                       let isOpen = data["isOpen"],
                       let category = data["category"]{
                      

                        let newData = DataSetDocuments(userID: userID as! String, userName:  self.userInfo[0].userName
,postID: postID as! String,title: title as! String,discription: discription  as! String, category: category as! String, createdAt: createdAt as! Double, isOpen: isOpen as! Bool)
                        self.postArray.append(newData)
                    }
      
                }
                self.tableView.reloadData()
            }
        }
    }
    func setting(){
        self.navigationController?.navigationBar.titleTextAttributes
            = [NSAttributedString.Key.font: UIFont(name: "Times New Roman", size: 15)!]
        tableView.layer.cornerRadius = 5
        tableView.clipsToBounds = true
        print("userID",userID.count)
        
       
        
    }
    
    func checkFollow(){
        print("呼ばれてます。")
        let myUserID = Auth.auth().currentUser?.uid as! String
        let yourUserID =  userID
        print("myUserID",myUserID)
        print("yourUserID",yourUserID)
        
        
        
        if myUserID == yourUserID {
            followAndUnFollowButton.isHidden = true
            print("呼ばれてます")
            return
        }
        else{
            database.collection("Users").document(myUserID).collection("Follow").document(yourUserID).getDocument { [self] (snap, error) in
                print("aaaa")
                if let error = error {
                   print(error)
                }
                guard let data = snap?.data() else { return }
                print("2")
                isfollow = (data["Follow"] != nil)
                if isfollow == true {
                    followAndUnFollowButton.setTitle("フォロー中", for: .normal)
                }
                else{
                    followAndUnFollowButton.setTitle("フォローする", for: .normal)
                }
               
            }
        }
    }
    
    
    
    func getUserInfo(){
        database.collection("Users").document(userID).addSnapshotListener{ [self] (querySnapshot, err) in
    
            self.userInfo = []
            if let err = err {
                print("エラー\(err)")
            } else {
                let data = querySnapshot?.data()
                
                print(data)
                if data != nil{
                    var userName = data!["userName"]  as! String
                    var introductionString = data!["Introduction"] as! String
                    print(userName)
                    print(introductionString)
                  
                    let newData = UserInfo(userID: Auth.auth().currentUser!.uid, userName: userName, introduction: introductionString)
                    userInfo.append(newData)
                    userNameLabel.text = userInfo[0].userName
                    introductionLabel.text = userInfo[0].introduction
                }
                else{
                    userNameLabel.text  = Auth.auth().currentUser?.uid
                    introductionLabel.text = "紹介文"
                }
               
            }
        }
        
    }
    
    
}

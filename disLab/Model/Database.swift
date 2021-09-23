//
//  Database.swift
//  disLab
//
//  Created by Yabuki Shodai on 2021/08/17.
//
import Foundation
import FirebaseFirestore
import FirebaseAuth


class sendDBModel {
    var database = Firestore.firestore()
    var userID = String()
    
        
    //投稿----------------------------
    
    var postID = String()
    var discription = String()
    var title = String()
    var category = String()
    //投稿に対してコメントができるかどうか true なら　コメントができる
    var isOpen = Bool()
    var createdAt = Double()
    var userName = String()
    init(userID: String,title:String,discription:String,category:String,userName:String) {
        self.userID = userID
        self.title = title
        self.discription = discription
        self.category = category
        self.userName = userName
        self.postID =  UUID().uuidString
        self.isOpen = true
    }
    func postDiscription(){
        self.database.collection("Users").document(Auth.auth().currentUser!.uid).collection("Post").document(postID).setData(
            ["userID":userID,"userName":userName,"postID":postID,"discription":discription,"title":title,"category":category,"createdAt":Date().timeIntervalSince1970,"isOpen":true]
        )
        self.database.collection("Post").document(postID).setData(
            ["userID":userID,"userName":userName,"postID":postID,"discription":discription,"title":title,"category":category,"createdAt":Date().timeIntervalSince1970,"isOpen":true]
        )
        self.database.collection(category).document(postID).setData(
            ["userID":userID,"userName":userName,"postID":postID,"discription":discription,"title":title,"category":category,"createdAt":Date().timeIntervalSince1970,"isOpen":true]
            
        )
    }
    
    //コメントの送信------------
    //コメントに対しては簡潔なコメントしか送信できないようにする。もしくはコメントできないようにする。
    var comment = String()
    var commentID = String()
  
    
    
    init(comment: String,postid:String,userName:String) {
        userID = Auth.auth().currentUser!.uid
        self.comment = comment
        //どの投稿に対してのコメントなのか
        postID = postid
        commentID =  UUID().uuidString
        self.userName = userName
    }
    
    func sendComment(){
        
        self.database.collection("Post").document(postID).collection("Comments").document(commentID).setData(
            ["commentID":commentID,"userName":userName,"userID":userID,"postID":postID,"comment":comment,"createdAt":Date().timeIntervalSince1970]
            
        )
        
    }
//    コメントtoコメント
    
    init(commentID:String,comment:String,postID:String,userName:String) {
        self.postID = postID
        self.comment = comment
        self.commentID = commentID
        userID =  Auth.auth().currentUser!.uid
        self.userName = userName
    }
    func sendCommentToComment(){
        self.database.collection("Post").document(postID).collection("Comments").document(commentID).collection("Comment").document().setData(
            ["commentID":commentID,"userName":userName,"userID":userID,"postID":postID,"comment":comment,"createdAt":Date().timeIntervalSince1970]
        )
    }
    
}



//データベースから値を取り出すクラス
class getDBModel{
    var database = Firestore.firestore()
    
    var postArray = [DataSetDocuments]()
    var type = String()
    //ジャンルと一覧表示
    init(Type:String) {
        type = Type
    }
    
   
    var commentArray =  [DataSetsComments]()
    var postID = String()
    init(postID:String){
        self.postID = postID
    }
    func getCommentData(){
        self.commentArray = []
        database.collection("Post").document(postID).collection("Comments").order(by:"createdAt", descending: false).addSnapshotListener{[self] (querySnapshot, err) in
            if let err = err {
                print("エラー\(err)")
            } else {
                
                for document in querySnapshot!.documents {
                    let data = document.data()
                   
                    
                    if let userID = data["userID"],
                       let commentID = data["commentID"],
                       let comment = data["comment"],
                       let createdAt = data["createdAt"],
                       let postID = data["postID"],
                       let userName = data["userName"]
                       {
                        
                        let newData = DataSetsComments(userID: userID as! String, userName: userName as! String, postID:postID as! String , commentID: commentID as! String, comment: comment as! String, createdAt: createdAt as! Double, cellisOpen:false )
                        commentArray.append(newData)
                    }
                        
                
                }
               updateComments()
            }
        }
    }
    
    func getDocument () {
        print("今から取得します")
     
        database.collection(type).order(by:"createdAt", descending: true).addSnapshotListener{ [self] (querySnapshot, err) in
          postArray = []
            print("取得中")
            if let err = err {
                print("エラー\(err)")
            } else {
                print("取得中2")
                for document in querySnapshot!.documents {
                    let data = document.data()
                    
                    if let userID = data["userID"],
                       let postID = data["postID"],
                       let discription = data["discription"],
                       let title = data["title"],
                       let createdAt = data["createdAt"],
                       let isOpen = data["isOpen"],
                       let category = data["category"],
                       let userName =  data["userName"]{
                        let newData = DataSetDocuments(userID: userID as! String, userName:userName as! String,postID: postID as! String,title: title as! String,discription: discription  as! String, category: category as! String, createdAt: createdAt as! Double, isOpen: isOpen as! Bool)
                        postArray.append(newData)
                    
                    }
                    
                }
                self.update()
            }
        }
    }
    var commentID = String()
    init(commentID: String, postID: String) {
        self.commentID = commentID
        self.postID = postID
    }
    
    func getCommentToComment(){
     
        self.database.collection("Post").document(postID).collection("Comments").document(commentID).collection("Comment").order(by:"createdAt", descending: false).addSnapshotListener{ [self] (querySnapshot, err) in
            if let err = err {
                print("エラー\(err)")
            } else {
                commentArray = []
                for document in querySnapshot!.documents {
                    let data = document.data()
                    print("aaa")
                    
                    if let userID = data["userID"],
                       let userName = data["userName"],
                       let commentID = data["commentID"],
                       let comment = data["comment"],
                       let createdAt = data["createdAt"],
                       let postID = data["postID"]
                       {
                      
                       
                        let newData = DataSetsComments(userID: userID as! String, userName: userName as! String, postID:postID as! String , commentID: commentID as! String, comment: comment as! String, createdAt: createdAt as! Double, cellisOpen:false )
                        commentArray.append(newData)
                
                    }
                }
               updateComments()
            }
            
        }
    }
    var userID = String()
    
    init(userID:String) {
        self.userID = userID
    }
    
    var userInfoData = [UserInfo]()
    func getUserName(){
       
        database.collection("Users").document(userID).getDocument{ [self] (querySnapshot, err) in
            if let err = err {
                print("エラー\(err)")
            } else {
                let data = querySnapshot?.data()
                if data != nil{
                    let userName = data!["userName"] as! String
                    let ID = data!["userID"] as! String
                    let intro = data!["Introduction"] as! String
                    let newdata = UserInfo(userID: ID, userName: userName, introduction:intro)
                    userInfoData.append(newdata)
                    reflectUserName()
                }
                else{
                    let userName = userID
                    let ID = userID
                    let intro = "紹介文"
                    let newdata = UserInfo(userID: ID, userName: userName, introduction:intro)
                    userInfoData.append(newdata)
                    reflectUserName()
                }
                
            }
        }
    }
    
    var getUsernamedelegate: reflectUserNameDelegate?
    weak var delegate: tableViewUpdater?
    func update() {
        delegate?.updateDiscTableView(post: postArray)
    }
    func updateComments(){
        delegate?.updateCommentTableView(post: commentArray)
    }
    func reflectUserName(){
        getUsernamedelegate?.reflectUserName(info:userInfoData)
    }
}

//フォローしたり、アンフォローしたりするためのクラス
class Relation {
    var database = Firestore.firestore()
    var userID = String()
    var yourUserID = String()
    
    init(yourUserID:String) {
        userID = Auth.auth().currentUser!.uid
        self.yourUserID = yourUserID
    }
    
    func follow(){

        self.database.collection("Users").document(userID).collection("Follow").document(yourUserID).setData(
            ["followUserID":yourUserID,"Follow":true]
        )
        self.database.collection("Users").document(yourUserID).collection("isFollowed").document(userID).setData(
            ["followUserID":yourUserID,"isFollowed":true]
        )
        
    }
    func unFollow(){
        //フォローを解除する

        self.database.collection("Users").document(userID).collection("Follow").document(yourUserID).delete()
        self.database.collection("Users").document(yourUserID).collection("isFollowed").document(userID).delete()
        
    }
    
    
//    func check(){
//        self.database.collection("Users").document(userID).collection("Follow").document(yourUserID).getDocument { (<#DocumentSnapshot?#>, <#Error?#>) in
//            <#code#>
//        }
//    }
    
    
    
}


//違法な投稿や不適切な投稿を通報するためのクラス

class Report{
    let database = Firestore.firestore()
    var report = String()
    var userID = String()
    var yourUserID = String()
    var title = String()
    var discription = String()
    init(report:String,userID:String,yourUserID:String,title:String,discription:String) {
        self.report = report
        self.userID = userID
        self.yourUserID = yourUserID
        self.title = title
        self.discription = discription
    }
    //投稿を通報
    func Violation(){
        self.database.collection("通報された投稿").document(report).collection("Report").document().setData(
            ["通報者":userID,"違反内容":report,"違反者":yourUserID,"投稿内容":discription,"タイトル":title]
        )
    }
    //コメントを通報

}

class ChangeDB{
    var database = Firestore.firestore()
    var userName = String()
    var userID = String()
    var introduction = String()
    
    init(userid:String,userName:String,Introduction:String) {
        self.userName = userName
        userID = userid
        introduction = Introduction
    }
    func changeProfile(){
        print("aaaa")
        let userDefaults = UserDefaults.standard
       
        userDefaults.set(userName, forKey: "userName")
        self.database.collection("Users").document(Auth.auth().currentUser!.uid).setData(
            ["userID":userID,"userName":userName,"Introduction":introduction]
        )
    }

}


protocol tableViewUpdater: class {
    
    func updateDiscTableView(post:Array<DataSetDocuments>)
    func updateCommentTableView(post:Array<DataSetsComments>)
}

protocol reflectUserNameDelegate {
    func reflectUserName(info:Array<UserInfo>)
}

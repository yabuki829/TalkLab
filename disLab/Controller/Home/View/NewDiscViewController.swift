//
//  NewViewController.swift
//  disLab
//
//  Created by Yabuki Shodai on 2021/08/10.
//

import UIKit
import XLPagerTabStrip
import FirebaseFirestore
import FirebaseAuth

//新しい投稿を表示するためのコントローラー

class NewDiscViewController: UIViewController {
  

    @IBOutlet weak var tableView: UITableView!
    var postArray = [DataSetDocuments]()
    var database = Firestore.firestore()
    var timeString = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "CustomTableViewCell", bundle: nil )
        tableView.register(nib, forCellReuseIdentifier: "CustomTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
//        投稿を取得する
        getDoc()
    }

}



extension NewDiscViewController {
    func getDoc(){
        let getDB = getDBModel(Type: "Post")
        getDB.delegate = self
        getDB.getDocument()
    }
    
}


extension NewDiscViewController : IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
           return IndicatorInfo(title: "新着")
       }
}

extension NewDiscViewController: UITableViewDelegate,UITableViewDataSource,tableViewUpdater{
    func updateDiscTableView(post: Array<DataSetDocuments>) {
        postArray = []
        postArray.append(contentsOf: post)
        tableView.reloadData()
    }
    
    func updateCommentTableView(post: Array<DataSetsComments>) {
        return
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        print("user名")
        print(postArray[indexPath.row].userName)
      
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

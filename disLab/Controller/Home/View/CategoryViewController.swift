//
//  CategoryViewController.swift
//  disLab
//
//  Created by Yabuki Shodai on 2021/09/18.
//

import UIKit

class CategoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var category = String()
    var postArray = [DataSetDocuments]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        self.navigationItem.title = category

               
                self.navigationController?.navigationBar.titleTextAttributes
                    = [NSAttributedString.Key.font: UIFont(name: "Times New Roman", size: 15)!]
        let nib = UINib(nibName: "CustomTableViewCell", bundle: nil )
        tableView.register(nib, forCellReuseIdentifier: "CustomTableViewCell")
        
        
        tableView.delegate = self
        tableView.dataSource = self
        getDocument()
        // Do any additional setup after loading the view.
    }
}

extension CategoryViewController{
    func getDocument(){
        print(category)
        let getDB = getDBModel(Type: category)
        getDB.delegate = self
        getDB.getDocument()
    }
}






extension CategoryViewController:UITableViewDelegate,UITableViewDataSource,tableViewUpdater{
        func updateDiscTableView(post: Array<DataSetDocuments>) {
            postArray = []
            postArray.append(contentsOf: post)
            print("-------------------------------")
            print(postArray)
            tableView.reloadData()
        }
        
        func updateCommentTableView(post: Array<DataSetsComments>) {}
        
        

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

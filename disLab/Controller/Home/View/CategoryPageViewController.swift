import UIKit
import XLPagerTabStrip
import FirebaseFirestore

//カテゴリーを検索するためのコントローラー


class CategoryPageViewController: UIViewController{
    
    @IBOutlet weak var uipicker: UIPickerView!
    @IBOutlet weak var tableview: UITableView!
    let category = ["芸能","社会","ビジネス","政治","法律","金融","企業","コンピューター","歴史","健康","恋愛","勉強","サイエンス","趣味","その他"]
    var selectedCategory = String()
    var postArray = [DataSetDocuments]()
    var database = Firestore.firestore()
    var name = String()
    override func viewDidLoad() {
           super.viewDidLoad()
        self.title = "Home"
        let nib = UINib(nibName: "CustomTableViewCell", bundle: nil )
        tableview.register(nib, forCellReuseIdentifier: "CustomTableViewCell")
        tableview.delegate = self
        tableview.dataSource = self
        
        uipicker.delegate = self
        uipicker.dataSource = self
       }
}
extension CategoryPageViewController:UITableViewDelegate,UITableViewDataSource,tableViewUpdater{
    func updateDiscTableView(post: Array<DataSetDocuments>) {
        postArray = []
        postArray.append(contentsOf: post)
        tableview.reloadData()
    }
    
    func updateCommentTableView(post: Array<DataSetsComments>) {}
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        
        cell.setCell(userName: postArray[indexPath.row].userName, title:  postArray[indexPath.row].title, date:  postArray[indexPath.row].createdAt , categry:  postArray[indexPath.row].category)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableview.deselectRow(at: indexPath, animated: true)
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

extension CategoryPageViewController : IndicatorInfoProvider {

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
           return IndicatorInfo(title: "カテゴリー")
    
       }
}



extension CategoryPageViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
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
        
        print(selectedCategory,"で検索します。")
        self.navigationItem.title = selectedCategory

        let getDB = getDBModel(Type: selectedCategory)
        getDB.delegate = self
        getDB.getDocument()
    }
}

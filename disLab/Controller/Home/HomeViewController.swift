//
//  HomeViewController.swift
//  disLab
//
//  Created by Yabuki Shodai on 2021/08/10.
//
import UIKit
import XLPagerTabStrip

class HomeViewController: ButtonBarPagerTabStripViewController {

    
    @IBOutlet weak var postButton: UIButton!
    override func viewDidLoad() {
        
        buttonUI()
        self.navigationController?.navigationBar.titleTextAttributes
            = [NSAttributedString.Key.font: UIFont(name: "Times New Roman", size: 15)!]
        super.viewDidLoad()
    }
    
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        //管理されるViewControllerを返す処理
        
        let NewVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "New")
        let categoryVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "categorypage")
        let childViewControllers:[UIViewController] = [NewVC, categoryVC]
        return childViewControllers
    }
    
    
    func buttonUI(){
        //投稿ボタン
        postButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        postButton.layer.shadowOpacity = 0.1
        postButton.layer.shadowRadius = 5.0
        
        // スライドで遷移できないようにしてる
        containerView.isScrollEnabled = true
        
        settings.style.buttonBarBackgroundColor = .systemGray6
        //ボタンの色
        settings.style.buttonBarItemBackgroundColor = .link
        //セルの文字色
        settings.style.buttonBarItemTitleColor = .white
        //セレクトバーの色
        //        settings.style.selectedBarBackgroundColor = .systemIndigo
        settings.style.selectedBarBackgroundColor = .systemIndigo
        // ButtonBarの左端の余白
        settings.style.buttonBarLeftContentInset = 5
        // ButtonBarの右端の余白
        settings.style.buttonBarRightContentInset = 5
        // Button間のスペース
        settings.style.buttonBarMinimumInteritemSpacing = 1
        
        settings.style.selectedBarHeight = 6.0
        settings.style.buttonBarMinimumLineSpacing = 10
        settings.style.buttonBarItemTitleColor = .white
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
      
       
        
    }

}


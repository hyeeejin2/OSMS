//
//  TabBarController.swift
//  osmsApp
//
//  Created by 김혜진 on 2022/03/16.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabBar()
    }
    
    func setTabBar() {
        //let vc1 = SearchViewController()
        let vc2 = MainViewController()
        let vc3 = MypageViewController()
        
        //let navigation1 = UINavigationController(rootViewController: vc1)
        let navigation2 = UINavigationController(rootViewController: vc2)
        let navigation3 = UINavigationController(rootViewController: vc3)
        
        //vc1.title = "작업장 검색"
        vc2.title = "메인화면"
        vc3.title = "마이페이지"
        
        //vc1.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc2.tabBarItem.image = UIImage(systemName: "house")
        vc3.tabBarItem.image = UIImage(systemName: "person")
        
        //vc1.tabBarItem.tag = 0
        vc2.tabBarItem.tag = 1
        vc3.tabBarItem.tag = 2
        
        setViewControllers([navigation2, navigation3], animated: false)
        self.selectedIndex = 0
    }
}

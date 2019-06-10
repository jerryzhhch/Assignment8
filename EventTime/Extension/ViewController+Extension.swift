//
//  ViewController+Extension.swift
//  EventTime
//
//  Created by mac on 6/5/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func goToWeb(with nav: UINavigationController, for attr: Attraction) {
        
        let storyboard = UIStoryboard(name: "Web", bundle: Bundle.main)
        let webVC = storyboard.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        webVC.attr = attr
        webVC.hidesBottomBarWhenPushed = true
        nav.pushViewController(webVC, animated: true)
    }
    
    
    func goToHome() -> UITabBarController  {
        
        let storyboard = UIStoryboard(name: "Login", bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: "MainTabController") as! UITabBarController
    }
    
    
}

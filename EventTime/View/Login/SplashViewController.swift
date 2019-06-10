//
//  SplashViewController.swift
//  EventTime
//
//  Created by mac on 6/6/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import FirebaseAuth

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        if Auth.auth().currentUser != nil {
            
            let tab = goToHome()
            appDelegate.window?.rootViewController = tab
            
        } else {
            
            let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            appDelegate.window?.rootViewController = loginVC
            
        }
    }
    


}

//
//  LoginViewController.swift
//  EventTime
//
//  Created by mac on 6/6/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import GoogleSignIn
import FirebaseAuth
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var googleButton: GIDSignInButton!
    @IBOutlet weak var facebookButton: FBLoginButton!
    
    let images = [Int](0...Constants.Values.imageCount.rawValue).map({String($0)})
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLogin()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupScrollView()
    }
    
    @IBAction func prevButtonTapped(_ sender: UIButton) {
        guard pageControl.currentPage >= 0 else {
            return
        }
        
        pageControl.currentPage -= 1
        
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        
        scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
        
        scrollView.layoutIfNeeded()
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        guard pageControl.currentPage <= images.count - 1 else {
            return
        }
        
        pageControl.currentPage += 1
        
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        
        scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
        
        scrollView.layoutIfNeeded()
    }
    
    @IBAction func googleButtonTapped(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func facebookButtonTapped(_ sender: UIButton) {
    }
    
    //MARK: Helper
    
    func dismissTab(_ tabController: UITabBarController) {
        tabController.dismiss(animated: true, completion: nil)
        print("Dismissed TabBarController")
    }
    
    //MARK: Setup
    
    func setupScrollView() {
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(images.count), height: scrollView.frame.size.height)
        
        for number in 0..<images.count {
            
            frame.origin.x = scrollView.frame.size.width * CGFloat(number)
            
            frame.size = scrollView.frame.size
            
            let imageView = UIImageView(frame: frame)
            imageView.image = UIImage(named: images[number])
            
            scrollView.addSubview(imageView)
        }
    }
    
    func setupLogin() {
        pageControl.numberOfPages = images.count
        scrollView.delegate = self
        googleButton.layer.cornerRadius = googleButton.layer.frame.height / 2
        facebookButton.layer.cornerRadius = googleButton.layer.frame.height / 2
        
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.delegate = self
        
//        let fbButton = FBLoginButton()
//        view.addSubview(fbButton)
//        fbButton.frame = CGRect(x: 90, y: view.frame.maxY - 200, width: 230, height: 40)
//        fbButton.delegate = self
//        fbButton.layer.cornerRadius = googleButton.layer.frame.height / 2
        
        facebookButton.frame = CGRect(x: 90, y: 607, width: 195, height: 40)
        facebookButton.delegate = self
    }
    
}

//MARK: GoogleDelegate

extension LoginViewController: GIDSignInUIDelegate, GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        //First check if user signs in Google successfully
        if let err = error {
            print("Error Signing in: \(err.localizedDescription)")
            return
        }
        
        guard let authentication = user.authentication else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        //If so, sign user in with credential from Google to Firebase
        Auth.auth().signIn(with: credential) { [unowned self] (result, err) in
            if let err = error {
                print("Error Signing in: \(err.localizedDescription)")
                return
            }
            
            if let auth = result {
                print("Successful SignIn: \(auth.user.uid)")
                let tab = self.goToHome()
                self.present(tab, animated: true, completion: nil)
            }
        }
    }
    
}

// MARK: Facebook Login
extension LoginViewController: LoginButtonDelegate {
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("Did log out Facebook")
    }
    
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let err = error {
            print("Error Signing in: \(err.localizedDescription)")
            return
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        
        Auth.auth().signIn(with: credential) { [unowned self] (authResult, error) in
            if let err = error {
                print("Error Signing in: \(err.localizedDescription)")
                return
            }
            // User is signed in
            if let auth = authResult {
                print("Successful login Facebook: \(auth.user.uid)")
                let tab = self.goToHome()
                self.present(tab, animated: true, completion: nil)
            }
        }
    }
}

//MARK: ScrollView
extension LoginViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }
}

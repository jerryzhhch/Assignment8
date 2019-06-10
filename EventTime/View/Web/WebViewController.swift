//
//  WebViewController.swift
//  EventTime
//
//  Created by mac on 6/5/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var webView = WKWebView()
    var attr: Attraction!
    
    override func loadView() {
        super.loadView()
        
        view = webView
        webView.addSubview(loadingView)
        webView.bringSubviewToFront(loadingView)
        
        setConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupWeb()
        
    }
    
    private func setConstraints() {
        
        loadingView.centerYAnchor.constraint(equalTo: webView.centerYAnchor).isActive = true
        loadingView.centerXAnchor.constraint(equalTo: webView.centerXAnchor).isActive = true
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    private func setupWeb() {
        
        activityIndicator.startAnimating()
        
        loadingView.layer.cornerRadius = 25
        
        webView.navigationDelegate = self
        
        if let url = URL(string: attr.url) {
            let reqeust = URLRequest(url: url)
            webView.load(reqeust)
        }
        
        
    }

}


extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
        loadingView.isHidden = true
    }
    
}

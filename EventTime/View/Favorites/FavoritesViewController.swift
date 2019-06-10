//
//  FavoritesViewController.swift
//  EventTime
//
//  Created by mac on 6/5/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import FirebaseAuth

class FavoritesViewController: UIViewController {

    @IBOutlet weak var favoritesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupFavorites()
        createFavoriteObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FireModel.getFire()
    }
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        favoritesTableView.isEditing.toggle()
    }
    
    @IBAction func signOutTapped(_ sender: UIBarButtonItem) {
        
        do {
            try Auth.auth().signOut()
            let storyboard = UIStoryboard(name: "Login", bundle: Bundle.main)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            loginVC.dismissTab(tabBarController!)
            present(loginVC, animated: true, completion: nil)
            
        } catch {
            print("Couldn't sign out Firebase")
        }
    }
    
    
    
    //MARK: Setup
    
    func setupFavorites() {
        
        favoritesTableView.register(UINib(nibName: SearchTableCellTwo.identifier, bundle: Bundle.main), forCellReuseIdentifier: SearchTableCellTwo.identifier)
        favoritesTableView.tableFooterView = .init(frame: .zero)
    }
    
    func createFavoriteObserver() {
        
        NotificationCenter.default.addObserver(forName: Notification.Name.FireNotification, object: nil, queue: .main) { [unowned self] _ in
            self.favoritesTableView.reloadData()
        }
    }

}

//MARK: TableView
extension FavoritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FireModel.favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableCellTwo.identifier, for: indexPath) as! SearchTableCellTwo
        
        let attrs = FireModel.favorites[indexPath.row]
        cell.searchFavoriteButton.isHidden = true
        cell.configure(with: attrs)
        
        return cell
    }
}


extension FavoritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let attr = FireModel.favorites[indexPath.row]
        goToWeb(with: navigationController!, for: attr)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let attr = FireModel.favorites[indexPath.row]
            Fire.remove(attr)
            FireModel.favorites.remove(at: indexPath.row)
            FireModel.favoritesID.remove(attr.id)
        default:
            break
        }
        
    }
    
}

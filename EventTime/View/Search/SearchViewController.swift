//
//  ViewController.swift
//  EventTime
//
//  Created by mac on 6/4/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    
    @IBOutlet weak var searchTableView: UITableView!
    
    let viewModel = ViewModel()
    var shouldReloadCollection = false
    let searchController = UISearchController(searchResultsController: nil)
    let favoriteImage = #imageLiteral(resourceName: "star").withRenderingMode(.alwaysTemplate)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearch()
        createSearchBar()
        addSearchObserver()
        viewModel.get()
        FireModel.getFire()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    
    //MARK: Favorite Functionality
    
    @objc func favoritesTapped(sender: UIButton) {
        
        let attr = isFiltering ? viewModel.filteredAttractions[sender.tag] : viewModel.attractions[sender.tag]
        
        let state = sender.tintColor == .gold ? true : false
        sender.isSelected = !state
        
        switch sender.isSelected {
        case true:
            Fire.save(attr)
            sender.tintColor = .gold
            FireModel.favoritesID.insert(attr.id)
        case false:
            Fire.remove(attr)
            sender.tintColor = .lightGray
            FireModel.favoritesID.remove(attr.id)
        }
    }
    
    func addSearchObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: Notification.Name.FireNotification, object: nil)
        
    }
    
    //MARK: Search Functionality
    
    private func createSearchBar() {
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
    }
    
    private func filterAttractions(with search: String) {
        
        viewModel.filteredAttractions = viewModel.attractions.filter({$0.name.lowercased().contains(search.lowercased()) || $0.classifications.first!.genre.name.lowercased().contains(search.lowercased())})
        
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    //MARK: Setup
    
    private func setupSearch() {
        
        searchTableView.register(UINib(nibName: SearchTableCellTwo.identifier, bundle: Bundle.main), forCellReuseIdentifier: SearchTableCellTwo.identifier)
        searchTableView.tableFooterView = .init(frame: .zero)
        viewModel.delegate = self
        definesPresentationContext = true
    }


}

//MARK: TableView

extension SearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let attrs = isFiltering ? viewModel.filteredAttractions.count : viewModel.attractions.count
        return section == 0 ? 1 : attrs
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableCellOne.identifier, for: indexPath) as! SearchTableCellOne
           
            if shouldReloadCollection {
                cell.searchCollectionView.reloadData()
                shouldReloadCollection = false
            }
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableCellTwo.identifier, for: indexPath) as! SearchTableCellTwo
            
            let attr = isFiltering ? viewModel.filteredAttractions[indexPath.row] : viewModel.attractions[indexPath.row]
            
            cell.searchFavoriteButton.addTarget(self, action: #selector(favoritesTapped(sender:)), for: .touchUpInside)
            cell.searchFavoriteButton.tag = indexPath.row
            cell.searchFavoriteButton.tintColor = FireModel.favoritesID.contains(attr.id) ? .gold : .lightGray
            cell.searchFavoriteButton.setImage(favoriteImage, for: .normal)
            
            
            cell.configure(with: attr)
            
            return cell
        }
    }
    
}


extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 120 : 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let attr = isFiltering ? viewModel.filteredAttractions[indexPath.row] : viewModel.attractions[indexPath.row]
        
        goToWeb(with: navigationController!, for: attr)
        
    }
}




//MARK: CollectionView

extension SearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isFiltering ? viewModel.filteredAttractions.count : viewModel.attractions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionCell.identifier, for: indexPath) as! SearchCollectionCell
        
        
        let attr = isFiltering ? viewModel.filteredAttractions[indexPath.row] : viewModel.attractions[indexPath.row]
        cell.configure(with: attr)
        
        return cell
    }
    
    

}


extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 112, height: 122)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let index = IndexPath(row: indexPath.row, section: 1)
        searchTableView.scrollToRow(at: index, at: .top, animated: true)
    }
}

//MARK: ViewModelDelegate

extension SearchViewController: ViewModelDelegate {
    
    @objc func update() {
        DispatchQueue.main.async {
            self.shouldReloadCollection = true
            self.searchTableView.reloadData()
        }
    }
}


//MARK: UISearchBarDelegate

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let search = searchController.searchBar.text else {
            return
        }
        filterAttractions(with: search)
    }
}

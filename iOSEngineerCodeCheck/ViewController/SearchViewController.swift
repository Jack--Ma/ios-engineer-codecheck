//
//  SearchViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit
import Alamofire

/// User could search github repo name and get result in this page
class SearchViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchWord: String?
    var listModel: SearchListModel?
    var selectedIndex: Int = -1
    
    lazy var networkManager: SearchNetworkManager = {
        return SearchNetworkManager()
    }()
    
    private var repoModels: [SearchRepoModel] {
        if let listModel = listModel {
            return listModel.repoModels
        } else {
            return []
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Repo Search"
        
        // Setup searchBar
        searchBar.placeholder = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail"{
            // Setup search detail vc
            if let searchDetailVC = segue.destination as? SearchDetailViewController {
                let selectedRepoModel = repoModels.safeObject(at: selectedIndex)
                searchDetailVC.repoModel = selectedRepoModel
            }
        }
    }
}

// MARK: UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Cancel request task when user changed search word
        networkManager.cancelRequest()
        // Clear data when search word is empty
        if searchText.isEmpty {
            // Avoid repeated reload
            if !repoModels.isEmpty {
                listModel = nil
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Network reachability check
        if NetworkReachabilityManager()?.isReachable == false {
            Toast.show("Network not connected!", inView: self.view)
            return
        }
        if searchWord == searchBar.text {
            return
        }
        // Begin search request after user click search button
        searchWord = searchBar.text
        weak var weakSelf = self
        networkManager.requestSearchList(searchWord) { listModel, error in
            guard let weakSelf = weakSelf else { return }
            if let error = error {
                Toast.show("Search Failed!", inView: self.view)
                // Monitor request error
                assert(false, "Request search list failed, error: \(error)")
            } else {
                weakSelf.listModel = listModel
                // Must reload tableView in main queue
                DispatchQueue.main.async {
                    weakSelf.tableView.reloadData()
                }
            }
        }
    }
}

// MARK: UITableView
let cellIdentifier: String = "cellIdentifier"
extension SearchViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repoModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Refresh tableView cell
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: cellIdentifier)
        }
        if let repoModel = repoModels.safeObject(at: indexPath.row) {
            cell?.textLabel?.text = repoModel.fullName
            cell?.detailTextLabel?.text = repoModel.language
        }
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // User selected tableView cell, and jump to detailVC
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)
    }
}

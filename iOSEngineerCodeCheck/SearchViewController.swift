//
//  SearchViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

/// User could search github repo name and get result in this page
class SearchViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchWord: String?
    var searchTask: URLSessionTask?
    var searchResult: [[String: Any]] = []
    var selectedIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup searchBar
        searchBar.placeholder = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail"{
            // Setup search detail vc
            if let searchDetailVC = segue.destination as? SearchDetailViewController {
                searchDetailVC.searchVC = self
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
        searchTask?.cancel()
        // Clear data when search word is empty
        if searchText.isEmpty {
            // Avoid repeated reload
            if self.searchResult.isEmpty {
                return
            }
            self.searchResult = []
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // TODO: Add no network toast
        // Begin search request after user click search button
        searchWord = searchBar.text
        guard let searchWord = searchWord else {
            return
        }
        if searchWord.count != 0 {
            // Build request URL
            let searchRequestURLString = "https://api.github.com/search/repositories?q=\(searchWord)"
            // Encode url string in case of japanese or chinese
            let encodingURLString = searchRequestURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            guard let encodingURLString = encodingURLString else { return }
            let searchRequestURL = URL(string: encodingURLString)
            guard let searchRequestURL = searchRequestURL else { return }
            
            searchTask = URLSession.shared.dataTask(with: searchRequestURL) { (data, res, err) in
                // From Data to Json Dictionary
                guard let data = data else { return }
                
                if let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    if let items = obj["items"] as? [[String: Any]] {
                        self.searchResult = items
                        // Must reload tableView in main queue
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                } else {
                    // TODO: Add error toast
                    // Monitor parsing error
                    assert(false, "JSON Serialization Failed!")
                }
            }
            // Must call task's resume method in order to start request
            searchTask?.resume()
        }
    }
}

// MARK: UITableView
extension SearchViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Refresh tableView cell
        let cell = UITableViewCell()
        let repo = searchResult[indexPath.row]
        if let textLabel = cell.textLabel {
            textLabel.text = repo["full_name"] as? String ?? ""
        }
        if let detailTextLabel = cell.detailTextLabel {
            detailTextLabel.text = repo["language"] as? String ?? ""
        }
        cell.tag = indexPath.row
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // User selected tableView cell, and jump to detailVC
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)
    }
}

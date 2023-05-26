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
    
    var searchWord: String!
    var searchTask: URLSessionTask?
    var searchResult: [[String: Any]] = []
    var selectedIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup searchBar
        searchBar.text = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail"{
            // Setup search detail vc
            let searchDetailVC = segue.destination as! SearchDetailViewController
            searchDetailVC.searchVC = self
        }
    }
}

// MARK: UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // Reset search bar when user begin editing
        searchBar.text = ""
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Cancel request task when user changed search words
        searchTask?.cancel()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Begin search request after user click search button
        searchWord = searchBar.text!
        if searchWord.count != 0 {
            let searchRequestURLString = "https://api.github.com/search/repositories?q=\(searchWord!)"
            searchTask = URLSession.shared.dataTask(with: URL(string: searchRequestURLString)!) { (data, res, err) in
                // From Data to Json Dictionary
                if let obj = try! JSONSerialization.jsonObject(with: data!) as? [String: Any] {
                    if let items = obj["items"] as? [[String: Any]] {
                        self.searchResult = items
                        // Must reload tableView in main queue
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
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
        cell.textLabel?.text = repo["full_name"] as? String ?? ""
        cell.detailTextLabel?.text = repo["language"] as? String ?? ""
        cell.tag = indexPath.row
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // User selected tableView cell, and jump to detailVC
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)
    }
}

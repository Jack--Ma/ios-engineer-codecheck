//
//  SearchDetailViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

/// User could check up repo detail information in this page
class SearchDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var starsCountLabel: UILabel!
    @IBOutlet weak var watchersCountLabel: UILabel!
    @IBOutlet weak var forksCountLabel: UILabel!
    @IBOutlet weak var openIssuesCountLabel: UILabel!
    
    var searchVC: SearchViewController?
    var repo: [String:Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init repo
        guard let searchVC = searchVC else { return }
        guard let selectedIndex = searchVC.selectedIndex else { return }
        if selectedIndex < 0 || selectedIndex >= searchVC.searchResult.count {
            return
        }
        repo = searchVC.searchResult[selectedIndex]
        guard let repo = repo else { return }
        
        // Setup label
        titleLabel.text = repo["full_name"] as? String
        languageLabel.text = "Written in \(repo["language"] as? String ?? "")"
        starsCountLabel.text = "\(repo["stargazers_count"] as? Int ?? 0) stars"
        // TODO: key is "watchers" not "wachers_count"
        watchersCountLabel.text = "\(repo["wachers_count"] as? Int ?? 0) watchers"
        forksCountLabel.text = "\(repo["forks_count"] as? Int ?? 0) forks"
        openIssuesCountLabel.text = "\(repo["open_issues_count"] as? Int ?? 0) open issues"
        
        // Setup imageView
        getImage()
    }
    
    func getImage(){
        guard let repo = repo else { return }
        
        // Request image data
        if let owner = repo["owner"] as? [String: Any] {
            if let imgURLString = owner["avatar_url"] as? String {
                // Build image URL
                let imgURL = URL(string: imgURLString)
                guard let imgURL = imgURL else { return }
                
                URLSession.shared.dataTask(with: imgURL) { (data, res, err) in
                    if let data = data {
                        let img = UIImage(data: data)
                        // Setup imageView's image in main queue
                        DispatchQueue.main.async {
                            self.imageView.image = img
                        }
                    }
                }.resume()
            }
        }
    }
    
}

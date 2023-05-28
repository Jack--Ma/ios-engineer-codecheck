//
//  SearchDetailViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit
import AlamofireImage

/// User could check up repo detail information in this page
class SearchDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var starsCountLabel: UILabel!
    @IBOutlet weak var watchersCountLabel: UILabel!
    @IBOutlet weak var forksCountLabel: UILabel!
    @IBOutlet weak var openIssuesCountLabel: UILabel!
    
    var repoModel: SearchRepoModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let repo = repoModel else { return }
        
        // Setup label
        titleLabel.text = repo.fullName
        languageLabel.text = "Written in \(repo.language ?? "")"
        starsCountLabel.text = "\(repo.starsCount) stars"
        watchersCountLabel.text = "\(repo.watchersCount) watchers"
        forksCountLabel.text = "\(repo.forksCount) forks"
        openIssuesCountLabel.text = "\(repo.openIssuesCount) open issues"
        
        setupImageView()
    }
    
    /// Setup imageView
    func setupImageView() {
        guard let repo = repoModel else { return }
        
        if let owner = repo.owner, let avatarURLString = owner.avatarURLString {
            // Build image URL
            let imgURL = URL(string: avatarURLString)
            guard let imgURL = imgURL else { return }
            self.imageView.af.setImage(withURL: imgURL)
        }
    }
}

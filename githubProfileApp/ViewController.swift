//
//  ViewController.swift
//  githubProfileApp
//
//  Created by TaeOuk Hwang on 4/9/24.
//

import UIKit
import Alamofire
import SDWebImage

class ViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var repositoriesTableView: UITableView!
    
    var repositories: [GitHubRepository] = []
    let username = "al45tair" //Tae-Ouk -> 내꺼!
    
    let refreshControl = UIRefreshControl()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        repositoriesTableView.register(UITableViewCell.self, forCellReuseIdentifier: "RepositoryCell")
        repositoriesTableView.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        repositoriesTableView.refreshControl = refreshControl
        
        fetchGitHubProfile(username)
        fetchGitHubRepositories(username)
    }
    
    
    func fetchGitHubProfile(_ username: String) {
        let profileURL = "https://api.github.com/users/\(username)"
        
        AF.request(profileURL).responseDecodable(of: GitHubUser.self) { response in
            guard let user = response.value else {
                print("Error")
                return
            }
            
            self.nameLabel.text = user.name ?? user.login
            self.followersLabel.text = "Followers: \(user.followers)"
            self.followingLabel.text = "Following: \(user.following)"
            
            if let avatarURL = URL(string: user.avatarURL) {
                self.profileImageView.sd_setImage(with: avatarURL, completed: nil)
            }
        }
    }
    
    
    func fetchGitHubRepositories(_ username: String) {
        let repositoriesURL = "https://api.github.com/users/\(username)/repos"
        
        AF.request(repositoriesURL).responseDecodable(of: [GitHubRepository].self) { response in
            guard let repositories = response.value else {
                print("Error")
                return
            }
            
            self.repositories = repositories
            self.repositoriesTableView.reloadData()
        }
    }
    
    
    @objc func refreshData() {
        fetchGitHubRepositories(username)
    }
}


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell", for: indexPath)
        let repository = repositories[indexPath.row]
        cell.textLabel?.text = repository.name
        cell.detailTextLabel?.text = repository.description
        return cell
    }
}






struct GitHubUser: Decodable {
    let login: String
    let name: String?
    let followers: Int
    let following: Int
    let avatarURL: String

    enum CodingKeys: String, CodingKey {
        case login, name, followers, following
        case avatarURL = "avatar_url"
    }
}


struct GitHubRepository: Decodable {
    let name: String
    let description: String?

    enum CodingKeys: String, CodingKey {
        case name
        case description
    }
}

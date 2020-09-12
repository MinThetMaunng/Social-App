//
//  HomeController.swift
//  Social App
//
//  Created by Min Thet Maung on 06/09/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import UIKit
import LBTATools
import Alamofire

class HomeController: UITableViewController {
    
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = .init(title: "Login", style: .plain, target: self, action: #selector(handleLogin))
        navigationItem.rightBarButtonItem = .init(title: "Fetch posts", style: .plain, target: self, action: #selector(fetchPosts))
    }
    
    @objc private func handleLogin() {
        let navController = UINavigationController(rootViewController: LoginController())
        present(navController, animated: true)
    }
    
    @objc private func fetchPosts() {
        
        guard let token = AuthService.shared.jwtToken else { return }
        guard let url = URL(string: "\(baseUrl)/posts/") else { return }
        let headers = HTTPHeaders(arrayLiteral: HTTPHeader(name: "Content-Type", value: "application/json"), HTTPHeader(name: "Authorization", value: token))
        
        AF.request(url, headers: headers)
            .validate(statusCode: 200..<300)
            .responseData { (resp) in
                if let err = resp.error {
                    print("Failed to fetch posts : \(err)")
                }
                
                guard let data = resp.data else { return }
                do {
                    let fetchedPostsResponse = try JSONDecoder().decode(FetchedPostsResponse.self, from: data)
                    self.posts = fetchedPostsResponse.data ?? self.posts
                    self.tableView.reloadData()
                } catch (let err) {
                    fatalError("Error in decoding fetch posts : \(err.localizedDescription)")
                }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let post = posts[indexPath.row]
        
        cell.textLabel?.text = post.user.fullName
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        cell.detailTextLabel?.text = post.text
        cell.detailTextLabel?.numberOfLines = 0
        return cell
    }
    
}

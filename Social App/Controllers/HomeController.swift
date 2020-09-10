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
        
        guard let url = URL(string: "\(baseUrl)/posts/") else { return }
        let headers = HTTPHeaders(arrayLiteral: HTTPHeader(name: "Content-Type", value: "application/json"), HTTPHeader(name: "Authorization", value: "\(AuthService.shared.jwtToken)"))
        
        AF.request(url, headers: headers)
            .validate(statusCode: 200..<300)
            .responseData { (resp) in
                if let err = resp.error {
                    print("Failed to fetch posts : \(err)")
                }
                
                guard let data = resp.data else { return }
                do {
                    let fetchedPostsResponse = try JSONDecoder().decode(FetchedPostsResponse.self, from: data)
                    let posts = fetchedPostsResponse.data
                    print(posts?.first!.text)
                } catch (let err) {
                    fatalError("Error in decoding fetch posts : \(err.localizedDescription)")
                }
        }

    }
    
}

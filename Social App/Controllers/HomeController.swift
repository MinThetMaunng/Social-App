//
//  HomeController.swift
//  Social App
//
//  Created by Min Thet Maung on 06/09/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import UIKit
import LBTATools

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
        
        guard let url = URL(string: "https://socialappnode.herokuapp.com/posts/") else { return }
        var request = URLRequest(url: url)
        request.setValue("\(AuthService.shared.jwtToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { (data, resp, err) in
            
            DispatchQueue.main.async {
                if let err = err {
                    print("Error in getting posts : \(err)")
                    return
                } else if let resp = resp as? HTTPURLResponse, resp.statusCode != 200 {
                    print("Failed to fetch with status code \(resp.statusCode)")
                } else {
                    print("Sucessfully fetched posts")
                    print(data)
                }
                
            }
            
        }.resume()
    }
    
}

//
//  HomeController.swift
//  Social App
//
//  Created by Min Thet Maung on 06/09/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import UIKit
import LBTATools

class HomeController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = .init(title: "Fetch posts", style: .done, target: self, action: #selector(fetchPosts))
    }
    
    @objc private func fetchPosts() {
        print("Attempting to fetch posts")
    }
    
}

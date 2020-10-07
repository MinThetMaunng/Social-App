//
//  ProfileController.swift
//  Social App
//
//  Created by Min Thet Maung on 07/10/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import LBTATools

class UserPostCell: LBTAListCell<Post> {
    override var item: Post! {
        didSet {
            backgroundColor = .yellow
        }
    }
}

class ProfileController: LBTAListController<UserPostCell, Post> {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
    }
    
    private func fetchUserProfile() {
    }
}

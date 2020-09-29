//
//  UsersSearchController.swift
//  Social App
//
//  Created by Min Thet Maung on 25/09/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import LBTATools

class UsersSearchController: LBTAListController<UserSearchCell, User> {
//    var users = [User]()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        collectionView.backgroundColor = .white
        navigationItem.title = "Search"
        
        collectionView.register(UserSearchCell.self, forCellWithReuseIdentifier: "cellId")
        UserService.shared.searchUser(keyword: "M") { (result) in
            switch result {
            case .success(let resp):
                if let users = resp.data {
                    
                    self.items = users
                    self.collectionView.reloadData()
                }
            case .failure(let err):
                print("Error in searching users: \(err.localizedDescription)")
            }
        }
    }
}

extension UsersSearchController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}

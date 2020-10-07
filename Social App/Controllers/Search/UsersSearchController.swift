//
//  UsersSearchController.swift
//  Social App
//
//  Created by Min Thet Maung on 25/09/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import LBTATools

class UsersSearchController: LBTAListController<UserSearchCell, User> {
    
    let searchController: UISearchController = {
        let sc = UISearchController()
        sc.automaticallyShowsCancelButton = true
        sc.hidesNavigationBarDuringPresentation = false
        return sc
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        collectionView.backgroundColor = .white
        searchController.searchBar.delegate = self
        setupNavigationBar()
        collectionView.register(UserSearchCell.self, forCellWithReuseIdentifier: "cellId")
    }

    fileprivate func setupNavigationBar() {
        navigationItem.titleView = searchController.searchBar
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .systemBlue
        
        navigationController?.navigationBar.setupShadow(opacity: 0.5, radius: 2, offset: CGSize(width: 0, height: 0.5), color: .lightGray)
    }
}


// MARK: - UICollectionViewDelegateFlowLayout
extension UsersSearchController: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = ProfileController()
        navigationController?.pushViewController(controller, animated: true)
    }
}


// MARK: - UISearchBarDelegate
extension UsersSearchController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text else { return }
        
        UserService.shared.searchUser(keyword: keyword) { (result) in
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}

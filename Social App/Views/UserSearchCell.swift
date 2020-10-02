//
//  UserSearchCell.swift
//  Social App
//
//  Created by Min Thet Maung on 25/09/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import LBTATools

extension UsersSearchController {
    
    func followUser(user: User) {
        guard let index = self.items.firstIndex(where: {$0._id == user._id}) else { return }
        
        UserService.shared.followUser(userId: user._id) { (result) in
            switch result {
            case .success(let resp):
                let follow = (resp.data != nil) ? true : false
                self.items[index].isFollowing = follow
                self.collectionView.reloadItems(at: [[0, index]])
               
            case .failure(let err):
                fatalError("Error in follow user : \(err)")
            }
        }
    }
}

class UserSearchCell: LBTAListCell<User> {
    
    let nameLabel = UILabel(text: "Full Name", font: .boldSystemFont(ofSize: 16), textColor: .black)
    lazy var followButton = UIButton(title: "Follow", titleColor: .black, font: .boldSystemFont(ofSize: 14), backgroundColor: .white, target: self, action: #selector(handleFollow))
    
    @objc private func handleFollow() {
        (parentController as? UsersSearchController)?.followUser(user: item)
    }
    
    override var item: User! {
        didSet {
            nameLabel.text = item.fullName
            if item.isFollowing == true {
                followButton.backgroundColor = .black
                followButton.setTitle("Unfollow", for: .normal)
                followButton.setTitleColor(.white, for: .normal)
            } else {
                followButton.backgroundColor = .white
                followButton.setTitle("Follow", for: .normal)
                followButton.setTitleColor(.black, for: .normal)
            }
        }
    }
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = .white
        
        followButton.layer.cornerRadius = 17
        followButton.layer.borderWidth = 1
        
        hstack(nameLabel,
               UIView(),
               followButton.withWidth(100).withHeight(34),
               alignment: .center)
            .padLeft(24).padRight(24)
        
        addSeparatorView(leadingAnchor: nameLabel.leadingAnchor)
    }
}

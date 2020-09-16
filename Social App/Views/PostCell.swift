//
//  PostCell.swift
//  Social App
//
//  Created by Min Thet Maung on 16/09/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import LBTATools

class PostCell: UITableViewCell {
    
    let fullNameLabel = UILabel(text: "User Name", font: .boldSystemFont(ofSize: 15))
    let postImageView = UIImageView(image: nil, contentMode: .scaleAspectFill)
    let postTextLabel = UILabel(text: "This is post text which is very long that goes to multiple lines.", font: .systemFont(ofSize: 15), numberOfLines: 0)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        postImageView.heightAnchor.constraint(equalTo: postImageView.widthAnchor).isActive = true
        stack(stack(fullNameLabel).padLeft(16),
              postImageView,
              stack(postTextLabel).padLeft(16).padRight(16),
              spacing: 16).withMargins(.init(top: 16, left: 0, bottom: 16, right: 0))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

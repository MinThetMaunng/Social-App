//
//  PostCell.swift
//  Social App
//
//  Created by Min Thet Maung on 16/09/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import LBTATools
import JGProgressHUD

protocol PostCellOptionsDelegate: class {
    func handlePostOptions(cell: PostCell)
}

extension HomeController: PostCellOptionsDelegate {
    
    
    fileprivate func sentDeletePostRequest(postId: String, indexPath: IndexPath) {
        PostService.shared.deletePost(postId: postId) { (result) in
            switch result {
            case .success(let resp):
                self.posts.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                print(resp)
            case .failure(let err):
                print(err.localizedDescription)
            }
            self.deleteHud.dismiss(animated: true)
        }
    }
    
    func handlePostOptions(cell: PostCell) {
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let post = self.posts[indexPath.row]
        
        let alert = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete Post", style: .destructive) { (_) in
            self.deleteHud.show(in: self.view)
            self.sentDeletePostRequest(postId: post._id, indexPath: indexPath)
        }
        let cancleAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.dismiss(animated: true)
        }
        
        [deleteAction, cancleAction].forEach{ alert.addAction($0) }
        present(alert, animated: true)

    }
}


class PostCell: UITableViewCell {
    
    let fullNameLabel = UILabel(text: "User Name", font: .boldSystemFont(ofSize: 15))
    let postImageView = UIImageView(image: nil, contentMode: .scaleAspectFill)
    let postTextLabel = UILabel(text: "This is post text which is very long that goes to multiple lines.", font: .systemFont(ofSize: 15), numberOfLines: 0)
    lazy var optionsButton = UIButton(image: #imageLiteral(resourceName: "post_options"), tintColor: .black, target: self, action: #selector(handleOptions))
    
    var delegate: PostCellOptionsDelegate?
    
    @objc private func handleOptions() {
        delegate?.handlePostOptions(cell: self)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.isUserInteractionEnabled = false
        postImageView.heightAnchor.constraint(equalTo: postImageView.widthAnchor).isActive = true
        stack(hstack(fullNameLabel,
                     UIView(),
                     optionsButton.withWidth(34))
                .padLeft(16).padRight(16),
              postImageView,
              stack(postTextLabel).padLeft(16).padRight(16),
              spacing: 16).withMargins(.init(top: 16, left: 0, bottom: 16, right: 0))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

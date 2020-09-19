//
//  HomeController.swift
//  Social App
//
//  Created by Min Thet Maung on 06/09/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import UIKit
import LBTATools
import JGProgressHUD
import SDWebImage

class HomeController: UITableViewController {
    lazy var deleteHud: JGProgressHUD = {
        let h = JGProgressHUD(style: .dark)
        h.textLabel.text = "Deleting"
        return h
    }()
    var posts = [Post]()

    fileprivate func setupNavigationBarItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Login", style: .plain, target: self, action: #selector(handleLogin))
        navigationItem.rightBarButtonItems = [.init(title: "Fetch posts", style: .plain, target: self, action: #selector(fetchPosts)), .init(title: "Create post", style: .plain, target: self, action: #selector(createPost)) ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        tableView.allowsSelection = false
        setupNavigationBarItems()
        fetchPosts()
    }
    
    @objc private func handleLogin() {
        let navController = UINavigationController(rootViewController: LoginController())
        present(navController, animated: true)
    }
    
    @objc func fetchPosts() {
        PostService.shared.fetchPosts { (result) in
            switch result {
            case .success(let resp):
                self.posts = resp.data ?? self.posts
                self.tableView.reloadData()
            case .failure(let err):
                fatalError("Error in decoding fetch posts : \(err.localizedDescription)")
            }
        }
    }
    
    @objc private func createPost() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = PostCell(style: .subtitle, reuseIdentifier: nil)
        let post = posts[indexPath.row]
        
        cell.fullNameLabel.text = post.user.fullName
        cell.postTextLabel.text = post.text
    
        cell.delegate = self
        if let imageUrl = post.imageUrl {
            cell.postImageView.sd_setImage(with: URL(string: imageUrl))
        }
        if post.user._id != AuthService.shared.currentUserId {
            cell.optionsButton.isHidden = true
        }
        return cell
    }
    
}


// MARK: - UIImagePickerControllerDelegate
extension HomeController:  UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        
        dismiss(animated: true) {
            let createPostController = CreatePostController(selectedImage: image)
            createPostController.homeController = self
            self.present(createPostController, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

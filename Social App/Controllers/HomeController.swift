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
import SDWebImage

class HomeController: UITableViewController {
    
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = .init(title: "Login", style: .plain, target: self, action: #selector(handleLogin))
        navigationItem.rightBarButtonItems = [.init(title: "Fetch posts", style: .plain, target: self, action: #selector(fetchPosts)), .init(title: "Create post", style: .plain, target: self, action: #selector(createPost)) ]
    }
    
    @objc private func handleLogin() {
        let navController = UINavigationController(rootViewController: LoginController())
        present(navController, animated: true)
    }
    
    @objc private func fetchPosts() {
        
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
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let post = posts[indexPath.row]
        
        cell.textLabel?.text = post.user.fullName
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        cell.detailTextLabel?.text = post.text
        cell.detailTextLabel?.numberOfLines = 0
        if let imageUrl = post.imageUrl {
            cell.imageView?.sd_setImage(with: URL(string: imageUrl))
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
}


// MARK: - UIImagePickerControllerDelegate
extension HomeController:  UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        
        dismiss(animated: true) {
            let url = "\(baseUrl)/posts/"
            let text = "testing from iPhone with AlamoFire again"
            guard let imageData = image.jpegData(compressionQuality: 1.0) else { return }

            guard let token = AuthService.shared.jwtToken else { return }
            let headers = HTTPHeaders(arrayLiteral: HTTPHeader(name: "Content-Type", value: "application/x-www-form-urlencoded"), HTTPHeader(name: "Authorization", value: token))
            
            AF.upload(multipartFormData: { (formData) in
                formData.append(Data(text.utf8), withName: "text")
                formData.append(imageData, withName: "image", fileName: "minthetmaung", mimeType: "image/jpeg")
            }, to: url, method: .post, headers: headers)
                .responseJSON(completionHandler: { (resp) in
                })
                .uploadProgress { (progress) in
                    let percentage = Int(progress.fractionCompleted * 100)
                    print("Progress : \(percentage)")
                    if percentage >= 100 {
                        self.fetchPosts()
                    }
            }
           
            
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

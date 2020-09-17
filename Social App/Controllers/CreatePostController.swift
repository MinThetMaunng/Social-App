//
//  CreatePostController.swift
//  Social App
//
//  Created by Min Thet Maung on 16/09/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import LBTATools
import Alamofire
import JGProgressHUD

class CreatePostController: UIViewController, UITextViewDelegate {
    
    let selectedImage: UIImage
    weak var homeController: HomeController?
    let imageView = UIImageView(image: nil, contentMode: .scaleAspectFill)
    
    lazy var postButton = UIButton(title: "Post", titleColor: .white, font: .boldSystemFont(ofSize: 14), backgroundColor: .systemBlue, action: #selector(handlePost))
    
    let placeholderLabel = UILabel(text: "Enter your post body text...", font: .systemFont(ofSize: 14), textColor: .lightGray)
    
    let postBodyTextView = UITextView(text: nil, font: .systemFont(ofSize: 14))
    
    init(selectedImage: UIImage) {
        self.selectedImage = selectedImage
        super.init(nibName: nil, bundle: nil)
        imageView.image = selectedImage
    }
    
    @objc private func handlePost() {
        
        let hud = JGProgressHUD(style: .dark)
        hud.indicatorView = JGProgressHUDRingIndicatorView()
        hud.textLabel.text = "Uploading"
        hud.show(in: view)
        
        guard let text = postBodyTextView.text else { return }
        guard let imageData = selectedImage.jpegData(compressionQuality: 1.0) else { return }
        
        PostService.shared.createPost(text: text, imageData: imageData, completion: {
            hud.dismiss()
            self.dismiss(animated: true) {
                self.homeController?.fetchPosts()
            }
        }) { (progress) in
            DispatchQueue.main.async {
                hud.progress = progress
                hud.textLabel.text = "Uploading\n\(Int(progress * 100))%"
            }
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.alpha = !textView.text.isEmpty ? 0 : 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        postBodyTextView.delegate = self
        postBodyTextView.backgroundColor = .clear
        postButton.layer.cornerRadius = 5
        
        view.stack(imageView.withHeight(300),
                   view.stack(postButton.withHeight(40),
                              placeholderLabel,
                              spacing: 16).padLeft(16).padRight(16),
                   UIView(),
                   spacing: 16)
        
        view.addSubview(postBodyTextView)
        postBodyTextView.anchor(top: placeholderLabel.bottomAnchor, leading: placeholderLabel.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: -25, left: -6, bottom: 0, right: 16))
        
    }
}

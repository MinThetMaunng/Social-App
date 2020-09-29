//
//  PostService.swift
//  Social App
//
//  Created by Min Thet Maung on 15/09/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import Foundation
import Alamofire

class PostService {
    public static let shared = PostService()
    
    func createPost(text: String, imageData: Data, completion: @escaping () -> (), uploading: @escaping (_ progress: Float) -> () ) {
        
        let url = "\(baseUrl)/posts/"
        
        guard let token = AuthService.shared.jwtToken else { return }
        let headers = HTTPHeaders(arrayLiteral: HTTPHeader(name: "Content-Type", value: "application/x-www-form-urlencoded"), HTTPHeader(name: "Authorization", value: token))
        
        AF.upload(multipartFormData: { (formData) in
            formData.append(Data(text.utf8), withName: "text")
            formData.append(imageData, withName: "image", fileName: "image", mimeType: "image/jpeg")
        }, to: url, method: .post, headers: headers)
            .responseJSON(completionHandler: { (resp) in
                if let err = resp.error {
                    fatalError("Error in creating post reponse : \(err.localizedDescription)")
                }
                completion()
            })
            .uploadProgress { (progress) in
                uploading(Float(progress.fractionCompleted))
        }
    }
    
    func fetchPosts(completion: @escaping (Result<FetchedPostsResponse, Error>) -> ()) {
        guard let token = AuthService.shared.jwtToken else { return }
        guard let url = URL(string: "\(baseUrl)/posts/") else { return }
        let headers = HTTPHeaders(arrayLiteral: HTTPHeader(name: "Content-Type", value: "application/json"), HTTPHeader(name: "Authorization", value: token))
        
        AF.request(url, headers: headers)
            .validate(statusCode: 200..<500)
            .responseData { (resp) in
                if let err = resp.error {
                    completion(.failure(err))
                }

                guard let data = resp.data else { return }
                do {
                    let fetchedPostsResponse = try JSONDecoder().decode(FetchedPostsResponse.self, from: data)
                    completion(.success(fetchedPostsResponse))
                } catch (let err) {
                    completion(.failure(err))
                }
        }
    }
    
    func deletePost(postId: String, completion: @escaping (Result<DeletePostResponse, Error>) -> ()) {
        guard let token = AuthService.shared.jwtToken
        else { return }
        
        let url = "\(baseUrl)/posts/\(postId)"
        let headers = HTTPHeaders([HTTPHeader(name: "Authorization", value: token)])
        AF.request(url, method: .delete, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { (resp) in
                
                if let err = resp.error {
                    print("Error in deleting post : \(err.localizedDescription)")
                    completion(.failure(err))
                }
                
                guard let data = resp.data else { return }
                do {
                    let deletePostResponse = try JSONDecoder().decode(DeletePostResponse.self, from: data)
                    completion(.success(deletePostResponse))
                } catch(let err) {
                    print("Error in decoding response from deleting post : \(err.localizedDescription)")
                    completion(.failure(err))
                }
            }
    }
}

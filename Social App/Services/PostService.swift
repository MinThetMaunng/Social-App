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
    
    func fetchPosts(completion: @escaping (Result<FetchedPostsResponse, Error>) -> ()) {
        guard let token = AuthService.shared.jwtToken else { return }
        guard let url = URL(string: "\(baseUrl)/posts/") else { return }
        let headers = HTTPHeaders(arrayLiteral: HTTPHeader(name: "Content-Type", value: "application/json"), HTTPHeader(name: "Authorization", value: token))
        
        AF.request(url, headers: headers)
            .validate(statusCode: 200..<300)
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
}

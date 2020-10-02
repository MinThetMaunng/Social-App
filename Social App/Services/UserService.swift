//
//  UserService.swift
//  Social App
//
//  Created by Min Thet Maung on 25/09/2020.
//  Copyright © 2020 Myanmy. All rights reserved.
//

import Foundation
import Alamofire

class UserService {
    public static let shared = UserService()
    
    func searchUser(keyword name: String, completion: @escaping(Result<SearchUsersResponse, Error>) -> () ) {
        
        guard let token = AuthService.shared.jwtToken else { return }
        guard let url = URL(string: "\(baseUrl)/users?name=\(name)") else { return }
        let headers = HTTPHeaders(arrayLiteral: HTTPHeader(name: "Content-Type", value: "application/json"), HTTPHeader(name: "Authorization", value: token))
        
        AF.request(url, headers: headers)
            .validate(statusCode: 200..<405)
            .responseData { (resp) in
                if let err = resp.error {
                    completion(.failure(err))
                }
                
                guard let data = resp.data else { return }
                do {
                    let searchUsersResponse = try JSONDecoder().decode(SearchUsersResponse.self, from: data)
                    completion(.success(searchUsersResponse))
                } catch (let err) {
                    completion(.failure(err))
                }
        }
    }
    
    func followUser(userId: String, completion: @escaping (Result<FollowUnfollowResponse, Error>) -> ()) {
        
        guard let token = AuthService.shared.jwtToken else { return }
        guard let url = URL(string: "\(baseUrl)/follows/\(userId)") else { return }
        let headers = HTTPHeaders(arrayLiteral: HTTPHeader(name: "Content-Type", value: "application/json"), HTTPHeader(name: "Authorization", value: token))
        
        AF.request(url, method: .post, headers: headers)
            .validate(statusCode: 200..<300)
            .responseData { (resp) in
                if let err = resp.error {
                    completion(.failure(err))
                }
                
                guard let data = resp.data else { return }
                do {
                    let followUnfollowResponse = try JSONDecoder().decode(FollowUnfollowResponse.self, from: data)
                    completion(.success(followUnfollowResponse))
                } catch (let err) {
                    completion(.failure(err))
                }
            }
    }
}

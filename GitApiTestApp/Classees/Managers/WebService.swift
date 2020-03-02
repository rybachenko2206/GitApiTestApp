//
//  WebService.swift
//  GitApiTestApp
//
//  Created by Roman Rybachenko on 02.03.2020.
//  Copyright © 2020 Roman Rybachenko. All rights reserved.
//

import Foundation


typealias Completion = () -> Void
typealias BoolCompletion = (Bool) -> Void
typealias DataCompletion = (Data) -> Void
typealias FailureHandler = (ApiError) -> Void


class WebService {
    
    static let shared = WebService()
    private init() { }
    
    
    // MARK: - Public funcs
    // getRepositories func is here 'cause this project is too small
    // I would prefer put this func to OrganizationManager.swift in real project
    func getRepositories(for org: String, completion: @escaping ([RepositoryItem]) -> Void, failure: @escaping FailureHandler) {
        self.request(method: .getRepositories(org: org), completion: { data in
            do {
                let reposArray = try JSONDecoder().decode([RepositoryItem].self, from: data)
                completion(reposArray)
            } catch let error {
                pl("decode response error: \n\(error.localizedDescription)")
                failure(.defaultError)
            }
        }, failure: failure)
    }
    
    
    func request(method: APIMethod, completion: @escaping DataCompletion, failure: @escaping FailureHandler) {
        guard let request = method.urlRequest else {
            failure(ApiError.defaultError)
            return
        }
        
        URLSession
            .shared
            .dataTask(with: request,
                      completionHandler: { (data, response, error) in
                        guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                            let responseData = data
                            else {
                                failure(ApiError.defaultError)
                                return
                        }
                        
                        let isSuccess = statusCode >= 200 && statusCode < 300
                        if isSuccess {
                            completion(responseData)
                        } else {
                            self.handleFailure(with: data, error: error, statusCode: statusCode, completion: failure)
                        }
            })
            .resume()
    }
    
    
    // MARK: - Private funcs
    private func handleFailure(with data: Data?, error: Error?, statusCode: Int?, completion: @escaping FailureHandler) {
        
        if let errorData = data {
            do {
                let serverErr = try JSONDecoder().decode(ServerError.self, from: errorData)
                let apiError = ApiError(serverError: serverErr, statusCode: statusCode)
                completion(apiError)
            } catch let decodeError {
                pl("decode response error: \n\(decodeError.localizedDescription)")
                completion(ApiError.defaultError)
            }
        } else {
            let apiError = ApiError(error: error, statusCode: statusCode)
            completion(apiError)
        }
    }
    
}


enum APIMethod {
    // https://api.github.com/orgs/square/repos
    static let baseURL = URL(string: "https://api.github.com/")!
    
    case getOrganization(name: String)
    case getRepositories(org: String)
    
    var httpMethod: String {
        switch self {
        case .getOrganization,
             .getRepositories:
            return "GET"
        }
    }
    
    var url: URL? {
        switch self {
        case .getOrganization(let orgName):
            return APIMethod.baseURL.appendingPathComponent("orgs/\(orgName)")
            
        case .getRepositories(let orgName):
            return APIMethod.baseURL.appendingPathComponent("orgs/\(orgName)/repos")
        }
    }
    
    var urlRequest: URLRequest? {
        guard let url = self.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = self.httpMethod
        
        return request
    }
}

//
//  Session.swift
//  CSImageAsync
//
//  Created by Charles Hsieh on 2020/4/20.
//  Copyright © 2020 Charles Hsieh. All rights reserved.
//

import Foundation

public enum SessionError: Error {
    
    case nilData
}

struct Session {
    
    private let urlSession: URLSession
    
    init(_ urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    @discardableResult
    func request(url: URL, handler: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask {
        
        let task = urlSession.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                handler(.failure(error!))
                return
            }
            if let data = data {
                handler(.success(data))
            } else {
                handler(.failure(SessionError.nilData))
            }
        }
        task.resume()
        
        return task
    }
}

//
//  ImageLoader.swift
//  CSImageAsync
//
//  Created by Charles Hsieh on 2020/4/20.
//  Copyright © 2020 Charles Hsieh. All rights reserved.
//

import UIKit

public enum ImageLoaderError: Error {
    
    case invalidURL
    case dataIsNotImage
}

public class ImageLoader {
    
    private let cachedImages = NSCache<NSString, UIImage>()
    
    private var processingTaskMap: [UUID: URLSessionDataTask] = [:]
    
    private let mapAccessQueue = DispatchQueue(label: "com.charleshs.CSImageAsync.mapAccessQueue", attributes: .concurrent)
    
    private let session: Session = {
        let urlSession = URLSession(configuration: .default)
        urlSession.delegateQueue.maxConcurrentOperationCount = 16
        return Session(urlSession)
    }()
    
    public func loadImage(_ urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
        
        if let image = cachedImages.object(forKey: urlString.toNSString()) {
            completion(.success(image))
            return nil
        }
        guard let url = URL(string: urlString) else {
            completion(.failure(ImageLoaderError.invalidURL))
            return nil
        }
        let uuid = UUID()
        let task = session.request(url: url) { [weak self] (result) in
            self?.safelyRemoveProcessingTask(forKey: uuid)
            
            switch result {
            case let .success(data):
                guard let image = UIImage(data: data) else {
                    completion(.failure(ImageLoaderError.dataIsNotImage))
                    return
                }
                self?.cachedImages.setObject(image, forKey: urlString.toNSString())
                completion(.success(image))
                
            case let .failure(error):
                completion(.failure(error))
            }
        }
        safelyAddProcessingTask(forKey: uuid, task: task)
        task.resume()
        
        return uuid
    }
    
    public func cancel(_ uuid: UUID) {
        
        processingTaskMap[uuid]?.cancel()
        safelyRemoveProcessingTask(forKey: uuid)
    }
    
    private func safelyRemoveProcessingTask(forKey key: UUID) {
        
        mapAccessQueue.async(flags: .barrier) { [weak self] in
            self?.processingTaskMap.removeValue(forKey: key)
        }
    }
    
    private func safelyAddProcessingTask(forKey key: UUID, task: URLSessionDataTask) {
        
        mapAccessQueue.async(flags: .barrier) { [weak self] in
            self?.processingTaskMap.updateValue(task, forKey: key)
        }
    }
}

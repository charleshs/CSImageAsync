//
//  CSImageAsync.swift
//  CSImageAsync
//
//  Created by Charles Hsieh on 2020/4/20.
//  Copyright © 2020 Charles Hsieh. All rights reserved.
//

import UIKit

public class CSImageManager {
    
    public static let shared = CSImageManager()
    
    private let imageLoader = ImageLoader()
    
    private var processingMap: [UIImageView: UUID] = [:]
    
    private let mapAccessQueue = DispatchQueue(label: "com.charleshs.CSImageAsync.mapAccessQueue", attributes: .concurrent)
    
    private init() { }
    
    public func load(_ urlString: String, for imageView: UIImageView) {
        
        let uuid = imageLoader.loadImage(urlString) { [weak self] (result) in
            switch result {
            case let .success(image):
                DispatchQueue.main.async {
                    imageView.image = image
                }
                self?.safelyRemoveProcessingImageView(forKey: imageView)
                
            case let .failure(error):
                debugPrint(error)
            }
        }
        if let uuid = uuid {
            safelyAddProcessingImageView(uuid, forKey: imageView)
        }
    }
    
    public func cancel(for imageView: UIImageView) {
        
        if let uuid = processingMap[imageView] {
            imageLoader.cancel(uuid)
            safelyRemoveProcessingImageView(forKey: imageView)
        }
    }
    
    private func safelyAddProcessingImageView(_ uuid: UUID, forKey imageView: UIImageView) {
        
        mapAccessQueue.async(flags: .barrier) { [weak self] in
            self?.processingMap.updateValue(uuid, forKey: imageView)
        }
    }
    
    private func safelyRemoveProcessingImageView(forKey imageView: UIImageView) {
        
        mapAccessQueue.async(flags: .barrier) { [weak self] in
            self?.processingMap.removeValue(forKey: imageView)
        }
    }
}

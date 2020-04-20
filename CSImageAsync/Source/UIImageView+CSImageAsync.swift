//
//  UIImageView+CSImageAsync.swift
//  CSImageAsync
//
//  Created by Charles Hsieh on 2020/4/20.
//  Copyright © 2020 Charles Hsieh. All rights reserved.
//

import UIKit

extension UIImageView {
    
    public func asyncLoad(_ urlString: String) {
        
        CSImageManager.shared.load(urlString, for: self)
    }
    
    public func cancelLoading() {
        
        CSImageManager.shared.cancel(for: self)
    }
}

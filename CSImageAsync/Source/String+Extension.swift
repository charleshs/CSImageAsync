//
//  String+Extension.swift
//  CSImageAsync
//
//  Created by Charles Hsieh on 2020/4/20.
//  Copyright © 2020 Charles Hsieh. All rights reserved.
//

import Foundation

extension String {
    
    func toNSString() -> NSString {
        
        return NSString(string: self)
    }
}

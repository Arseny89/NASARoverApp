//
//  DataCacheManager.swift
//  NASARover
//
//  Created by Арсений Корниенко on 1/27/25.
//

import SwiftUI

class DataCacheManager {
    static let cache = DataCacheManager()
    private let objectCache = NSCache<NSString, AnyObject>()
    
    func getObject(for key: String) -> AnyObject? {
        return objectCache.object(forKey: NSString(string: key))
    }
    
    func setObject(object: AnyObject, for key: String) {
        objectCache.setObject(object, forKey: NSString(string: key))
    }
}

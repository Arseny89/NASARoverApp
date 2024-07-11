//
//  UDStorageManager.swift
//  NASARover
//
//  Created by Арсений Корниенко on 7/10/24.
//

import Foundation

enum StorageKey: String {
    case favoritePhotos
}

class UDStorageManager {
    private func store(for object: Data, key: String) {
        UserDefaults.standard.set(object, forKey: key)
    }
    
    private func restore(for key: String) -> AnyObject? {
        UserDefaults.standard.object(forKey: key) as? AnyObject
    }
}

extension UDStorageManager {
    func set<T: Codable>(object: T, key: StorageKey) {
        guard let data = try? JSONEncoder().encode(object) else { return }
        store(for: data, key: key.rawValue)
    }
    
    func object<T: Codable>(for key: StorageKey ) -> T? {
        guard let data = restore(for: key.rawValue) as? Data else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
    
    func delete(for key: StorageKey) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
}

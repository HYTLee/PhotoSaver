//
//  UserDefaultsManager.swift
//  TestPhotoCollection
//
//  Created by YAUHENI HRAMIASHKEVICH on 12.03.24.
//

import Foundation

import Foundation

final class UserDefaultsManager {
    
    let defaults = UserDefaults.standard
    static let shared = UserDefaultsManager()
    
    func setIsGridLayout(type: Bool)  {
        defaults.set(type, forKey: "IsGridLayout")
    }
    
    func readIsGridLayout() -> Bool {
        let value: Bool = defaults.object(forKey: "IsGridLayout") as? Bool ?? false
        return value
    }
}

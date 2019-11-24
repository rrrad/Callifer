//
//  UserDefaultExtension.swift
//  Callifer
//
//  Created by Radislav Gaynanov on 20.11.2019.
//  Copyright © 2019 Radislav Gaynanov. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    enum UserDefaultExtensionError: Error {
        case notData
    }
    
    func getObject<S: Codable>(for key: String)throws -> S{
        guard let res = self.object(forKey: key) as? Data else { throw UserDefaultExtensionError.notData }
        
        let respons = try JSONDecoder().decode(S.self, from: res)
        return respons
    }
    
    func getArrayObjects<S: Codable>(for key: String)throws -> [S]{
        guard let res = self.object(forKey: key) as? Data else { throw UserDefaultExtensionError.notData }
        
        let respons = try JSONDecoder().decode([S].self, from: res)
        return respons
    }
    
    func saveObject<S: Codable>(object: S, for key: String)throws {
        
        let dataForSave = try JSONEncoder().encode(object)
        self.set(dataForSave, forKey: key)
        
    }
}

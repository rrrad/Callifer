//
//  ContactAuthorizer.swift
//  Callifer
//
//  Created by Radislav Gaynanov on 16.11.2019.
//  Copyright © 2019 Radislav Gaynanov. All rights reserved.
//

import Foundation
import Contacts

public final class ContactAuthorizer {
    public func contactAuth (complition: @escaping (_ succeeded: Bool) -> Void) {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            complition(true)
        case .notDetermined:
            CNContactStore().requestAccess(for: .contacts) { (succeeded, error) in
                complition(error == nil && succeeded)
            }
        default:
            complition(false)
        }
        
    }
}

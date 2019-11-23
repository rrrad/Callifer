//
//  Contact.swift
//  Callifer
//
//  Created by Radislav Gaynanov on 15.11.2019.
//  Copyright © 2019 Radislav Gaynanov. All rights reserved.
//

import Foundation
import Contacts



struct Contact : Equatable, Codable, Hashable{
    let id: String
    let name: String
    let description: String
    let number: String
    
}

struct ContactFromCNContact {
    func format(_ cnContact: CNContact) -> [Contact] {
        let id = cnContact.identifier
        let name = cnContact.givenName + cnContact.familyName
        let phones = cnContact.phoneNumbers
        var arr = [Contact]()
        for num in phones {
            let nString = num.value.stringValue.filter{("0"..."9").contains($0)}
            if nString.count > 10, nString.count < 13 {
                let element = Contact.init(id: id, name: name, description: formateDiscription(num.label), number: nString)
                arr.append(element)
            }
        }
        return arr
    }
    
    private func formateDiscription(_ description: String?) -> String {
        guard var desc = description else { return "" }
        
        if desc.hasPrefix("_$!<") {
            desc = desc.replacingOccurrences(of: "_$!<", with: "")
        }
        if desc.hasSuffix(">!$_") {
            desc = desc.replacingOccurrences(of: ">!$_", with: "")
        }
        return desc
    }
}

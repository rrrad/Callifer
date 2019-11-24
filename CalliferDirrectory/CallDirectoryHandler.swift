//
//  CallDirectoryHandler.swift
//  CalliferDirrectory
//
//  Created by Radislav Gaynanov on 09.11.2019.
//  Copyright © 2019 Radislav Gaynanov. All rights reserved.
//

import Foundation
import CallKit
import Contacts


class CallDirectoryHandler: CXCallDirectoryProvider {
    
    let contactStore = CNContactStore()
    var deleteBlock: Int = 33 // 33 запрет добавления телефонов
    var numberBlock: Array<Int64> = [Int64]()
    var numberExcept: Array<CXCallDirectoryPhoneNumber> = [CXCallDirectoryPhoneNumber]()
    let userDefault = UserDefaults.init(suiteName: "group.Callifer")

    override func beginRequest(with context: CXCallDirectoryExtensionContext) {
        context.delegate = self
        
        if let integer = userDefault?.integer(forKey: "delete") {
            deleteBlock = integer
        }
        
        if let array = userDefault?.object(forKey: "numberForDir") as? Array<Int64>  {
            numberExcept = array
        }
        
        numberBlock = getContacts(numberExcept)
        
        if context.isIncremental {
            deleteAllBlocking(context: context)

        }
        if deleteBlock == 22 {
        addAllBlockingPhoneNumbers(to: context)
        }
        
        context.completeRequest()
    }

    private func deleteAllBlocking(context: CXCallDirectoryExtensionContext) {
        context.removeAllBlockingEntries()
        context.removeAllIdentificationEntries()
    }
    
    private func addAllBlockingPhoneNumbers(to context: CXCallDirectoryExtensionContext) {
        
        for phoneNumber in numberBlock {
            context.addBlockingEntry(withNextSequentialPhoneNumber: phoneNumber)
        }
    }


   
    //MARK: - подготовка списка контактов
    
    private func getContacts(_ except: [CXCallDirectoryPhoneNumber]) -> [Int64]{
        
     //
        var setNumber:Set<Int64> = []
        
        let toFetching = [CNContactPhoneNumbersKey as NSString]
        var allContainer: [CNContainer] = []
        do {
            allContainer = try contactStore.containers(matching: nil)
        } catch {
        
        }
        var allContact: [CNContact] = []
        for container in allContainer {
            let predicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)

            do {
                let resInContainer = try contactStore.unifiedContacts(matching: predicate, keysToFetch: toFetching)
                allContact.append(contentsOf: resInContainer)
            } catch {
                
            }
        }
        
        for contact in allContact {
            
            let numbers = contact.phoneNumbers
            for num in numbers {
                let strNumber = num.value.stringValue.filter("0123456789".contains)
                if strNumber.count > 10, strNumber.count < 13 {
                    var resStr = ""
                    if strNumber.hasPrefix("8") {
                        resStr = strNumber.replacingCharacters(in: ...strNumber.startIndex, with: "+7")
                    }
                    if strNumber.hasPrefix("7") {
                        resStr = strNumber.replacingCharacters(in: ...strNumber.startIndex, with: "+7")
                    }
                    
                    if resStr != "" {

                        if let resNum = Int64(resStr) {
                            if !except.contains(resNum) {
                                setNumber.insert(resNum)
                            }
                        }
                    }
                }
            }
            
        }
        
        var array = Array.init(setNumber)
        array.sort { $0 < $1 }
        return array
    }
    
}

extension CallDirectoryHandler: CXCallDirectoryExtensionContextDelegate {

    func requestFailed(for extensionContext: CXCallDirectoryExtensionContext, withError error: Error) {
        // An error occurred while adding blocking or identification entries, check the NSError for details.
        // For Call Directory error codes, see the CXErrorCodeCallDirectoryManagerError enum in <CallKit/CXError.h>.
        //
        // This may be used to store the error details in a location accessible by the extension's containing app, so that the
        // app may be notified about errors which occured while loading data even if the request to load data was initiated by
        // the user in Settings instead of via the app itself.
    }

}

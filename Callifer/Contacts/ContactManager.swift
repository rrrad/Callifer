//
//  ContactManager.swift
//  Callifer
//
//  Created by Radislav Gaynanov on 15.11.2019.
//  Copyright © 2019 Radislav Gaynanov. All rights reserved.
//

import Foundation
import Contacts

class ContactManager{
    private var idcm: String
    let userDefault = UserDefaults.standard
    
    private var contactStore = CNContactStore()
    private var auth: Bool = false
    
    private var contacts = [Contact]()
    
    private var choiseContact = [Contact]()

    var contactsDidChange: (() -> Void)?
    
    init(idcm: String) {
        self.idcm = idcm
        auth = AppDelegate.shared.contactAuth
        setChoiseContact()
    }
    
    //MARK: - все контакты пользователя

    
    func setContacts() {
        guard auth == true else { return }
        let toFetch = [CNContactPhoneNumbersKey as NSString,
                       CNContactGivenNameKey as NSString,
                       CNContactFamilyNameKey as NSString]
        var allContainer: [CNContainer] = []
        do {
            allContainer = try contactStore.containers(matching: nil)
        } catch let err {
            print("Container Contact", err)
        }
        var allContact: [CNContact] = []
        for container in allContainer {
            let predicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)

            do {
                let resInContainer = try contactStore.unifiedContacts(matching: predicate, keysToFetch: toFetch)
                allContact.append(contentsOf: resInContainer)
            } catch let err {
                print("ALL Contact", err)
            }
        }
        
        var contactSet:Set<Contact> = []
        
        for contact in allContact {
            let arr = ContactFromCNContact().format(contact)
            for item in arr {
                contactSet.insert(item)
            }
        }
        
        contacts.append(contentsOf: contactSet)
        contacts.sort { $0.name < $1.name }
        
        if contactsDidChange != nil {
            contactsDidChange!()
        }
    }
    
    func getCount() -> Int {
        return contacts.count
    }
    
    func getContact(for index: Int) -> (Contact, Bool) {
        var select: Bool = false
        if choiseContact.contains(contacts[index]) {
           select = true
        }
        return (contacts[index], select)
    }
    
 //MARK: - выбранные контакты
    //взять выбранные контакты для данной группы и UserDefault
    func setChoiseContact() {
        do {
            choiseContact = try userDefault.getObject(for: idcm)
        } catch let error {
            print("UserDefault get choise contact", error)
        }
    }
    
    func addChoise(_ index: Int) {
        choiseContact.append(contacts[index])
    }
    
    func removeContact(_ i: Int) {
        let contact = contacts[i]
        for (index, item) in choiseContact.enumerated() {
            if item.id == contact.id {
                choiseContact.remove(at: index)
                break
            }
        }
    }
    
    func saveChois() {
        do {
        try userDefault.saveObject(object: choiseContact, for: idcm)
        } catch let error {
            print("UserDefault save choise contact", error)
        }
    }
}

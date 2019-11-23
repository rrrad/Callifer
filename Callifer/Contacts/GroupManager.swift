//
//  GroupManager.swift
//  Callifer
//
//  Created by Radislav Gaynanov on 17.11.2019.
//  Copyright © 2019 Radislav Gaynanov. All rights reserved.
//

import Foundation
import  CallKit

struct Group: Codable {
    var name: String
    let idcm: String //по этому идентификатору сохраняются выбранные контакты для этой группы в userDefault
}

class GroupeManager {
    private let userDefault = UserDefaults.init(suiteName: "group.Callifer")
    private let standartUserDefault = UserDefaults.standard
    private let callDirrectoryManager = CXCallDirectoryManager.sharedInstance
    
    private var data: [Group] = []
    
    var dataSoursDidChange: (() -> Void)?
    
    init() {
        getAllGroup()
    }
    
    // включить блокировку
    
    func onBlock(for group: Group) {
        let key = "numberForDir"
        var arr:[Contact] = []
        do {
           arr = try standartUserDefault.getObject(for: group.idcm)
        } catch let error {
            print("USER Default", error)
        }
        
        
        var resArray: [Int64] = []
        for item in arr {
            var resStr = ""
            if item.number.hasPrefix("8") {
                resStr = item.number.replacingCharacters(in: ...item.number.startIndex, with: "+7")
            }
            if item.number.hasPrefix("7") {
                resStr = item.number.replacingCharacters(in: ...item.number.startIndex, with: "+7")
            }
            if let resNum = Int64(resStr){
                resArray.append(resNum)
            }
        }
        
        userDefault?.set(resArray, forKey: key)
        userDefault?.set(22, forKey: "delete") // 22 добавлять
        callDirrectoryManager.reloadExtension(withIdentifier: "com.jerardev.Callifer.CalliferDirrectory") { (err) in
            print("ON Block", err)
        }
    }
    
    //выключить блокировку
    
    func offBlock() {
        userDefault?.set(33, forKey: "delete") // 33 не добавлять
        callDirrectoryManager.reloadExtension(withIdentifier: "com.jerardev.Callifer.CalliferDirrectory") { (err) in
            print("OFF Block", err)
        }
    }
    
    //данные обновились
    func refrechData() {
        if dataSoursDidChange != nil {
            dataSoursDidChange!()
        }
    }
    
    // добавить группу
    func addGroup() -> Group{
        var random: String
        repeat {
            random = String(Int.random(in: 0 ... 100000))
        } while data.contains(where: {$0.idcm == random})
        
        let group = Group.init(name: random, idcm: random)
    
        data.append(group)
        refrechData()
        saveAllGroup()
        return group
    }
    
    // удалить группу
    func removGroup(_ index: Int) {
        standartUserDefault.removeObject(forKey: data[index].idcm)
        data.remove(at: index)
        saveAllGroup()
        refrechData()
    }
    
    // редактировать группу(меняем имя)
    func updateName(name: String, for index: Int) {
        data[index].name = name
        saveAllGroup()
        refrechData()
    }
    
    
    // получить список всех групп
    func getAllGroup() {
        do {
            data = try standartUserDefault.getObject(for: "allgroups")
        } catch let error {
            print("GET", error)
        }
    }
    
    // сoхранить список всех групп
    func saveAllGroup() {
        do {
            try standartUserDefault.saveObject(object: data, for: "allgroups")
        } catch let error {
            print("SAVE", error)
        }
        
    }
    
    //MARK: - методы для CollectionView
    
    func getCountGroup() -> Int{
        return data.count
    }
    
    func getDataForCell(_ index: Int) -> Group{
        return data[index]
    }
}

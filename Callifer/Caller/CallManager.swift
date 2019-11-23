//
//  CallManager.swift
//  Callifer
//
//  Created by Radislav Gaynanov on 07.11.2019.
//  Copyright © 2019 Radislav Gaynanov. All rights reserved.
//

import Foundation
import CallKit

class CallManager {
    var callChangeHandler: (() -> Void)?
    private var callController = CXCallController()
    
    private(set) var calls: [Call] = []
    
    func callWithUUID(UUID: UUID) -> Call? {
        guard let index = calls.firstIndex(where: {$0.UUID == UUID}) else {
            return nil
        }
        return calls[index]
    }
    
    func add(call: Call) {
        calls.append(call)
        call.stateChange = {[weak self] in
            guard let self = self else {return}
            self.callChangeHandler?()
        }
        
    }
    
    func removeCall(call: Call) {
        guard let index = calls.firstIndex(where: {$0 === call}) else { return }
        calls.remove(at: index)
        callChangeHandler?()
    }
    
    func removeAllCall() {
        calls.removeAll()
        callChangeHandler?()
    }
    
    func end(call: Call) {
        let callAction = CXEndCallAction.init(call: call.UUID)
        let transaction = CXTransaction.init(action: callAction)
        requestTransaction(transaction)
    }
    
    private func requestTransaction(_ transaction: CXTransaction) {
        callController.request(transaction) { (err) in
            if let error = err {
                print("Ошибка транзакции \(error)")
            } else {
                print("транзакция прошла успешно")
            }
        }
    }
}

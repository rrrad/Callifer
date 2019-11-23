//
//  Call.swift
//  Callifer
//
//  Created by Radislav Gaynanov on 07.11.2019.
//  Copyright © 2019 Radislav Gaynanov. All rights reserved.
//

import Foundation

enum CallState {
    case connecting
    case active
    case ended
    case held
}

enum ConnectingState{
    case pending
    case complete
}

class Call {
    let UUID: UUID
    let outgoing: Bool
    let handle: String
    
    
    var  state: CallState = .ended {
        didSet{
            stateChange?()
        }
    }
    
    var  conectedState: ConnectingState = .pending  {
           didSet{
               conectedStateChange?()
           }
       }
    
    var stateChange: (() -> Void)?
    var conectedStateChange: (() -> Void)?
    
    init(UUID: UUID, outgoing: Bool = false, handle: String) {
        self.UUID = UUID
        self.outgoing = outgoing
        self.handle = handle
    }
    
    func start(completion: ((_ success: Bool) -> Void)?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.state = .connecting
            self.conectedState = .pending
            
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.state = .active
                self.conectedState = .complete
            }
        }
    }
    
    func answer() {
        state = .active
    }
    
    func end() {
        state = .ended
    }
}

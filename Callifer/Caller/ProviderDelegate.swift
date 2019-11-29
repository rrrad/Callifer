//
//  ProviderDelegate.swift
//  Callifer
//
//  Created by Radislav Gaynanov on 07.11.2019.
//  Copyright © 2019 Radislav Gaynanov. All rights reserved.
//

import Foundation
import CallKit
import AVFoundation

final class ProviderDelegate: NSObject {
    private let callManager: CallManager
    private let provider: CXProvider
    
    init(callManager: CallManager) {
        self.callManager = callManager
        provider = CXProvider.init(configuration: ProviderDelegate.providerConfiguration)
        super.init()
        provider.setDelegate(self, queue: nil)
    }
    
    static var providerConfiguration: CXProviderConfiguration = {
        let conf = CXProviderConfiguration.init(localizedName: "Callifer")
        
        conf.supportsVideo = true
        conf.maximumCallsPerCallGroup = 1
        conf.supportedHandleTypes = [.phoneNumber]
        
        return conf
    }()
    
    func reportIncomingCall(UUID: UUID,
                            handele: String,
                            hasVideo: Bool,
                            complition: ((Error?) -> Void)?
    ) {
      let update = CXCallUpdate()
        update.remoteHandle = CXHandle.init(type: .phoneNumber, value: handele)
        update.hasVideo = hasVideo
        
        provider.reportNewIncomingCall(with: UUID, update: update) { [weak self] (err) in
            if err == nil {
                let call = Call.init(UUID: UUID, handle: handele)
                self?.callManager.add(call: call)
            }
            complition?(err)
        }
        //здесь устанавливается соединение с сервером для ответа на звонок
    }
    
   
    
    
}

extension ProviderDelegate: CXProviderDelegate {
    func providerDidReset(_ provider: CXProvider) {
        stopAudio()
        for call in callManager.calls {
            call.end()
        }
        callManager.removeAllCall()
    }
    
    func provider(_ provider: CXProvider, perform action: CXSetHeldCallAction) {
        guard let call = callManager.callWithUUID(UUID: action.callUUID) else {
            action.fail()
            return
        }
        call.state = action.isOnHold ? .held : .active
        
        if call.state == .held {
           stopAudio()
        } else {
            startAudio()
        }
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        guard let call = callManager.callWithUUID(UUID: action.callUUID) else {
            action.fail()
            return
        }
        configureAudioSession()
        
        call.answer()
        
        action.fulfill()
        
       }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        guard let call = callManager.callWithUUID(UUID: action.callUUID) else {
            action.fail()
            return
        }
        
        stopAudio()
        call.end()
        action.fulfill()
        callManager.removeCall(call: call)
        
    }
    
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        let call = Call.init(UUID: action.callUUID, outgoing: true, handle: action.handle.value)
        configureAudioSession()
        call.conectedStateChange = { [weak self, weak call] in
            guard let self = self, let call = call else {return}
            if call.conectedState == .pending {
                self.provider.reportOutgoingCall(with: action.callUUID, startedConnectingAt: nil)
            } else if call.conectedState == .complete {
                self.provider.reportOutgoingCall(with: action.callUUID, connectedAt: nil)
            }
        }
        
        
        call.start { [weak self, weak call] (succes) in
            guard let self = self, let call = call else {return}
            
            if succes {
                action.fulfill()
                self.callManager.add(call: call)
            } else {
                action.fail()
            }
        }
    }
    
    func provider(_ provider: CXProvider, timedOutPerforming action: CXAction) {
        
    }
    
    //MARK: audioSession
    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        startAudio()
    }
    func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
        stopAudio()
    }
    
}

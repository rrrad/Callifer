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

class ProviderDelegate: NSObject {
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
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        guard let call = callManager.callWithUUID(UUID: action.callUUID) else {
            action.fail()
            return
        }
        configureAudioSession()
        
        call.answer()
        
        action.fulfill()
        
       }
    
    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        playAudio()
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
    
    
}

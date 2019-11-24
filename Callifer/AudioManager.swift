//
//  AudioManager.swift
//  Callifer
//
//  Created by Radislav Gaynanov on 08.11.2019.
//  Copyright © 2019 Radislav Gaynanov. All rights reserved.
//

import AVFoundation

func configureAudioSession() {
    let session = AVAudioSession.sharedInstance()
   
    do {
       try session.setCategory(.playAndRecord, mode: .voiceChat, options: [])
    } catch {
        
    }
}

func playAudio() {
    
}

func stopAudio() {
   
}

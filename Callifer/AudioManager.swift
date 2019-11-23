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
    } catch (let error) {
        print("audioSession error \(error)")
    }
}

func playAudio() {
    print("playAudio")
}

func stopAudio() {
    print("stopAudio")
}

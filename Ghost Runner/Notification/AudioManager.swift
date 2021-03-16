//
//  AudioManager.swift
//  Ghost Runner
//
//  Created by Dylan Long on 3/15/21.
//

import Foundation
import AVFoundation

class AudioManager {
    let synthesizer = AVSpeechSynthesizer()
    var audioPlayer: AVAudioPlayer?
    var utterance = AVSpeechUtterance(string: "")
    var utterance_one = AVSpeechUtterance(string: "")
    
    init() {
        // Choosing voice for synthesizer
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        //utterance.voice = AVSpeechSynthesisVoice(identifier: "Karen") // if we wanted to specify a voice
        
        // Setting audio to play during silent mode
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .voicePrompt, options: [.duckOthers, .allowBluetooth, .allowBluetoothA2DP, .allowAirPlay])
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch {
            print("error initializing AVAudio settings")
        }
    }
    
    func playOpponentPassedAudio(ghostName: String = "Opponent") {
        self.utterance = AVSpeechUtterance(string: "\(ghostName) has passed you")
        self.synthesizer.speak(utterance)
        //self.playAudioFile(fileName: "opponentPassedVoiceAudio", fileExtension: "m4a")
    }
    
    func playUserPassedAudio(ghostName: String = "Opponent") {
        self.utterance = AVSpeechUtterance(string: "You have passed \(ghostName)")
        self.synthesizer.speak(utterance)
        //self.playAudioFile(fileName: "userPassedVoiceAudio", fileExtension: "m4a")
    }
    
    // Plays audio which provides user with opponent run comparison information
    func playRunDifferenceAudio(ghostName: String = "Opponent", spacialDifference: Double, speedDifference: Double) {
        let absSpacialDifference = abs(spacialDifference)
        let absSpeedDifference = abs(speedDifference)
        let onPaceThreshold = 0.01

        if spacialDifference > 0 && speedDifference > 0 {
            self.utterance = AVSpeechUtterance(string: "You are \(spacialDifference) meters ahead of \(ghostName). Your speed is \(speedDifference) meters per second faster than \(ghostName).")
            self.synthesizer.speak(utterance)
        }
        else if spacialDifference < 0 && speedDifference > 0 {
            self.utterance = AVSpeechUtterance(string: "\(ghostName) is \(absSpacialDifference) meters ahead of you. Your speed is \(speedDifference) meters per second faster than \(ghostName).")
            self.synthesizer.speak(utterance)
        }
        else if spacialDifference > 0 && speedDifference < 0 {
            self.utterance = AVSpeechUtterance(string: "\(ghostName) is \(absSpacialDifference) meters ahead of you. Your speed is \(absSpeedDifference) meters per second slower than \(ghostName).")
            self.synthesizer.speak(utterance)
        }
        else if spacialDifference < 0 && speedDifference < 0 {
            self.utterance = AVSpeechUtterance(string: "\(ghostName) is \(absSpacialDifference) meters ahead of you. Your speed is \(absSpeedDifference) meters per second slower than \(ghostName).")
            self.synthesizer.speak(utterance)
        }
        else if spacialDifference > 0 && absSpeedDifference < onPaceThreshold {
            self.utterance = AVSpeechUtterance(string: "\(ghostName) is \(absSpacialDifference) meters ahead of you. You are on pace with \(ghostName).")
            self.synthesizer.speak(utterance)
        }
        else if spacialDifference < 0 && absSpeedDifference < onPaceThreshold {
            self.utterance = AVSpeechUtterance(string: "\(ghostName) is \(absSpacialDifference) meters ahead of you. You are on pace with \(ghostName).")
            self.synthesizer.speak(utterance)
        }
        
        // The utterances here are not be queued up for some reason, so they were included above
        // if value is provided, tell user how much faster/slower opponent is
        /*if let speedDiff = speedDifference {
            let absSpeedDifference = abs(speedDiff)

            if speedDiff > 0 {
                self.utterance_one = AVSpeechUtterance(string: "Your speed is \(speedDiff) meters per second faster than \(ghostName).")
                self.synthesizer.speak(utterance_one)
                print("got here")

            }
            else if speedDiff < 0 {
                self.utterance = AVSpeechUtterance(string: "Your speed is \(absSpeedDifference) meters per second slower than \(ghostName).")
                self.synthesizer.speak(utterance)
            }
            else {
                self.utterance = AVSpeechUtterance(string: "You are on pace with \(ghostName).")
                self.synthesizer.speak(utterance)
            }
        }*/
    }
    
    // Not currently used but may be useful eventually
    // Loads and play an audio file from the main bundle
    private func playAudioFile(fileName: String, fileExtension: String) {
        guard let path = Bundle.main.path(forResource: fileName, ofType: fileExtension) else {
            print("cannot find \(fileName)")
            return
        }
        
        let url = URL(fileURLWithPath: path)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            self.audioPlayer = try AVAudioPlayer(contentsOf: url)
            self.audioPlayer?.play()
            print("playing \(fileName)")
        }
        catch {
            print("could not load audio")
        }
    }
}

//
//  Notification.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 2/23/21.
//

// A BUTTON TO LET THEM KNOW WHAT THE OPPONENT IS DOING! "UPDATE"
// as well as periodically update them
import Foundation
import UserNotifications // For push notifications
import AVFoundation // For audio notifications

class NotificationManager {
    let center = UNUserNotificationCenter.current()
    let content = UNMutableNotificationContent()
    let synthesizer = AVSpeechSynthesizer()
    var audioPlayer: AVAudioPlayer?
    var utterance = AVSpeechUtterance(string: "")
    var utterance_one = AVSpeechUtterance(string: "")
        
    init() {
        // Request authorization for push notifications
        self.center.requestAuthorization(options: [.sound, .alert]) { (granted, error) in
            if granted == false {
                // Let user know how to change later and maybe let them know how notifications let the user know when friends have completed runs
            }
        }
        
        // Choosing voice for synthesizer
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        //utterance.voice = AVSpeechSynthesisVoice(identifier: "Karen") // if we wanted to specify a voice
        
        // Setting audio to play during silent mode
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch {
            print("error initializing AVAudio settings")
        }
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
    
    // Plays audio which provides user with opponent run comparison information
    func playRunDifferenceAudio(ghostName: String = "Opponent", spacialDifference: Double, speedDifference: Double) {
        let absSpacialDifference = abs(spacialDifference)
        let absSpeedDifference = abs(speedDifference)
        let onPaceThreshold = 0.1

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
    
    func pushFriendCompetedAgainstUser() {
        self.content.title = "GhostRunner alert!"
        self.content.body = "Your friend [friend username] competed against you!"
        pushNotification()
    }
    
    func pushFriendCreatedNewRun() {
        self.content.title = "GhostRunner alert!"
        self.content.body = "Your friend [friend username] created a new run!"
        pushNotification()
    }
    
    private func pushNotification() {
        var dateComponents = DateComponents()
        let date = Date(timeIntervalSinceNow: 10)
        dateComponents.hour = Calendar.current.component(Calendar.Component.hour, from: date)
        dateComponents.minute = Calendar.current.component(Calendar.Component.minute, from: date)
        dateComponents.second = Calendar.current.component(Calendar.Component.second, from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let uuid = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuid, content: self.content, trigger: trigger)
        
        self.center.add(request) { (error) in
            // check for errors
        }
    }
}

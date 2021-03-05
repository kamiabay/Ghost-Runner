//
//  Notification.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 2/23/21.
//

import Foundation
import UserNotifications // For push notifications
import AVFoundation // For audio notifications

class NotificationManager {
    let center = UNUserNotificationCenter.current()
    let content = UNMutableNotificationContent()
    var audioPlayer: AVAudioPlayer?
        
    init() {
        // Request authorization for push notifications
        self.center.requestAuthorization(options: [.sound, .alert]) { (granted, error) in
            if granted == false {
                // Let user know how to change later and maybe let them know how notifications let the user know when friends have completed runs
            }
        }
    }
    
    private func playAudioFile(fileName: String, fileExtension: String) {
        guard let path = Bundle.main.path(forResource: fileName, ofType: fileExtension) else {
            print("cannot find \(fileName)")
            return
        }
        
        let url = URL(fileURLWithPath: path)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default) // Not sure if these are necessary
            try AVAudioSession.sharedInstance().setActive(true)
            
            self.audioPlayer = try AVAudioPlayer(contentsOf: url)
            self.audioPlayer?.play()
            print("playing \(fileName)")
        }
        catch {
            print("could not load audio")
        }
    }
    
    func playOpponentApproachingAudio() {
        self.playAudioFile(fileName: "opponentApproachingVoiceAudio", fileExtension: "m4a")
    }
    
    func playOpponentPassedAudio() {
        self.playAudioFile(fileName: "opponentPassedVoiceAudio", fileExtension: "m4a")
    }
    
    func playUserPassedAudio() {
        self.playAudioFile(fileName: "userPassedVoiceAudio", fileExtension: "m4a")
    }
    
    func pushFriendCompetedAgainstUser() {
        self.content.title = "GhostRunner alert!"
        self.content.body = "Your friend [friend username] competed against you!"
        pushNotification()
        // Navigate user to view which shows results of competition
    }
    
    func pushFriendCreatedNewRun() {
        self.content.title = "GhostRunner alert!"
        self.content.body = "Your friend [friend username] created a new run!"
        pushNotification()
        // Navigate user to view which shows friends new run which use can compete against
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

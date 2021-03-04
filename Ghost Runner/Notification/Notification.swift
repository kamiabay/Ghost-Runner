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
    var runDifferenceVoiceAudio: AVAudioPlayer?
    var runnerPassedVoiceAudio: AVAudioPlayer?
    var userPassedVoiceAudio: AVAudioPlayer?
    
    init() {
        // Request authorization for push notifications
        self.center.requestAuthorization(options: [.sound, .alert]) { (granted, error) in
            if granted == false {
                // Let user know how to change later and maybe let them know how notifications let the user know when friends have completed runs
            }
        }
                
        // Initializing audio for file on computer
        // Will need to update to finding audio in memory (use 'init(data: Data)')
        self.runDifferenceVoiceAudio = initializeAudioFile(fileName: "runDifferenceVoiceAudio.mp3")
        self.runnerPassedVoiceAudio = initializeAudioFile(fileName: "runnerPassedVoiceAudio.mp3")
        self.userPassedVoiceAudio = initializeAudioFile(fileName: "userPassedVoiceAudio.mp3")
    }
    
    private func initializeAudioFile(fileName: String) -> AVAudioPlayer? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: nil) else {
            print("cannot find \(fileName)")
            return nil
        }
        
        let url = URL(fileURLWithPath: path)
        
        do {
            let audio = try AVAudioPlayer(contentsOf: url)
            return audio
        }
        catch {
            print("could not load audio")
        }
        
        return nil
    }
    
    func playRunDifferenceAudio() {
        self.runDifferenceVoiceAudio?.play()
    }
    
    func playRunnerPassedAudio() {
        self.runDifferenceVoiceAudio?.play()
    }
    
    func playUserPassedAudio() {
        self.runDifferenceVoiceAudio?.play()
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

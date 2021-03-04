//
//  Notification.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 2/23/21.
//

import Foundation
import UserNotifications // For push notifications
import AVFoundation // For audio notifications

// Potential issue: how do the audio notifications occur at the start of a 10-ghost race?
// The user probably wants to know how fast they are compared to everyone else, but also
// they probably don't want to have to hear a ton of notifications.
// Potential resolution: What if we give the user an update on his/her position after ~10 sec?
class NotoficationManager {
    let center = UNUserNotificationCenter.current()
    let content = UNMutableNotificationContent()
    var runDifferenceVoiceAudio: AVAudioPlayer? // Could say, "[name] is [time] seconds behind/ahead of you" or instead of being customizable, we could just have many of them
    
    init() {
        
        // Request authorization for push notifications
        self.center.requestAuthorization(options: [.sound, .alert]) { (granted, error) in
            if granted == false {
                // Let user know how to change later and maybe let them know how notifications let the user know when friends have completed runs
            }
        }
                
        // Initializing audio for file on computer
        // Will need to update to finding audio in memory (use 'init(data: Data)')
        guard let path = Bundle.main.path(forResource: "RUNDIFFERENCE.mp3", ofType: nil) else {
            print("cannot find RUNDIFFERENCE.mp3")
            return
        }
        let url = URL(fileURLWithPath: path)
        
        do {
            runDifferenceVoiceAudio = try AVAudioPlayer(contentsOf: url)
        }
        catch {
            print("could not load ")
        }
    }
    
    func playRunDifferenceAudio() {
        self.runDifferenceVoiceAudio?.play()
    }
    
    func playRunnerPassedAudio() {
        // play "You have been passed by [name]"
        // Maybe also "[name] is travelling [speed] faster than you"
        // Maybe mention their 'place'
    }
    
    func playUserPassedAudio() {
        // play "You have passed [name]"
        // Maybe add "and are now in [position] place"
    }
    
    func pushFriendCompetedAgainstUser() {
        self.content.title = "GhostRunner alert!"
        self.content.body = "Your friend [friend username] competed against you!"
        pushNotification()
        // Navigate user to view which shows results of competition
    }
    
    func friendCreatedNewRun() {
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

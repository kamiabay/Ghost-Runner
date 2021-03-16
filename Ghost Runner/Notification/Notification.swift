//
//  Notification.swift
//  Ghost Runner
//
//  Created by Kamyab Ayanifard on 2/23/21.
//

// A BUTTON TO LET THEM KNOW WHAT THE OPPONENT IS DOING! "UPDATE"
// as well as periodically update them 

// Still need to determine if notifications will play when phone is locked

import Foundation
import UserNotifications

class NotificationManager {
    let center = UNUserNotificationCenter.current()
    let content = UNMutableNotificationContent()
    let audio = AudioManager()
        
    init() {
        // Request authorization for push notifications
        self.center.requestAuthorization(options: [.sound, .alert]) { (granted, error) in
            if granted == false {
                // Let user know how to change later and maybe let them know how notifications let the user know when friends have completed runs
            }
        }
    }
    
    func playRunDifferenceAudio(ghostName: String = "Opponent", spacialDifference: Double, speedDifference: Double) {
        audio.playRunDifferenceAudio(ghostName: ghostName, spacialDifference: spacialDifference, speedDifference: speedDifference)
    }
    
    func playOpponentPassedAudio(ghostName: String = "Opponent") {
        audio.playOpponentPassedAudio(ghostName: ghostName)
    }
    
    func playUserPassedAudio(ghostName: String = "Opponent") {
        audio.playUserPassedAudio(ghostName: ghostName)
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
    
    
    // Notifications occur only if notification is triggered and app is put to background within the timeIntervalSinceNow value below
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

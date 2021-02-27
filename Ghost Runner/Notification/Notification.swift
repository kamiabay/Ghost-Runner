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
// Potential resolution: What if we give the user an update on his/her position after
class NotoficationManager {
    let center = UNUserNotificationCenter.current()
    let content = UNMutableNotificationContent()
    var runDifferenceVoiceAudio: AVAudioPlayer? // Could say, "[name] is [time] seconds behind/ahead of you"
    
    func playRunDifferenceAudio() {
        // play "[ghost] is [time/distance] ahead of/behind you"
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
        // Navigate use to view which shows results of competition
    }
    
    func friendCreatedNewRun() {
        // Navigate user to view which shows friends new run which use can compete against
    }
}

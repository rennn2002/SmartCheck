//
//  Notification.swift
//  Health Check
//
//  Created by Nomura Rentaro on 2021/10/07.
//
import SwiftUI
import UserNotifications

class Notification {
    init() {
        
    }
    
    func makeNotificationOnSchedule() {
        let isNotificationOn: Bool = UserDefaults.standard.value(forKey: "isNotificationOn") as? Bool ?? true
        let isFormPost: Bool = UserDefaults.standard.value(forKey: "isFormPosted") as? Bool ?? false
        
        if isNotificationOn  && !isFormPost {
            var notificationTime = DateComponents()
            var trigger: UNNotificationTrigger
            
            notificationTime.hour = 8
            notificationTime.minute = 0
            trigger = UNCalendarNotificationTrigger(dateMatching: notificationTime, repeats: false)
            
            let content = UNMutableNotificationContent()
            content.title = "Health Check"
            content.body = "健康観察フォームを提出してください"
            content.sound = UNNotificationSound.default
            
            let request = UNNotificationRequest(identifier: "notification001", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }
    
    func makeNotificationOnDemand() {
        let isNotificationOn: Bool = UserDefaults.standard.value(forKey: "isNotificationOn") as? Bool ?? true
        let isFormPost: Bool = UserDefaults.standard.value(forKey: "isFormPost") as? Bool ?? false
        
        if isNotificationOn && !isFormPost {
            var trigger: UNNotificationTrigger
            
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
            let content = UNMutableNotificationContent()
            
            content.title = "Health Check"
            content.body = "健康観察フォームを提出してください"
            content.sound = UNNotificationSound.default
            
            let request = UNNotificationRequest(identifier: "notification002", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }
}

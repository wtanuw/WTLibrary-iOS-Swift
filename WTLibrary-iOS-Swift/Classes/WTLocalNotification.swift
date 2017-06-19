//
//  WTLocalNotification.swift
//  Pods
//
//  Created by iMac on 2/1/16.
//
//

import Foundation

public class WTLocalNotification {
    
    static let NOTIFICATION_KEY = "kNotificationKey"
    
    public static func scheduleLocalNotification(key: String = "standardLocalNotification", fireDate: NSDate? = nil, timeZone: NSTimeZone? = nil, repeatInterval: NSCalendarUnit = NSCalendarUnit(rawValue: 0), repeatCalendar: NSCalendar? = nil, title: String? = nil, body: String? = nil, action: String? = nil, launchImage: String? = nil, soundName: String? = nil, badgeNumber: Int = 0, userInfo: [NSObject:AnyObject]? = nil, category: String? = nil) {
        
        var dictUserInfo: [NSObject:AnyObject] = [NOTIFICATION_KEY: key]
        if let userInfo = userInfo {
            dictUserInfo += userInfo
        }
        
        
        let notification = UILocalNotification()
        
        if let fireDate = fireDate {
            notification.fireDate = fireDate
        }
        if let timeZone = timeZone {
            notification.timeZone = timeZone
        }
        notification.repeatInterval = repeatInterval
        if let repeatCalendar = repeatCalendar {
            notification.repeatCalendar = repeatCalendar
        }
        
        if let alertBody = body {
            notification.alertBody = alertBody
        }
        if let alertAction = action {
            notification.hasAction = true
            notification.alertAction = alertAction
        }
        if let alertLaunchImage = launchImage {
            notification.alertLaunchImage = alertLaunchImage
        }
        if let alertTitle = title {
            if #available(iOS 8.2, *) {
                notification.alertTitle = alertTitle
            } else {
                // Fallback on earlier versions
            }
        }
        notification.soundName = soundName ?? UILocalNotificationDefaultSoundName
        notification.applicationIconBadgeNumber = badgeNumber
        notification.userInfo = dictUserInfo
        
        if let category = category {
            notification.category = category
        }
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
//    public static func () {
//    
//    }
    
    public static func changeIconBadgeNumber(number: Int) {
        UIApplication.sharedApplication().applicationIconBadgeNumber = number
    }
    
    //MARK:
    
    public static func presentLocalNotificationWithKey(key: String, title: String, message: String, soundName: String, userInfo: [NSObject: AnyObject]?) {
//        let notification = notificationWithTitle(key, title: title, message: message, date: nil, userInfo: ["key": key], soundName: nil, hasAction: true)
//        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    }
    
    //MARK:
    
//    public static func notificationWith(key : String, message: String, action: String, date: NSDate?, userInfo: [NSObject: AnyObject]?, soundName: String?, hasAction: Bool) -> UILocalNotification {
//        
//        var dct : Dictionary<String,AnyObject> = userInfo as! Dictionary<String,AnyObject>
//        dct["key"] = NSString(string: key) as String
//        
//        let notification = UILocalNotification()
//        notification.alertBody = message
//        notification.hasAction = hasAction
//        notification.alertAction = action
//        notification.userInfo = dct
//        notification.soundName = soundName ?? UILocalNotificationDefaultSoundName
//        notification.fireDate = date
//        return notification
//    }
    
    //MARK:
    
    public static func getLocalNotificationWithKey(key : String) -> UILocalNotification? {
        var notification : UILocalNotification?
        let allLocalNotification = UIApplication.sharedApplication().scheduledLocalNotifications
        if let allLocalNotification = allLocalNotification {
            for notif in allLocalNotification where notif.userInfo![NOTIFICATION_KEY] as! String == key{
                notification = notif
                break
            }
        }
        
        return notification
    }
    
    public static func cancelLocalNotification(key : String){
        let allLocalNotification = UIApplication.sharedApplication().scheduledLocalNotifications
        if let allLocalNotification = allLocalNotification {
            for notif in allLocalNotification where notif.userInfo![NOTIFICATION_KEY] as! String == key{
                UIApplication.sharedApplication().cancelLocalNotification(notif)
                break
            }
        }
    }
    
    public static func cancelLocalNotification(notification: UILocalNotification) {
        UIApplication.sharedApplication().cancelLocalNotification(notification)
    }
    
    public static func getAllLocalNotifications() -> [UILocalNotification]? {
        return UIApplication.sharedApplication().scheduledLocalNotifications
    }
    
    public static func cancelAllLocalNotifications() {
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }
    
    //MARK:
    
    public static let AllUserNotificationType: UIUserNotificationType = [.Badge, .Sound, .Alert]
    
    public static func registerUserNotificationType(notificationTypes: UIUserNotificationType) {
        
        let settings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
        
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
    }
    
    public typealias WTUserNotificationCategory = (categoryID: String, actions: [UIUserNotificationAction], defaultContextIndex: [Int], minimalContextIndex: [Int])
    
    public static func registerUserNotificationType(notificationTypes: UIUserNotificationType,  userCategories: [WTUserNotificationCategory]) {
        
        var categories = [UIUserNotificationCategory]()
        
        for userCategory in userCategories {
            let category = UIMutableUserNotificationCategory()
            category.identifier = userCategory.categoryID
            
            if userCategory.defaultContextIndex.count > 0 {
                var actions = [UIUserNotificationAction]()
                for index in userCategory.defaultContextIndex {
                    actions += [userCategory.actions[index]]
                }
                category.setActions(actions, forContext: UIUserNotificationActionContext.Default)
            }
            
            if userCategory.minimalContextIndex.count > 0 {
                var actions = [UIUserNotificationAction]()
                for index in userCategory.minimalContextIndex {
                    actions += [userCategory.actions[index]]
                }
                category.setActions(actions, forContext: UIUserNotificationActionContext.Minimal)
            }
            
            categories += [category]
        }
        
        let settings = UIUserNotificationSettings(forTypes: notificationTypes, categories: Set(categories))
        
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
    }
    
    //MARK:
    
    public static func userNotificationAction(identifier identifier: String? = nil, title: String? = nil, activationMode: UIUserNotificationActivationMode = UIUserNotificationActivationMode.Background, authenticationRequired: Bool = true, destructive: Bool = false) -> UIUserNotificationAction {
        let action = UIMutableUserNotificationAction()
        action.identifier = identifier
        action.title = title
        action.activationMode = activationMode
        action.authenticationRequired = authenticationRequired
        action.destructive = destructive
        return action
    }
    
    @available(iOS 9.0, *)
    public static func userNotificationAction(identifier identifier: String? = nil, title: String? = nil, activationMode: UIUserNotificationActivationMode = UIUserNotificationActivationMode.Background, authenticationRequired: Bool = true, destructive: Bool = false, behavior: UIUserNotificationActionBehavior = UIUserNotificationActionBehavior.Default, parameters: [NSObject : AnyObject]) -> UIUserNotificationAction {
        let action = UIMutableUserNotificationAction()
        action.identifier = identifier
        action.title = title
        action.behavior = behavior
        action.parameters = parameters
        action.activationMode = activationMode
        action.authenticationRequired = authenticationRequired
        action.destructive = destructive
        return action
    }
}

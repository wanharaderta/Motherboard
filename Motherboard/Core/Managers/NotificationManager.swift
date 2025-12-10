//
//  NotificationManager.swift
//  Motherboard
//
//  Created by Wanhar on 28/11/25.
//

import Foundation
import Combine

enum AppNotification: String {
    case didSignOut
    case didLogin
    
    var name: Notification.Name {
        Notification.Name(rawValue)
    }
}

enum AppNotificationKey: String {
    case isLogin
}

final class NotificationManager {
    static let shared = NotificationManager()

    private init() {}

    /// Post a notification
    func post(_ notification: AppNotification, object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
        NotificationCenter.default.post(name: notification.name, object: object, userInfo: userInfo)
    }

    /// Add observer with Combine
    func publisher(for notification: AppNotification) -> AnyPublisher<Notification, Never> {
        NotificationCenter.default.publisher(for: notification.name).eraseToAnyPublisher()
    }

    /// Add observer with selector (UIKit-compatible)
    func addObserver(_ observer: Any, selector: Selector, for notification: AppNotification) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: notification.name, object: nil)
    }

    /// Remove observer
    func removeObserver(_ observer: Any) {
        NotificationCenter.default.removeObserver(observer)
    }
}


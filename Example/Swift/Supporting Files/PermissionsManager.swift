/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

import UIKit
import CoreLocation

/**
 * Requests permission for system features.
 */

class PermissionsManager {

    static let shared = PermissionsManager()

    let locationManager = CLLocationManager()

    func requestLocalNotifications() {
        let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
    }

    func requestWhenInUseLocation() {
        locationManager.requestWhenInUseAuthorization()
    }

}

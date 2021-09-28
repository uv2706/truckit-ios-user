//
//  AppDelegate.swift
//  TruckIt
//
//  Created by hb on 29/07/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import UserNotifications
import Stripe
import Firebase
import FirebaseCrashlytics
import FirebaseCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var dateFormatter = DateFormatter()
    var pushDict : [String:Any]? = nil
    
    var sideMenu  = UIStoryboard(name: "SideMenu", bundle: nil).instantiateViewController(withIdentifier: "SideMenuNav")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        FirebaseApp.configure()
        
        
        if TruckItSessionHandler.shared.getPaymentMode()?.lowercased() == "live" {
            STPPaymentConfiguration.shared().publishableKey = StripeUrl.live.rawValue
        } else {
            STPPaymentConfiguration.shared().publishableKey = StripeUrl.test.rawValue
        }
        
        if launchOptions != nil
        {
            let aDict = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification]
            //print("pushnotificationData:(String(describing: aDict))")
            pushDict = aDict as? [String : Any]
        }
        
        
        self.registerForPushNotifications(application: application)
        // Override point for customization after application launch.
       return ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let aStrURL = url.absoluteString
        if aStrURL.contains("337517390258834")
        {
            let aHandled = ApplicationDelegate.shared.application(app, open: url, options: options)
            return aHandled
        }
        else
        {
            var handled: Bool
            handled = GIDSignIn.sharedInstance.handle(url)
            if handled {
                return true
            }
            
            return true
            
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("failed")
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        var token = ""
        for i in 0..<deviceToken.count {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        
        TruckItSessionHandler.shared.saveDeviceToken(token: token)
        updateTokenInBackend()
        
        print("Device Token : \(token)")
    }
    
    func updateTokenInBackend() {
        
        if let _ = TruckItSessionHandler.shared.getLoggedUserDetails()
        {
            let aRequest  = LoginAPIRouter.updateToken(request: TruckItSessionHandler.shared.deviceToken)
            NetworkService.dataRequest(with: aRequest, showLoader: false) { (responce: WSResponse<ForgotPassword.ViewModel>?, error: NetworkError?) in
                
            }
        }
    }
}

extension AppDelegate : UNUserNotificationCenterDelegate {
    
    func registerForPushNotifications(application: UIApplication) {
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                guard error == nil else {
                    //Display Error.. Handle Error.. etc..
                    return
                }
                if granted {
                    //Register for RemoteNotifications. Your Remote Notifications can display alerts now :)
                    DispatchQueue.main.async {
                        application.registerForRemoteNotifications()
                    }
                }
                else {
                    //Handle user denying permissions..
                }
            }
            
            application.registerForRemoteNotifications()
        } else {
            let notificationSettings = UIUserNotificationSettings(types: [.sound, .alert,.badge], categories: nil)
            application.registerUserNotificationSettings(notificationSettings)
        }
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        //        if notificationSettings.types != .none {
        application.registerForRemoteNotifications()
        //        }
    }
    
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler   completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void) {
        let dict = notification.request.content.userInfo as! [String:Any]
        print(notification.request.content.userInfo as! [String:Any])
        if let controller = self.window?.rootViewController {
            if let vc = (controller as! UINavigationController).topViewController {
                if let type = dict["type"] as? String, type == PushNotificationType.Message.rawValue {
                    if let vc = (vc as? MessageViewController) {
                        vc.unreadMessage()
                    } else {
                        completionHandler([.alert, .sound, .badge])
                    }
                } else if let type = dict["type"] as? String, type == PushNotificationType.NewOffer.rawValue {
                    if let vc = (vc as? PickUpDetailViewController) {
                        vc.setOfferTab()
                        completionHandler([.alert, .sound, .badge])
                    } else {
                        completionHandler([.alert, .sound, .badge])
                    }
                } else if let type = dict["type"] as? String, (type == PushNotificationType.PickedUp.rawValue || type == PushNotificationType.Enrouted.rawValue || type == PushNotificationType.Delivered.rawValue){
                    if let vc = (vc as? OngoingDeliveriesViewController) {
                        if let details = vc.details {
                            details.pickUpStatus = dict["status"] as? String
                            vc.setupLayout()
                        }
                        completionHandler([.alert, .sound, .badge])
                    } else {
                        completionHandler([.alert, .sound, .badge])
                    }
                } else {
                    completionHandler([.alert, .sound, .badge])
                }
            } else {
                completionHandler([.alert, .sound, .badge])
            }
        } else {
            completionHandler([.alert, .sound, .badge])
        }
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
        
        
        if pushDict == nil {
            
            
            let dict = response.notification.request.content.userInfo as! [String:Any]
            print(response.notification.request.content.userInfo as! [String:Any])
            if let controller = self.window?.rootViewController {
                if let vc = (controller as! UINavigationController).topViewController  {
                    if let type = dict["type"] as? String, type == PushNotificationType.Message.rawValue {
                        if vc is MessageViewController {
                        } else {
                            if let vc1 = MessageViewController.instance() {
                                vc1.driverId = dict["user_id"] as? String ?? ""
                                vc1.driverName = dict["user_name"] as? String ?? ""
                                vc1.driverProfile = dict["user_profile"] as? String ?? ""
                                vc1.pickUpId = dict["pickup_id"] as? String ?? ""
                                vc1.isOngoing = true
                                (controller as! UINavigationController).pushViewController(vc1, animated: true)
                            }
                        }
                    } else if let type = dict["type"] as? String, type == PushNotificationType.NewOffer.rawValue {
                        if let vc = (vc as? PickUpDetailViewController) {
                            vc.setOfferTab()
                        } else {
                            if let vc1 = PickUpDetailViewController.instance() {
                                vc1.forOffer = true
                                vc1.pickUpId = dict["pickup_id"] as? String ?? ""
                                (controller as! UINavigationController).pushViewController(vc1, animated: true)
                            }
                        }
                    } else if let type = dict["type"] as? String, type == PushNotificationType.Delivered.rawValue {
                        if let vc = (vc as? PastPickUpDetailViewController) {
                        } else {
                            if let vc1 = PastPickUpDetailViewController.instance() {
                                vc1.pickupId = dict["pickup_id"] as? String ?? ""
                                (controller as! UINavigationController).pushViewController(vc1, animated: true)
                            }
                        }
                        
                    } else if let type = dict["type"] as? String, (type == PushNotificationType.PickedUp.rawValue || type == PushNotificationType.Enrouted.rawValue){
                        if let vc = (vc as? OngoingDeliveriesViewController) {
                            if let details = vc.details {
                                details.pickUpStatus = dict["status"] as? String
                                vc.setupLayout()
                            }
                        } else {
                            if let vc1 = OngoingDeliveriesViewController.instance() {
                                vc1.pickUpId = dict["pickup_id"] as? String ?? ""
                                (controller as! UINavigationController).pushViewController(vc1, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print(userInfo)
        
    }
}

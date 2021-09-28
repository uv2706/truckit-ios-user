//
//  AppConstants.swift
//  Pick Up
//
//  Created by hb on 08/05/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit

struct AppConstants {
    
    static var enableEncryption = false
    /// Enable checksum for the api
    static var enableChecksum = false
    
    
    
    static let appName = "Truck It"
    static let appDelegate = UIApplication.shared.delegate as? AppDelegate ?? AppDelegate()
    
    static let paswordMaxLength = 15
    static let textFieldMaxLengeth = 50
    static let textViewMaxLengeth = 200
    
    static let platform = "iOS"
    static let os_version = UIDevice.current.systemVersion
    static let aesEncryptionKey = "CIT@WS!"
    /// Webservice checksum
    static let ws_checksum = "ws_checksum"
    
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let NavHeight = (deviceName == "iPhoneX") ? 84:64
    static let terms = "I agree to Truck It Terms & Conditions and Privacy Policy"
    static let reportProblemEmail = ""
    static let placeholderColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
    static let appColor = #colorLiteral(red: 0.03921568627, green: 0.09411764706, blue: 0.3450980392, alpha: 1)
   
   // static let baseUrl = "http://defa7eb18325.ngrok.io/trcuk_it_git/WS"
  //  static let baseUrl = "https://truckit.projectspreview.net/WS"
//    static let baseUrl = "http://54.158.156.134/WS"
    
    //download main
//    static let baseUrl = "https://mobile.truckit-app.com/WS"
    
    //new
    static let baseUrl = "http://3.86.235.80/WS/"

    //truckit apikey
    static let googleAPIKey = "AIzaSyAt00zEhr8yf8sX-l29I0zZkUJ4hgjEADY"
    
   // static let googleAPIKey = "AIzaSyAyB7asyhW7JK6hyK90S_Ow_ai145KH14Y"
    static let clientGoogleId = "181862298769-4654kel1vre0u26ojitcjde5gn0ea1hp.apps.googleusercontent.com"
   // static let stripe_Key = "pk_test_MVeT3mPFfb71MlEqFz3latkA00WwQpI4ir"

    /// Get Device Name
    static var deviceName : String {
        get {
            if UIDevice().userInterfaceIdiom == .phone {
                switch UIScreen.main.nativeBounds.height {
                case 1136:
                    return "iPhone5"
                case 1334:
                    return "iPhone6"
                case 1920, 2208:
                    return "iPhone6+"
                case 2436,1792,2688:
                    return "iPhoneX"
                default:
                    return "unknown"
                }
            } else {
                return "unknown"
            }
        }
    }
    
}

/// App Info
struct AppInfo {
    /// App Name
    static let kAppName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? "Truck It"
    /// App Version
    static let kAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    /// App Build version
    static let kAppBuildVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1.0"
    /// App Bundle identifier
    static let kBundleIdentifier = Bundle.main.bundleIdentifier
    /// App Store ID
    static let kAppstoreID = "1474750322"
    /// Play store bundle id
    static let kAndriodAppId = "com.app.whitelabel"
}

enum StripeUrl: String {
    case live = "pk_live_s0du8BOKFJm1mFOsqFGPOxm800aDBvrxNI"
    case test = "pk_test_xMcHMjxVKRW5nbK8oK8M3gwH00tt24FtZC"
}

enum SocialLoginType: String {
    case google = "g+"
    case facebook = "facebook"
     case apple = "apple"
}

enum PageCode: String {
    case aboutus
    case termsconditions
    case privacypolicy
    case faq

}

/// Add Shadow to the View
///
/// - top: Top position
/// - bottom: Bottom Position
/// - full: Top and bottom both
enum shadowPosition {
    case top
    case bottom
    case full
    case line
}

enum PaymentType: String {
    case stripe
    case wallet
}

enum NotificationType: String{
    case Error
    case Success
    case Info
}

enum CardType: String {
    case MasterCard = "MasterCard"
    case VisaCard = "VisaCard"
    case AmericanExpress = "AmericanExpress"
}


enum ProgressState: String {
    case Posted = "Posted"
    case OfferAccepted = "Accepted"
    case PickedUp = "PickedUp"
    case Enroute = "Enrouted"
    case Delivered = "Delivered"
    case PaidOff = "Paid Off"
}

enum PushNotificationType: String {
    case Message
    case Delivered
    case Enrouted
    case PickedUp
    case NewOfferNearBy
    case OfferRejected = "Offer Rejected"
    case OfferConfirm = "Offer Confirm"
    case NewOffer
}

enum UserType {
    case driver
    case user
}

struct AppleKeychainKeys {
    static let userIdentifier = "userIdentifier"
    static let userFirstName = "userIFirstName"
    static let userLastName = "userLastName"
    static let userEmail = "userEmail"
    
}
struct Videos {
     static let CreatePickUp = "https://www.youtube.com/watch?v=udd44hO86XM"
}

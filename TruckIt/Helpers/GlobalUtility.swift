//
//  GlobalUtility.swift
//
//  Created by HiddenBrains on 14/07/16.
//
//

import UIKit
import MediaPlayer
import CoreTelephony
import MapKit

@objc class GlobalUtility: NSObject {
    
    
    /// OTP to be saved when webservice is called

    /// Shared instance of the globalutility class
    static let shared: GlobalUtility = {
        let instance = GlobalUtility()
        // setup code
        return instance
    }()
    
    
    
    /// Check if any alert needs to be display in the viewcontroller
    ///
    /// - Parameters:
    ///   - arr: Array of messages
    ///   - isStatusBar: Set Yes if needs to be displayed on statusbar
    /// - Returns: Yes if there is no messages in the array
    class func checkAlertMessages(_ arr:[String]) -> Bool
    {
        var isAllowed = true
        for aRelay in arr
        {
            let aStr = aRelay
            if aStr.count > 0
            {
                AppConstants.appDelegate.showTopMessage(message: aStr, type: .Error)
                isAllowed = false
                break
            }
        }
        return isAllowed
    }
 
    func gradientImage(){

    }
    
//    /// Check if Tableview scrolled to bottom for pagination
//    ///
//    /// - Parameters:
//    ///   - contentOffset: Content offset of the tableview
//    ///   - tableView: Tableview object
//    /// - Returns: Returns Yes if Tableview is scrolled to bottom
//    class func isNearTheBottomEdge(contentOffset: CGPoint, _ tableView: UITableView) -> Bool {
//        return contentOffset.y + tableView.frame.size.height + startLoadingOffset > tableView.contentSize.height
//    }
    
  
    
    
    /// Get current TopView controller
    ///
    /// - Returns: UIViewController
    func currentTopViewController() -> UIViewController {
        var topVC: UIViewController? = AppConstants.appDelegate.window?.rootViewController
        while ((topVC?.presentedViewController) != nil) {
            topVC = topVC?.presentedViewController
        }
        return topVC!
    }
 
    
    /// Get Json String from any Object
    ///
    /// - Parameter object: Object to be converted in to json string
    /// - Returns: Returns json string
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    /// Round off text to one digit after decimal
    ///
    /// - Parameter value: Value of the string
    /// - Returns: Returns String value with one digit after decimal
    func roundOffText(_ value:String?) -> String
    {
        return  value!.count > 0 ? String(format: "%.1f",Float(value ?? "0")!) : ""
    }
    
    func UTCToLocal(date:String,format:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let dt = dateFormatter.date(from: date)
        return dt!
    }
    
    func timeAgoSinceDate(_ date:Date, numericDates:Bool = false) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = Date()
        let earliest = now < date ? now : date
        let latest = (earliest == now) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest,  to: latest)
        
        if (components.year! >= 2) {
            return "\(components.year!) y ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 y ago"
            } else {
                return "Last year"
            }
            //        } else if (components.month! >= 2) {
            //            return "(components.month!) m ago"
            //        } else if (components.month! >= 1){
            //            if (numericDates){
            //                return "1 m ago"
            //            } else {
            //                return "Last month"
            //            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) w ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 w ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) d ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 d ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) h ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 h ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) m ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 m ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) sec ago"
        } else {
            return "Just now"
        }
    }
    
    /// Round off text to two digit after decimal
    ///
    /// - Parameter value: Value of the string
    /// - Returns: Returns String value with two digit after decimal
    func roundOffTextTwoDigit(_ value:String?) -> String
    {
        return  value!.count > 0 ? String(format: "%.2f",Float(value ?? "0")!) : ""
    }
    
    
    /// Return App version
    ///
    /// - Returns: String
    func appVersion() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        return "\(version)"
    }
    
    
    
    func showMapOption(latitude: String, longitude: String,address:String = "",target:UIViewController) {
           if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
               let alert = UIAlertController(title: "Choose map options", message: "", preferredStyle: .actionSheet)
               alert.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler:{ (UIAlertAction)in
                   alert.dismiss(animated: true, completion: nil)
               }))
               alert.addAction(UIAlertAction(title: "Apple Map", style: .default , handler:{ (UIAlertAction)in
                   print("User click Approve button")
                   self.openAppleMap(latitude: latitude, longitude: longitude,address: address)
               }))
               alert.addAction(UIAlertAction(title: "Google Map", style: .default , handler:{ (UIAlertAction)in
                   print("User click Edit button")
                   self.openGoogleMap(latitude: latitude, longitude: longitude,address: address)
               }))
               target.present(alert, animated: true, completion: nil)
           } else {
               self.openAppleMap(latitude: latitude, longitude: longitude,address: address)
           }
       }
       
       
       func openAppleMap(latitude: String, longitude: String,address:String = "") {
           DispatchQueue.main.async {
               if #available(iOS 10.0, *) {
                   var aStr = "http://maps.apple.com/?q=" + address
                   aStr = aStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                   if let urlDestination = URL.init(string: aStr) {
                       UIApplication.shared.open(urlDestination, options: [:], completionHandler: nil)
                   }
               }
           }
       }
       
       func openGoogleMap(latitude: String, longitude: String,address:String = "") {
           let aGoogleURL = URL(string:"comgooglemaps://")
           if UIApplication.shared.canOpenURL(aGoogleURL!){
               var aStr = "comgooglemaps://?daddr=" + address + "&directionsmode=driving"
               aStr = aStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
               if let urlDestination = URL.init(string: aStr) {
                   if #available(iOS 10.0, *) {
                       UIApplication.shared.open(urlDestination, options: [:], completionHandler: nil)
                   } else {
                   }
               }
           }
       }
       
    
//    class func removeUserData()
//    {
//        UserModel.removeUserData()
//        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.authToken)
//        UserDefaults.standard.synchronize()
//    }
    
   
    func getFormattedDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let date1 = dateFormatter.date(from: date)
        
        dateFormatter.dateFormat = "dd/MMM/yyyy h:mm a"
        
        let formattedDate = dateFormatter.string(from: date1 ?? Date())
        return formattedDate
//        let Localdate = UTCToLocal(date: formattedDate, format: "dd/MMM/yyyy h:mm a")
//
//        return dateFormatter.string(from: Localdate ?? Date())
    }
    
    
    func extractYoutubeIdFromLink(link: String) -> String? {
        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        guard let regExp = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return nil
        }
        let nsLink = link as NSString
        let options = NSRegularExpression.MatchingOptions(rawValue: 0)
        let range = NSRange(location: 0, length: nsLink.length)
        let matches = regExp.matches(in: link as String, options:options, range:range)
        if let firstMatch = matches.first {
            return nsLink.substring(with: firstMatch.range)
        }
        return nil
    }
    
    
    @objc func showVideo(videoURL:String,title:String = "",target:UIViewController)
    {
        let aVCObj = UIStoryboard(name:"YoutubeVideoPlayer", bundle: nil).instantiateInitialViewController() as! YoutubeVideoPlayer
        aVCObj.strVideoID = GlobalUtility.shared.extractYoutubeIdFromLink(link: videoURL)!
        aVCObj.modalPresentationStyle = .fullScreen
        aVCObj.strTitle = title
        target.present(aVCObj, animated: true, completion: nil)
    }
    
    
}




/// Subclass for aligning text on top in UILabel
class VerticalTopAlignLabel: UILabel {
    
    override func drawText(in rect:CGRect) {
        guard let labelText = text else {  return super.drawText(in: rect) }
        
        let attributedText = NSAttributedString(string: labelText, attributes: [NSAttributedString.Key.font: font])
        var newRect = rect
        newRect.size.height = attributedText.boundingRect(with: rect.size, options: .usesLineFragmentOrigin, context: nil).size.height
        
        if numberOfLines != 0 {
            newRect.size.height = min(newRect.size.height, CGFloat(numberOfLines) * font.lineHeight)
        }
        
        super.drawText(in: newRect)
    }
    
}

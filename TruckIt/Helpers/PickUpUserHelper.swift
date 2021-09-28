//
//  MyHomeHubHelper.swift
//  My Home Hub
//
//  Created by hb on 23/11/18.
//  Copyright © 2018 Hidden Brains. All rights reserved.
//

import Foundation
import UIKit


enum AppClass: String {
    case LoginVC = "LoginViewController"
    case SignUpVc = "SignUpViewController"
    case ForgotPasswordVc = "ForgotPasswordViewController"
    case HomeVc = "HomeViewController"
    case googleSearch = "GoogleSearch"
    case staticPageVc = "StaticPageViewController"
    case changePasswordVc = "ChangePasswordViewController"
    case editProfileVc = "EditProfileViewController"
    case settingsVc = "SettingsViewController"
    case ReportAProblemVc = "ReportAProblemViewController"
    case sideMenuVc = "SideMenuViewController"
    case VerifyOtpVc = "VerifyOtpViewController"
    case ResetPasswordVc = "ResetPasswordViewController"
    case AddPickupVc = "AddPickupViewController"
    case DeliveriesVc = "DeliveriesViewController"
    case PendingVc = "PendingViewController"
    case OngoingVc = "OngoingViewController"
    case PastVc = "PastViewController"
    case PickUpDetailVc = "PickUpDetailViewController"
    case DetailsVc = "DetailsViewController"
    case OffersVc = "OffersViewController"
    case ProcessVc = "ProcessViewController"
    case AcceptRejectOfferVc = "AcceptRejectOfferViewController"
    case DriverProfileVc = "DriverProfileViewController"
    case ChangeMobileNumberVc = "ChangeMobileNumberViewController"
    case AddPaymentCardVc = "AddPaymentCardViewController"
    case PaymentCardListingVc = "PaymentCardListingViewController"
    case ReportUserVc = "ReportUserViewController"
    case GiveRatingVc = "GiveRatingViewController"
    case ReviewAndRattingsVC = "ReviewAndRattingsViewController"
    case PastPickUpDetailVc = "PastPickUpDetailViewController"
    case RatingPopupVc = "RatingPopupViewController"
    case MessageVc = "MessageViewController"
    case OngoingDeliveriesVc = "OngoingDeliveriesViewController"
    case OngoingDetailsVc = "OngoingDetailsViewController"
    case OngoingProcessVc = "OngoingProcessViewController"
    case CancelPickupVc = "CancelPickupViewController"
    case TipVc = "TipViewController"
}

enum StoryBoard: String {
    case Login
    case SignUp
    case ForgotPassword
    case Home
    case GoogleSearch
    case StaticPage
    case ChangePassword
    case EditProfile
    case Settings
    case ReportAProblem
    case SideMenu
    case VerifyOtp
    case ResetPassword
    case AddPickup
    case Deliveries
    case PickUpDetail
    case AcceptRejectOffer
    case DriverProfile
    case ChangeMobileNumber
    case AddPaymentCard
    case PaymentCardListing
    case ReportUser
    case GiveRating
    case ReviewAndRattings
    case PastPickUpDetail
    case Message
    case OngoingDeliveries
    case CancelPickup
    case Tip
    
    var board: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: nil)
    }
}


struct Platform {
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0 // Use this line in Xcode 7 or newer
    }
}




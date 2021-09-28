//
//  AlertMessages.swift
//  ForgetMeKnots
//
//  Created by hb on 08/05/19.
//  Copyright © 2019 hb. All rights reserved.
//

import Foundation

struct AlertMessage {
    
    static let invalidEmail = "Please enter valid email address."
    static let requiewPhone = "Please enter Mobile number"
    static let invalidOtp = "Please enter valid otp"
    static let requireVarificationCode = "Please enter verification code"
    static let wrongOtp = "Please enter correct verification code"
    static let emailRequired = "Please enter email address."
    static let passwordRequired = "Please enter password."
    static let invalidPassword = "Password length must be between 8 and 15 characters and contain at least one number, one capital letter, one small letter"
    static let deletePaymentCard = "Are you sure you want to delete this card?"
    static let confirmPassword = "Password and confirm password should be same"
    static let loginSuccess = "Logged in successfully."
    static let firstNameRequired = "Please enter first name"
    static let lastNameRequired = "Please enter last name."
    static let invalidPhoneNumber = "Please enter valid Mobile number."
    static let logoutConfirmation = "Are you sure you want to logout?"
    static let deleteConfirmation = "Are you sure you want to delete account?"
    static let agreeToTerms = "Please agree to our terms & conditions and privacy policy to continue."
    static let requireAddress = "Please enter address"
    static let requireAtp = "Please enter apt/suite no."
    
    static let removeImage = "Do you want to remove this image?"
    
    static let Logout = "You are logged out now because you have logged in from some other device."
    
    // Change Password
    static let requiewOldPassword = "Please enter old password"
    static let requiewReEnterNewPassword = "Please enter confirm password"
    static let enterPassword = "Please enter new password"
    static let invalidConfirmPassword = "Password and confirm password should be same"
    static let requireCurrentPassword = "Please enter current password"
    
    static let requireFeedback = "Please enter feedback"
    static let networkConnection = "No internet connection,Try again once you have an internet connection."
    static let userNotFound = "Something seems to be wrong, Please login to continue"
    
    // Add Pickup
    
    static let requirePickLocation = "Please enter pick up location"
    static let requirePickContactName = "Please enter pick up contact name"
    static let requirePickContactNum = "Please enter pick up contact number"
    static let invalidPickContact = "Please enter valid pick up contact number"
    static let requirePickDate = "Please select pick up date"
    static let requirePickSize = "Please select pick up size"
    static let requireDropLocation = "Please enter drop off location"
    static let requireDropContactName = "Please enter drop off contact name"
    static let requireDropContactNum = "Please enter drop off contact number"
    static let invalidDropContact = "Please enter valid drop off contact number"
    static let requireDropDate = "Please select drop off date"
    static let requireEstimatedAmount = "Please enter estimated amount"
    static let requirePickImage = "Please select at least one image"
    
    // send Card
    static let requireCardHolderName = "Please enter name on card"
    static let requireCardNumvber = "Please enter card number"
    static let requireExpDate = "Please enter expiry Date"
    static let requireCvv = "Please enter cvv"
    
    static let reportReason = "Please select reason"
    static let requireDescription = "Please enter description"
    
    static let selectRating = "Please select ratings."
    static let requireReviewcomment = "Please enter review comments."
    
    static let phoneNotAvailable = "Phone number not available of this driver"
    
    static let location = "To get nearby drivers, allow Truck It access your location."
    static let dropDateHeigh = "Drop off date should be higher than pick up date"
    static let cancelReason  = "Please enter cancel reason"
    // Camera and PhotoLibrary Access
    static let cameraAccess  = "To capture photos, allow Truck It to access camera. Please allow it from settings."
    static let photoLibraryAccess  = "To pick photos, allow Truck It to access photo library. Please allow it from settings."
    static let wentWrong = "Something went wrong please try again"
    
    static let selectTip = "Please select any tip amount"
    static let addTip = "Please enter other tip amount"
    static let defaultError = NSLocalizedString("Something went wrong, Please try again.",comment:"")
    
    //Splash
    static let notNow = NSLocalizedString("Not Now", comment: "")
    static let update = NSLocalizedString("Update", comment: "")
    
    static let NetworkError = NSLocalizedString("Server is not responding! Please try after sometime.", comment: "")
}

//
//  SplashViewController.swift
//  AppineersWhiteLabel

import UIKit
import Stripe

/// Protocol for presenting response
protocol SplashDisplayLogic: class {
    /// Did Receive OTP Response
    ///
    /// - Parameters:
    ///   - viewModel: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveVersionCheckResponse(viewModel: BackGroundCheck.ViewModel?, message: String, successCode: String)
}

/// This class is used to launch the app and do operations which need to perform in backgroud during app launch.
class SplashViewController: UIViewController {
    
    /// Interactor for API Call
    var interactor: SplashBusinessLogic?
    private var observer: NSObjectProtocol?
    var isAPiCallFail = false
    var configModel: BackGroundCheck.ViewModel?
    var pushDict : [String:Any]? = nil
    
    // MARK: Object lifecycle
    
    /// Override method to initialize with nib
    ///
    /// - Parameters:
    ///   - nibNameOrNil: Nib name
    ///   - nibBundleOrNil: Bundle in which nib is present
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    /// Decoder
    ///
    /// - Parameter aDecoder: Decoder
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    /// Set Up For API Calls
    private func setup() {
        let viewController = self
        let interactor = SplashInteractor()
        let presenter = SplashPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
    
    // MARK: ViewLifeCycle
    /// Method is called when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.callVersionCheckAPI()
        

        
        observer = NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main, using: { (_) in
            if self.isAPiCallFail {
                self.interactor?.callVersionCheckAPI()
            }
                
            else if let data = self.configModel {
                if data.versionUpdateCheck == "1" {
                    if data.versionUpdateOptional == "0" {
                        
                        let aVersion = AppInfo.kAppVersion
                        let aIOSVersion = data.iphoneVersionNumber ?? "1.0"
                        //let aIOSVersion =  "1.0.1"
                        
                        if aVersion != aIOSVersion {
                            let alertController = UIAlertController(title: AppConstants.appName, message: data.versionCheckMessage, preferredStyle: .alert)
                            let action = UIAlertAction(title: "Update Now", style: .default) { (action) in
                                
                                self.redirectToAppStore()
                            }
                            alertController.addAction(action)
                            
                            self.present(alertController, animated: true, completion: nil)
                        }
                        else
                        {
                            self.setViewController()
                        }
                        
                    }
                }
            }
            
        })
    }
    
    /// Method is called when view did appears
    ///
    /// - Parameter animated: animated
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    deinit {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    func setViewController() {
        if TruckItSessionHandler.shared.userId != nil, TruckItSessionHandler.shared.userId != "", TruckItSessionHandler.shared.userId != "0" {
            if let homeVc = HomeViewController.instance() {
                let vc = NavController.init(rootViewController: homeVc)
                AppConstants.appDelegate.window?.rootViewController = vc
            }
        } else {
            if let login = LoginViewController.instance() {
                let vc = NavController.init(rootViewController: login)
                AppConstants.appDelegate.window?.rootViewController = vc
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
            self.managePushNotification()
            AppConstants.appDelegate.pushDict = nil
        }
    }
    
    func managePushNotification()
    {
        
        if let dict = AppConstants.appDelegate.pushDict {
            if let controller = AppConstants.appDelegate.window?.rootViewController {
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
                        if (vc as? PastPickUpDetailViewController) != nil {
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
    
    func redirectToAppStore() {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/apple-store/id" + AppInfo.kAppstoreID + "?mt=8"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

// MARK: - For Splash API Reponse
extension SplashViewController: SplashDisplayLogic {
    /// Did Receive OTP Response
    ///
    /// - Parameters:
    ///   - viewModel: API Response
    ///   - message: API Message
    ///   - successCode: API Success
    func didReceiveVersionCheckResponse(viewModel: BackGroundCheck.ViewModel?, message: String, successCode: String) {
        if successCode == "1" {
            if let data = viewModel {
                TruckItSessionHandler.shared.saveCancelCharge(token: data.cancellationCharge ?? "0.00")
                TruckItSessionHandler.shared.savePaymentMode(mode: data.PAYMENTMODE ?? "test")
                
                if TruckItSessionHandler.shared.getPaymentMode()?.lowercased() == "live" {
                    STPPaymentConfiguration.shared().publishableKey = StripeUrl.live.rawValue
                } else {
                    STPPaymentConfiguration.shared().publishableKey = StripeUrl.test.rawValue
                }
                self.configModel = data
                let aVersion = AppInfo.kAppVersion
                let aIOSVersion = data.iphoneVersionNumber ?? "1.0"
                if data.versionUpdateCheck == "1" {
                    
                    if data.versionUpdateOptional == "0" {
                        
                        if aVersion != aIOSVersion {
                            let alertController = UIAlertController(title: AppConstants.appName, message: data.versionCheckMessage, preferredStyle: .alert)
                            let action = UIAlertAction(title: "Update Now", style: .default) { (action) in
                                
                                self.redirectToAppStore()
                            }
                            alertController.addAction(action)
                            self.present(alertController, animated: true, completion: nil)
                        }
                        else {
                            self.setViewController()
                        }
                        
                    }
                    else {
                        if aVersion != aIOSVersion {
                            self.displayAlert(msg: data.versionCheckMessage, ok: AlertMessage.update, cancel: AlertMessage.notNow, okAction: {
                                self.redirectToAppStore()
                                if data.versionUpdateOptional == "1" {
                                    self.setViewController()
                                }
                            }, cancelAction: {
                                if data.versionUpdateOptional == "1" {
                                    self.setViewController()
                                }
                            })
                        } else {
                            self.setViewController()
                        }
                    }
                    
                } else {
                    self.setViewController()
                }
            }
        } else {
            
            isAPiCallFail = true
            AppConstants.appDelegate.showTopMessage(message: message, type: .Error)
        }
    }
    
    
}

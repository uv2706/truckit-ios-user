//
//  ChangeMobileNumberViewController.swift
//  PickUpDriver
//
//  Created by hb on 21/06/19.


import UIKit

protocol ChangeMobileNumberDisplayLogic: class {
    func didReceivecOtpResponse(response: ChangeMobileNumber.ViewModel?,message: String, success: String)
}

class ChangeMobileNumberViewController: UIViewController {
    var interactor: ChangeMobileNumberBusinessLogic?
    var router: (NSObjectProtocol & ChangeMobileNumberRoutingLogic & ChangeMobileNumberDataPassing)?
    
    @IBOutlet weak var btnSendLink: UIButton!
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var txtFieldPhone: UITextField!
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    /// Insatance
    ///
    /// - Returns: ChangeMobileNumberViewController
    class func instance() -> ChangeMobileNumberViewController? {
        return StoryBoard.ChangeMobileNumber.board.instantiateViewController(withIdentifier: AppClass.ChangeMobileNumberVc.rawValue) as? ChangeMobileNumberViewController
    }
    
    
    private func setup() {
        let viewController = self
        let interactor = ChangeMobileNumberInteractor()
        let presenter = ChangeMobileNumberPresenter()
        let router = ChangeMobileNumberRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
     if #available(iOS 13.0, *) {
          overrideUserInterfaceStyle = .light
     } else {
          // Fallback on earlier versions
     }
        setupLayout()
    }
    
    /// Setup ui
    func setupLayout() {
        self.navigationItem.title = "Change Mobile Number"
        btnSendLink.layer.cornerRadius = 5
        txtFieldPhone.setLeftView(image: #imageLiteral(resourceName: "phone"))
        txtFieldPhone.addTarget(self, action: #selector(self.phoneTextDidChange), for: .editingChanged)
    }
    
    /// Valididate input fields
    fileprivate func validiateInput() {
        self.view.endEditing(true)
        if txtFieldPhone.text?.isEmpty ?? true {
            AppConstants.appDelegate.showTopMessage(message: AlertMessage.requiewPhone, type: .Error)
            txtFieldPhone.becomeFirstResponder()
        } else if !(txtFieldPhone.text?.isValidMobile ?? false) {
            AppConstants.appDelegate.showTopMessage(message: AlertMessage.invalidPhoneNumber, type: .Error)
            txtFieldPhone.becomeFirstResponder()
        } else {
            let phone = txtFieldPhone.text?.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
            let request = ChangeMobileNumber.Request(mobileNumber: phone!)
            interactor?.getOtp(request: request)
        }
    }
    
    
    /// Send Verification code on entered number
    ///
    /// - Parameter sender: UIButton
    @IBAction func btnSendPasswordLinkTapped(_ sender: UIButton) {
        validiateInput()
    }
    
    @objc func phoneTextDidChange() {
        var aStr = self.txtFieldPhone.text?.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "-", with: "")
        if (aStr!.count) >= 10
        {
            aStr = aStr!.substring(start: 0, end: 10)
        }
        let str = aStr!.toPhoneNumber()
        self.txtFieldPhone.text = str
    }
}

extension ChangeMobileNumberViewController: ChangeMobileNumberDisplayLogic {
    func didReceivecOtpResponse(response: ChangeMobileNumber.ViewModel?, message: String, success: String) {
        if success == "1" {
            if let data = response {
                AppConstants.appDelegate.showTopMessage(message: message, type: .Success)
                let phone = txtFieldPhone.text?.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
                if let verifyOtp = VerifyOtpViewController.instance() {
                    verifyOtp.isMobile = true
                    verifyOtp.isSignUp = false
                    verifyOtp.otp = data.otp!
                    verifyOtp.mobileNumber = phone ?? ""
                    self.navigationController?.pushViewController(verifyOtp, animated: true)
                }
            }
        }else {
            AppConstants.appDelegate.showTopMessage(message: message, type: .Error)
        }
    }
}

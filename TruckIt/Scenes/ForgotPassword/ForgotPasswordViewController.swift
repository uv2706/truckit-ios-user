//
//  ForgotPasswordViewController.swift
//  Udecide
//
//  Created by hb on 11/04/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ForgotPasswordDisplayLogic: class {
    func didReceiveForgotPasswordResponse(response: [ForgotPassword.ViewModel]?, message: String, success: String)
}

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var btnSendLink: UIButton!
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var txtFieldPhone: UITextField!
    
    var request: ForgotPassword.Request?
    
    var interactor: ForgotPasswordBusinessLogic?
    var router: (NSObjectProtocol & ForgotPasswordRoutingLogic & ForgotPasswordDataPassing)?
    
    /// Insatance
    ///
    /// - Returns: ForgotPasswordViewController
    class func instance() -> ForgotPasswordViewController? {
        return StoryBoard.ForgotPassword.board.instantiateViewController(withIdentifier: AppClass.ForgotPasswordVc.rawValue) as? ForgotPasswordViewController
    }
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = ForgotPasswordInteractor()
        let presenter = ForgotPasswordPresenter()
        let router = ForgotPasswordRouter()
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
    
    /// Setup Textfield and UI
    func setupLayout() {
        self.navigationItem.title = "Forgot Password"
        addButtonShadow(button: btnSendLink)
        self.viewBg.layer.cornerRadius = 10
        txtFieldPhone.delegate = self
        txtFieldPhone.addTarget(self, action: #selector(self.phoneTextDidChange), for: .editingChanged)
        btnSendLink.layer.cornerRadius = 5
        setLeftViewButtonForTextField(image: #imageLiteral(resourceName: "phone"), textField: txtFieldPhone)
    }
    
    @objc func phoneTextDidChange() {
        var aStr = self.txtFieldPhone.text?.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "-", with: "")
        if (aStr!.count) >= 10 {
            aStr = aStr!.substring(start: 0, end: 10)
        }
        let str = aStr!.toPhoneNumber()
        self.txtFieldPhone.text = str
    }
    
    /// Valididate input and call api
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
            let request = ForgotPassword.Request(mobile: phone ?? "")
            self.interactor?.forgotPassword(request: request)
        }
    }
    
    //MARK: UIbutton Action
    
    /// Forgot Password Link Send To email
    ///
    /// - Parameter sender: btnSendPassword
    @IBAction func btnSendPasswordLinkTapped(_ sender: UIButton) {
        validiateInput()
    }
}

extension ForgotPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFieldPhone {
            txtFieldPhone.resignFirstResponder()
        }
        return true
    }
}

extension ForgotPasswordViewController: ForgotPasswordDisplayLogic {
    func didReceiveForgotPasswordResponse(response: [ForgotPassword.ViewModel]?, message: String, success: String) {
        if success == "1" {
            if let viewModel = response {
                if let verifyOtp = VerifyOtpViewController.instance() {
                    verifyOtp.isSignUp = false
                    verifyOtp.otp = viewModel[0].otp ?? ""
                    verifyOtp.mobileNumber = txtFieldPhone.text ?? ""
                    verifyOtp.forgotPasswordData = viewModel[0]
                    self.navigationController?.pushViewController(verifyOtp, animated: true)
                }
            }
        } else {
            AppConstants.appDelegate.showTopMessage(message: message, type: .Error)
        }
    }
}

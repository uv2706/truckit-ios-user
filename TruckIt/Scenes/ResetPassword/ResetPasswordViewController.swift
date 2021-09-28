//
//  ResetPasswordViewController.swift
//  PickUpUser
//
//  Created by hb on 10/06/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ResetPasswordDisplayLogic: class {
    func didReceivecResetPasswordResponse(message: String, success: String)
}

class ResetPasswordViewController: UIViewController {
    var interactor: ResetPasswordBusinessLogic?
    var router: (NSObjectProtocol & ResetPasswordRoutingLogic & ResetPasswordDataPassing)?
    
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var txtFieldNewPassword: UITextField!
    @IBOutlet weak var txtFieldConfirmPassword: UITextField!
    @IBOutlet weak var btnUpdatePassword: UIButton!
    var forgotPasswordData : ForgotPassword.ViewModel?
    var mobileNumber = ""
    
    /// Insatance
    ///
    /// - Returns: ResetPasswordViewController
    class func instance() -> ResetPasswordViewController? {
        return StoryBoard.ResetPassword.board.instantiateViewController(withIdentifier: AppClass.ResetPasswordVc.rawValue) as? ResetPasswordViewController
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
        let interactor = ResetPasswordInteractor()
        let presenter = ResetPasswordPresenter()
        let router = ResetPasswordRouter()
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
        setupLayout()
    }
    
    
    /// Setup fields and ui
    func setupLayout() {
        self.navigationItem.title = "Reset Password"
        self.viewBg.layer.cornerRadius = 10
        txtFieldNewPassword.delegate = self
        txtFieldConfirmPassword.delegate = self
        addButtonShadow(button: btnUpdatePassword)
        setLeftViewButtonForTextField(image: #imageLiteral(resourceName: "password"), textField: txtFieldNewPassword)
        setLeftViewButtonForTextField(image: #imageLiteral(resourceName: "password"), textField: txtFieldConfirmPassword)
    }
    
    /// Validiate fields and call reset password api
    fileprivate func validiateFields() {
        self.view.endEditing(true)
        if txtFieldNewPassword.text?.isEmpty ?? true {
            AppConstants.appDelegate.showTopMessage(message: AlertMessage.enterPassword, type: .Error)
            txtFieldNewPassword.becomeFirstResponder()
        } else if !(txtFieldNewPassword.text?.isValidPassword() ?? false) {
            AppConstants.appDelegate.showTopMessage(message: AlertMessage.invalidPassword, type: .Error, displayDuraction: 10)
            self.txtFieldNewPassword.becomeFirstResponder()
        } else if txtFieldConfirmPassword.text?.isEmpty ?? true {
            AppConstants.appDelegate.showTopMessage(message: AlertMessage.requiewReEnterNewPassword, type: .Error)
            txtFieldConfirmPassword.becomeFirstResponder()
        } else if (txtFieldNewPassword.text != txtFieldConfirmPassword.text) {
            AppConstants.appDelegate.showTopMessage(message: AlertMessage.invalidConfirmPassword, type: .Error)
            txtFieldConfirmPassword.becomeFirstResponder()
        } else {
            let phone = mobileNumber.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
            
            
            let request = ResetPassword.Request(mobileNumber: phone, newPassword: AESCrypt.encrypt((txtFieldNewPassword.text ?? "" ), password: AppConstants.aesEncryptionKey, isPreviewApp: false), resetKey: forgotPasswordData!.resetKey!)
            
            
            
//            let request = ResetPassword.Request(mobileNumber: phone, newPassword: (txtFieldNewPassword.text ?? "" ) , resetKey: forgotPasswordData!.resetKey!)
            
            self.interactor?.resetPasswordPassword(request: request)
        }
    }
    
    
    /// Update password
    ///
    /// - Parameter sender: UIbutton
    @IBAction func btnUpdatePasswordTapped(_ sender: Any) {
        validiateFields()
    }
}

extension ResetPasswordViewController: UITextFieldDelegate {
    
}

extension ResetPasswordViewController : ResetPasswordDisplayLogic {
    func didReceivecResetPasswordResponse(message: String, success: String) {
        if success == "1" {
            AppConstants.appDelegate.showTopMessage(message: message, type: .Success)
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: LoginViewController.self) {
                    _ =  self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
        } else {
            AppConstants.appDelegate.showTopMessage(message: message, type: .Error)
        }
    }
    
}

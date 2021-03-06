//
//  ReportUserViewController.swift
//  PickUpUser
//
//  Created by hb on 03/07/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ReportUserDisplayLogic: class {
    func didReceiveReportReason(response: [ReportReason.ViewModel]?, message: String, success: String)
    func didReceiveReport(message: String, success: String)
}

class ReportUserViewController: UIViewController {
    var interactor: ReportUserBusinessLogic?
    var router: (NSObjectProtocol & ReportUserRoutingLogic & ReportUserDataPassing)?
    
    @IBOutlet weak var txtFieldReason: UITextField!
    @IBOutlet weak var txtViewDescription: UITextView!
    
    var placeholderLabel : UILabel!
    var pickerView: UIPickerView!
    var completion: (()->())?
    var reasonList = [ReportReason.ViewModel]()
    var reasonId = ""
    var driverId = ""
    
    /// Insatance
    ///
    /// - Returns: ReportUserViewController
    class func instance() -> ReportUserViewController? {
        return StoryBoard.ReportUser.board.instantiateViewController(withIdentifier: AppClass.ReportUserVc.rawValue) as? ReportUserViewController
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
        let interactor = ReportUserInteractor()
        let presenter = ReportUserPresenter()
        let router = ReportUserRouter()
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
        setUp()
    }
    
    /// Setup UI
    func setUp() {
        self.interactor?.reportReason()
        txtFieldReason.setRightView(image: #imageLiteral(resourceName: "dropdown_arrow"))
        self.txtFieldReason.delegate = self
        pickerView = UIPickerView()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.txtFieldReason.inputView = self.pickerView
        if !(NetworkManager.shared.reachabilityManager?.isReachable)! {
            self.txtFieldReason.isEnabled = false
        } else {
            self.txtFieldReason.isEnabled = true
        }
        txtViewDescription.delegate = self
        txtViewDescription.layer.borderColor = #colorLiteral(red: 0.8039215686, green: 0.8039215686, blue: 0.7725490196, alpha: 0.5)
        txtViewDescription.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        txtViewDescription.layer.cornerRadius = 5
        txtViewDescription.layer.borderWidth = 0.5
        placeholderLabel = UILabel()
        placeholderLabel.text = "Description"
        placeholderLabel.textColor = AppConstants.placeholderColor
        placeholderLabel.font = txtViewDescription.font
        placeholderLabel.sizeToFit()
        txtViewDescription.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (txtViewDescription.font?.pointSize)! / 2)
        placeholderLabel.isHidden = !txtViewDescription.text.isEmpty
    }
    
    
    /// Dismiss action
    ///
    /// - Parameter sender: UIButton
    @IBAction func btnDismissTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// Report Driver action
    ///
    /// - Parameter sender: UIButton
    @IBAction func btnReportTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        if self.txtFieldReason.text?.isEmpty ?? true {
            AppConstants.appDelegate.showTopMessage(message: AlertMessage.reportReason, type: .Error)
        } else if txtViewDescription.text.trim().isEmpty {
            AppConstants.appDelegate.showTopMessage(message: AlertMessage.requireDescription, type: .Error)
        } else {
            let req = ReportUser.Request(toId: self.driverId, reasonId: self.reasonId, description: txtViewDescription.text ?? "")
            self.interactor?.report(request: req)
        }
    }
    
}

extension ReportUserViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtFieldReason {
            self.txtFieldReason.resignFirstResponder()
            let row = pickerView.selectedRow(inComponent: 0)
            if let reason = self.reasonList[row].reportReason {
                self.txtFieldReason.text = reason
                self.reasonId = self.reasonList[row].reportId ?? ""
            }
        }
    }
}

extension ReportUserViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !txtViewDescription.text.isEmpty
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == txtViewDescription {
            let maxLength = AppConstants.textViewMaxLengeth
            let currentString: NSString = txtViewDescription.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: text) as NSString
            if newString.length > maxLength {
                return newString.length <= maxLength
            }
        }
        return true
    }
}

extension ReportUserViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return reasonList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.reasonList[row].reportReason
    }
}

extension ReportUserViewController: ReportUserDisplayLogic {
    func didReceiveReportReason(response: [ReportReason.ViewModel]?, message: String, success: String) {
        if success == "1" {
            if let response = response {
                self.reasonList = response
                self.pickerView.reloadAllComponents()
            }
        } else {
            AppConstants.appDelegate.showTopMessage(message: message, type: .Error)
        }
    }
    
    func didReceiveReport(message: String, success: String) {
        if success == "1" {
            if self.completion != nil {
                self.completion!()
            }
            self.dismiss(animated: true, completion: nil)
            AppConstants.appDelegate.showTopMessage(message: message, type: .Success)
        } else {
            AppConstants.appDelegate.showTopMessage(message: message, type: .Error)
        }
    }
}

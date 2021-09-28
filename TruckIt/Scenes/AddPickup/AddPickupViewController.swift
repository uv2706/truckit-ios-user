//
//  AddPickupViewController.swift
//  PickUpUser
//
//  Created by hb on 11/06/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import YPImagePicker
import AVFoundation
import AVKit
import GooglePlaces
import Photos

protocol AddPickupDisplayLogic: class {
    func didReceiveAddPickUpResponse(message: String, successCode: String)
    func didReceiveSizeResponse(response: [SizeList.ViewModel]?, message: String, successCode: String)
}

class AddPickupViewController: UIViewController {
    var interactor: AddPickupBusinessLogic?
    var router: (NSObjectProtocol & AddPickupRoutingLogic & AddPickupDataPassing)?
    
    
    @IBOutlet weak var btnHelper: UIButton!
    
    @IBOutlet weak var pickApt: UITextField!
    @IBOutlet weak var dropApt: UITextField!
    @IBOutlet weak var cv: UICollectionView!
    @IBOutlet weak var btnSameAsAcount: UIButton!
    @IBOutlet weak var txtDropAM: UITextField!
    @IBOutlet weak var txtDropTime: UITextField!
    @IBOutlet weak var txtDropDate: UITextField!
    @IBOutlet weak var txtEstimatedPrize: UITextField!
    @IBOutlet weak var txtDropContactNumber: UITextField!
    @IBOutlet weak var txtDropContactName: UITextField!
    @IBOutlet weak var txtDropLocation: UITextField!
    @IBOutlet weak var txtPickAM: UITextField!
    @IBOutlet weak var txtPixkTime: UITextField!
    @IBOutlet weak var txtPickDate: UITextField!
    @IBOutlet weak var txtPickUpSize: UITextField!
    @IBOutlet weak var txtPickContactNumber: UITextField!
    @IBOutlet weak var txtPickContact: UITextField!
    @IBOutlet weak var txtPickLocation: UITextField!
    
    let imgPickCount = 5
    var isPickDate: Bool = true
    var pickerView: UIPickerView!
    var dtPicker = UIDatePicker()
    
    var sizeId = ""
    var sizeArray = [SizeList.ViewModel]()
    var pickLat = ""
    var pickLong = ""
    var dropLat = ""
    var dropLong = ""
    var helper_required = "No"
    
    var selectedItems = [YPMediaItem]()
    var imageArray = [UIImage]() {
        didSet {
            cv.reloadData()
            self.scrollToBottom()
        }
    }
    var imageData = [Data]()
    
    
    // MARK: Object lifecycle
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
    /// - Returns: AddPickupViewController
    class func instance() -> AddPickupViewController? {
        return StoryBoard.AddPickup.board.instantiateViewController(withIdentifier: AppClass.AddPickupVc.rawValue) as? AddPickupViewController
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = AddPickupInteractor()
        let presenter = AddPickupPresenter()
        let router = AddPickupRouter()
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
        addAnayltics(analyticsParameterItemID: "id-ineedpickupscreen", analyticsParameterItemName: "view_ineedpickupscreen", analyticsParameterContentType: "view_ineedpickupscreen")
    }
    
    /// Setup Textfield and UI
    func setupLayout() {
        self.navigationItem.title = "I Need a Pickup"
        self.navigationItem.rightBarButtonItem = self.getNavBarButtonWithText(titleText: "Post", action: #selector(btnSaveTapped), target: self)
        
        if !(NetworkManager.shared.reachabilityManager?.isReachable)! {
            self.txtPickUpSize.isEnabled = false
        } else {
            self.txtPickUpSize.isEnabled = true
        }
        
        setUpTextfield()
        self.interactor?.getSize()
        pickerView = UIPickerView()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.txtPickUpSize.inputView = self.pickerView
        //setPickerToolBar()
        
        cv.delegate = self
        cv.dataSource = self
        dtPicker.datePickerMode = .dateAndTime
        if #available(iOS 13.4, *) {
            dtPicker.preferredDatePickerStyle = .wheels
        } else {
             // Fallback on earlier versions
        }
        dtPicker.minuteInterval = 30
        dtPicker.minimumDate = Date()
        var calendar = Calendar(identifier: .gregorian)
        var dateComponent = DateComponents()
        let newDate = calendar.date(byAdding: .day, value: 4, to: Date())
        dtPicker.maximumDate = newDate
        
        dtPicker.addTarget(self, action: #selector(pickDate), for: UIControl.Event.valueChanged)
        txtPickDate.inputView = dtPicker
        txtDropDate.inputView = dtPicker
        
        self.navigationItem.rightBarButtonItems = [self.getInfoButton(action: #selector(showVideo), target: self)]

        
    }
    
    @objc func showVideo()
       {
            GlobalUtility.shared.showVideo(videoURL: Videos.CreatePickUp,title: "Add New PickUp", target: self)
       }
       
    
    /// DatePickerDate
    @objc func pickDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MMM/yyyy h:mm a"
        if isPickDate {
            txtPickDate.text = dateFormatter.string(from: dtPicker.date)
            txtDropDate.text = ""
        } else {
            txtDropDate.text = dateFormatter.string(from: dtPicker.date)
            
        }
    }
    
    /// Text field UI setup
    func setUpTextfield() {
        
        txtPickLocation.delegate = self
        txtPickDate.delegate = self
        txtPixkTime.delegate = self
        txtPickAM.delegate = self
        txtPickContact.delegate = self
        txtPickContactNumber.delegate = self
        txtPickUpSize.delegate = self
        pickApt.delegate = self
        
        dropApt.delegate = self
        txtDropLocation.delegate = self
        txtDropDate.delegate = self
        txtDropTime.delegate = self
        txtDropAM.delegate = self
        txtDropContactName.delegate = self
        txtDropContactNumber.delegate = self
        txtEstimatedPrize.delegate = self
        
        txtPickDate.setRightView(image: #imageLiteral(resourceName: "calender"))
        txtDropDate.setRightView(image: #imageLiteral(resourceName: "calender"))
        txtPickUpSize.setRightView(image: #imageLiteral(resourceName: "dropdown_arrow"))
        
        txtPickContactNumber.addTarget(self, action: #selector(self.phoneTextDidChangeForPick), for: .editingChanged)
        txtDropContactNumber.addTarget(self, action: #selector(self.phoneTextDidChangeForDrop), for: .editingChanged)
    }
    
    @IBAction func btnHelperAction(_ sender: Any) {
        self.btnHelper.isSelected = !self.btnHelper.isSelected
        
        if btnHelper.isSelected {
            helper_required = "Yes"
        }else {
            helper_required = "No"
        }
    }
    
    
    
    @IBAction func btnPostAction(_ sender: Any) {
        self.btnSaveTapped()
    }
    /// Phone text format for pickup
    @objc func phoneTextDidChangeForPick() {
        var aStr = self.txtPickContactNumber.text?.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "-", with: "")
        if (aStr!.count) >= 10
        {
            aStr = aStr!.substring(start: 0, end: 10)
        }
        let str = aStr!.toPhoneNumber()
        self.txtPickContactNumber.text = str
        
    }
    
    /// Phone text format for dropoff
    @objc func phoneTextDidChangeForDrop() {
        var aStr = self.txtDropContactNumber.text?.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "-", with: "")
        if (aStr!.count) >= 10
        {
            aStr = aStr!.substring(start: 0, end: 10)
        }
        let str = aStr!.toPhoneNumber()
        self.txtDropContactNumber.text = str
        
    }
    
    /// Save pickup
    @objc func btnSaveTapped() {
        self.view.endEditing(true)
        
        if !(NetworkManager.shared.reachabilityManager?.isReachable)! {
            AppConstants.appDelegate.showTopMessage(message: AlertMessage.networkConnection, type: .Error)
            return
        }
        
        if txtPickLocation.text?.isEmpty ?? true {
            txtPickLocation.becomeFirstResponder()
            AppConstants.appDelegate.showTopMessage(message: AlertMessage.requirePickLocation, type: .Error)
        } else if txtPickContact.text?.isEmpty ?? true {
            txtPickContact.becomeFirstResponder()
            AppConstants.appDelegate.showTopMessage(message: AlertMessage.requirePickContactName, type: .Error)
        } else if txtPickContactNumber.text?.isEmpty ?? true {
            txtPickContactNumber.becomeFirstResponder()
            AppConstants.appDelegate.showTopMessage(message: AlertMessage.requirePickContactNum, type: .Error)
        } else if !(txtPickContactNumber.text?.isValidMobile ?? false) {
            txtPickContactNumber.becomeFirstResponder()
            AppConstants.appDelegate.showTopMessage(message: AlertMessage.invalidPickContact, type: .Error)
        } else if txtPickDate.text?.isEmpty ?? true {
            txtPickDate.becomeFirstResponder()
            AppConstants.appDelegate.showTopMessage(message: AlertMessage.requirePickDate, type: .Error)
        } else if txtPickUpSize.text?.isEmpty ?? true {
            txtPickUpSize.becomeFirstResponder()
            AppConstants.appDelegate.showTopMessage(message: AlertMessage.requirePickSize, type: .Error)
        } else if txtDropLocation.text?.isEmpty ?? true {
            txtDropLocation.becomeFirstResponder()
            AppConstants.appDelegate.showTopMessage(message: AlertMessage.requireDropLocation, type: .Error)
        } else if txtDropContactName.text?.isEmpty ?? true {
            txtDropContactName.becomeFirstResponder()
            AppConstants.appDelegate.showTopMessage(message: AlertMessage.requireDropContactName, type: .Error)
        } else if txtDropContactNumber.text?.isEmpty ?? true {
            txtDropContactNumber.becomeFirstResponder()
            AppConstants.appDelegate.showTopMessage(message: AlertMessage.requireDropContactNum, type: .Error)
        } else if !(txtDropContactNumber.text?.isValidMobile ?? false) {
            txtDropContactNumber.becomeFirstResponder()
            AppConstants.appDelegate.showTopMessage(message: AlertMessage.invalidDropContact, type: .Error)
        } else if txtDropDate.text?.isEmpty ?? true {
            txtDropDate.becomeFirstResponder()
            AppConstants.appDelegate.showTopMessage(message: AlertMessage.requireDropDate, type: .Error)
        }
//        else if txtEstimatedPrize.text?.isEmpty ?? true {
//            txtEstimatedPrize.becomeFirstResponder()
//            AppConstants.appDelegate.showTopMessage(message: AlertMessage.requireEstimatedAmount, type: .Error)
//        }
    else if self.imageArray.count <= 0 {
            AppConstants.appDelegate.showTopMessage(message: AlertMessage.requirePickImage, type: .Error)
        } else {
            
            let pickAddres = (txtPickLocation.text ?? "") + "," + (pickApt.text ?? "")
            let pickPhone = txtPickContactNumber.text?.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
            
            let dropAddres = (txtDropLocation.text ?? "") + "," + (dropApt.text ?? "")
            let dropPhone = txtDropContactNumber.text?.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
            
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "dd/MMM/yyyy h:mm a"
            let pickDate = dateFormat.date(from: txtPickDate.text ?? "")
            let dropDate = dateFormat.date(from: txtDropDate.text ?? "")
            
            dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let request = AddPickup.Request(pickLocation: pickAddres, pickLat: self.pickLat, pickLong: self.pickLong, pickContactName: txtPickContact.text ?? "", pickContactNum: pickPhone ?? "", pickTime: dateFormat.string(from: pickDate ?? Date()), dropLocation: dropAddres, dropLat: self.dropLat, dropLong: self.dropLong, dropTime: dateFormat.string(from: dropDate ?? Date()), dropContactName: txtDropContactName.text ?? "", dropContactNum: dropPhone ?? "", estimatedAmount: txtEstimatedPrize.text ?? "", sizeId: self.sizeId, images_count: "\(self.imageArray.count)", imageArray: self.imageArray, helper_required: self.helper_required)
            
            
            addAnayltics(analyticsParameterItemID: "id-postapickup", analyticsParameterItemName: "click_postapickup", analyticsParameterContentType: "click_postapickup")
            self.interactor?.callAddPickupAPI(request: request)
        }
        
    }
    
    /// scroll to last index of collection view
    func scrollToBottom(){
        DispatchQueue.main.async {
            if self.imageArray.count == self.imgPickCount {
                let indexPath = IndexPath(row: self.imageArray.count - 1, section: 0)
                self.cv.scrollToItem(at: indexPath, at: .right, animated: false)
            } else {
                let indexPath = IndexPath(row: self.imageArray.count, section: 0)
                self.cv.scrollToItem(at: indexPath, at: .right, animated: false)
            }
            
        }
    }
    
    func checkCameraAccess() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized {
                checkAccessForPhotoLibrary()
            } else {
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) -> Void in
                    if granted == true {
                        
                         DispatchQueue.main.async {
                            self.checkAccessForPhotoLibrary()
                        }
                        
                    } else {
                        DispatchQueue.main.async {
                            GlobalUtility.shared.currentTopViewController().displayAlert(msg: AlertMessage.cameraAccess, ok: "Settings", cancel: "Cancel", okAction: {
                                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                                
                            }, cancelAction: nil)
                        }
                    }
                })
            }
            
            
        }
//        else {
//            checkAccessForPhotoLibrary()
//        }
    }
    
    
    func checkAccessForPhotoLibrary()
    {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                DispatchQueue.main.async {
                    self.showPicker()
                }
            case .denied:
                DispatchQueue.main.async {
                    GlobalUtility.shared.currentTopViewController().displayAlert(msg: AlertMessage.photoLibraryAccess, ok: "Settings", cancel: "Cancel", okAction: {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                        
                    }, cancelAction: nil)
                }
            default:
                print("default")
            }
        }
    }
    
    
    /// Open multi image picker with camera and gallery options
    func showPicker() {
        var config = YPImagePickerConfiguration()
        config.library.mediaType = .photo
        config.shouldSaveNewPicturesToAlbum = false
        config.video.compression = AVAssetExportPresetMediumQuality
        config.startOnScreen = .library
        config.showsPhotoFilters = false
        config.filters = []
        config.screens = [.library, .photo]
        config.video.libraryTimeLimit = 500.0
        //  config.showsCrop = .rectangle(ratio: 1)
        config.wordings.libraryTitle = "Gallery"
        //config.hidesStatusBar = false
        //config.preferredStatusBarStyle = .default
        config.hidesBottomBar = false
        config.library.maxNumberOfItems = imgPickCount - imageArray.count
        config.library.skipSelectionsGallery = true
        DispatchQueue.main.async {
            let picker = YPImagePicker(configuration: config)
            picker.didFinishPicking { [unowned picker] items, cancelled in
                if cancelled {
                    print("Picker was canceled")
                    picker.dismiss(animated: true, completion: nil)
                    return
                }
                _ = items.map { print("🧀 \($0)") }
                self.selectedItems = items
                for itm in items {
                    switch itm {
                    case .photo(let photo):
                        self.imageArray.append(photo.image)
                    case .video(let v):
                        print("Video")
                    }
                }
                picker.dismiss(animated: true, completion: nil)
            }
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    /// Fill/Remove user details in drop of location
    ///
    /// - Parameter sender: UIButton
    @IBAction func btnSameAsTapped(_ sender: UIButton) {
        btnSameAsAcount.isSelected = !btnSameAsAcount.isSelected
        btnSameAsAcount.isSelected ? fillUserData():clearUserData()
    }
    
    /// Fill user detail for drop location
    func fillUserData() {
        if let user = TruckItSessionHandler.shared.getLoggedUserDetails() {
            self.txtDropLocation.text = user.address
            self.dropApt.text = user.aptNo
            self.dropLat = user.lat ?? ""
            self.dropLong = user.long ?? ""
            
            txtDropContactName.text = "\(user.firstName ?? "") \(user.lastName ?? "")"
            
            var aStr = user.mobileNo?.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "-", with: "")
            if (aStr!.count) >= 10
            {
                aStr = aStr!.substring(start: 0, end: 10)
            }
            let str = aStr!.toPhoneNumber()
            self.txtDropContactNumber.text = str
        }
    }
    
    /// Clear filler user detail from drop location
    func clearUserData() {
        self.txtDropContactNumber.text = ""
        txtDropContactName.text  = ""
        self.dropLat = ""
        self.dropLong = ""
        self.dropApt.text = ""
        self.txtDropLocation.text = ""
    }
    
}

extension AddPickupViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtPickDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MMM/yyyy h:mm a"
            txtPickDate.text = dateFormatter.string(from: dtPicker.date)
            txtDropDate.text = ""
        } else if textField == txtDropDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MMM/yyyy h:mm a"
            if let date = txtPickDate.text, date != "" {
                if dateFormatter.date(from: date) ?? Date() >= dtPicker.date {
                    txtDropDate.text = ""
                    AppConstants.appDelegate.showTopMessage(message: AlertMessage.dropDateHeigh, type: .Error)
                } else {
                    txtDropDate.text = dateFormatter.string(from: dtPicker.date)
                }
                
            } else {
                txtDropDate.text = dateFormatter.string(from: dtPicker.date)
            }
        } else if textField == txtPickUpSize {
            self.txtPickUpSize.resignFirstResponder()
            let row = pickerView.selectedRow(inComponent: 0)
            self.sizeId = sizeArray[row].sizeId ?? ""
            self.txtPickUpSize.text = "\(sizeArray[row].size ?? ""): \(sizeArray[row].sizeInLbs ?? "")"
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtPickDate {
            self.isPickDate = true
        } else if textField == txtDropDate {
            self.isPickDate = false
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtPickLocation {
            if let googleApi = GoogleSearch.instance() {
                googleApi.completion = {predictor, address ,error in
                    guard error == nil else {return}
                    if let predictor = predictor {
                        self.txtPickLocation.text = address
                        
                        let placeClient = GMSPlacesClient.shared()
                        placeClient.lookUpPlaceID(predictor.placeID) { (place, error) in
                            if error == nil
                            {
                                print(String(describing: (place?.coordinate.latitude)!))
                                print(String(describing: (place?.coordinate.longitude)!))
                                self.pickLat = String(describing: (place?.coordinate.latitude)!)
                                self.pickLong = String(describing: (place?.coordinate.longitude)!)
                                
                            }
                        }
                    }
                }
                googleApi.modalPresentationStyle = .fullScreen
                self.present(googleApi, animated: true, completion: nil)
            }
        } else if textField == txtDropLocation {
            if let googleApi = GoogleSearch.instance() {
                googleApi.completion = {predictor, address ,error in
                    guard error == nil else {return}
                    if let predictor = predictor {
                        self.txtDropLocation.text = address
                        
                        let placeClient = GMSPlacesClient.shared()
                        placeClient.lookUpPlaceID(predictor.placeID) { (place, error) in
                            if error == nil
                            {
                                print(String(describing: (place?.coordinate.latitude)!))
                                print(String(describing: (place?.coordinate.longitude)!))
                                self.dropLat = String(describing: (place?.coordinate.latitude)!)
                                self.dropLong = String(describing: (place?.coordinate.longitude)!)
                                
                            }
                        }
                    }
                }
                googleApi.modalPresentationStyle = .fullScreen
                self.present(googleApi, animated: true, completion: nil)
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == txtDropContactName || textField == txtPickContact) {
            do {
                let regex = try NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: [])
                if regex.firstMatch(in: string, options: [], range: NSMakeRange(0, string.count)) != nil {
                    return false
                } else {
                    let maxLength = AppConstants.textFieldMaxLengeth
                    let currentString: NSString = textField.text! as NSString
                    let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
                    if newString.length > maxLength {
                        return newString.length <= maxLength
                    }
                }
            }
            catch {
                print("ERROR")
            }
        } else if textField == txtEstimatedPrize {
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            if newString.contains(".") {
                if newString.length > 8 {
                    return newString.length <= 8
                }
            } else {
                if newString.length > 5 {
                    return newString.length <= 5
                }
            }
        }
        return true
    }
}

extension AddPickupViewController: UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sizeArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(sizeArray[row].size ?? ""): \(sizeArray[row].sizeInLbs ?? "")"
    }
}

extension AddPickupViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if imageArray.count == imgPickCount {
            return imageArray.count
        }else {
            return imageArray.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == imageArray.count  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddImageCell.cellId, for: indexPath) as! AddImageCell
            cell.btnAddTappedClouser = {index in
                self.view.endEditing(true)
                self.checkCameraAccess()
            }
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewImageCell.cellId, for: indexPath) as! ViewImageCell
            cell.imgView.image = imageArray[indexPath.row]
            cell.btnRemoveTappedClouser = {index in
                self.view.endEditing(true)
                self.displayAlert(msg: AlertMessage.removeImage, ok: "Yes", cancel: "No", okAction: {
                    self.imageArray.remove(at: indexPath.row)
                }, cancelAction: nil)
                
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var frame = self.cv.frame
        frame.size.width = (self.cv.frame.width-20)/2.5
        return CGSize(width: 150, height: 150)
    }
    
}


extension AddPickupViewController: AddPickupDisplayLogic {
    func didReceiveAddPickUpResponse(message: String, successCode: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            AppConstants.appDelegate.hideIndicator()
            if successCode == "1" {
                AppConstants.appDelegate.showTopMessage(message: message, type: .Success)
                self.navigationController?.popViewController(animated: true)
                //                self.createPostDelegate?.createPost()
            }else {
                AppConstants.appDelegate.showTopMessage(message: message, type: .Error)
            }
        }
    }
    
    func didReceiveSizeResponse(response: [SizeList.ViewModel]?, message: String, successCode: String) {
        if successCode == "1" {
            if let response = response {
                self.sizeArray = response
                self.pickerView.reloadAllComponents()
            }
        } else {
            AppConstants.appDelegate.showTopMessage(message: message, type: .Error)
        }
        
    }
}

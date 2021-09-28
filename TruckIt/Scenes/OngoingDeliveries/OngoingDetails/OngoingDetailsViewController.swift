//
//  OngoingDetailsViewController.swift
//  PickUpUser
//
//  Created by hb on 23/07/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol OngoingDetailsDisplayLogic: class {
    func didReceiveDetails(response: PickUpDetail.ViewModel?, message: String, success: String)
}

class OngoingDetailsViewController: UIViewController {
    var interactor: OngoingDetailsBusinessLogic?
    var router: (NSObjectProtocol & OngoingDetailsRoutingLogic & OngoingDetailsDataPassing)?
    
    @IBOutlet weak var lblNeedCleaner: UILabel!
    @IBOutlet weak var cntBtnCancelPickUpHeight: NSLayoutConstraint!
    @IBOutlet weak var btnCancelPickup: UIButton!
    @IBOutlet weak var cv: UICollectionView!
    @IBOutlet weak var imgLast: UIImageView!
    @IBOutlet weak var lblDriverNaME: UILabel!
    @IBOutlet weak var imgDriverProfile: UIImageView!
    @IBOutlet weak var viewDriverDetail: UIView!
    @IBOutlet weak var viewOfferAmount: UIView!
    @IBOutlet weak var lblOfferAmount: UILabel!
    @IBOutlet weak var lblEstimatedAmpount: UILabel!
    @IBOutlet weak var lblPickSize: UILabel!
    @IBOutlet weak var lblDropDate: UILabel!
    @IBOutlet weak var lblDropContactNumber: UILabel!
    @IBOutlet weak var lblDropContactName: UILabel!
    @IBOutlet weak var lblDropLocation: UILabel!
    @IBOutlet weak var lblPickDate: UILabel!
    @IBOutlet weak var lblPickContactnumber: UILabel!
    @IBOutlet weak var lblPickContactName: UILabel!
    @IBOutlet weak var lblPickDetailLocation: UILabel!
    @IBOutlet weak var imgPickedUp: UIImageView!
    @IBOutlet weak var viewPickedImages: UIView!
    
    var driverTappedCallBack: ((String)->())?
    
    var parentVC : OngoingDeliveriesViewController!
    
    var imageArray = [String]()
    var type = "pending"
    var details: PickUpDetail.ViewModel?
    
    var pickedUpPhoto = ""
    var driverId = ""
    
    /// Insatance
    ///
    /// - Returns: OngoingDetailsViewController
    class func instance() -> OngoingDetailsViewController? {
        return StoryBoard.OngoingDeliveries.board.instantiateViewController(withIdentifier: AppClass.OngoingDetailsVc.rawValue) as? OngoingDetailsViewController
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
        let interactor = OngoingDetailsInteractor()
        let presenter = OngoingDetailsPresenter()
        let router = OngoingDetailsRouter()
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
        cv.delegate = self
        cv.dataSource = self
        setData()
    }
    
    /// Set Pick up details
    func setData() {
        if let response = self.details {
            self.imageArray.removeAll()
            if let images = response.pickUpImages {
                for items in images {
                    self.imageArray.append(items.image ?? "")
                }
            }
            self.lblPickDetailLocation.text = response.pickUpLocation
            self.lblDropLocation.text = response.dropOffLocation
            self.lblPickContactName.text = response.pickUpContactName
            
            if response.pickUpStatus == ProgressState.OfferAccepted.rawValue {
                btnCancelPickup.isHidden = false
                cntBtnCancelPickUpHeight.constant = 40
            } else {
                btnCancelPickup.isHidden = true
                cntBtnCancelPickUpHeight.constant = 0
            }
            
            var aStr = response.pickUpContactNumber?.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "-", with: "")
            if (aStr!.count) >= 10
            {
                aStr = aStr!.substring(start: 0, end: 10)
            }
            let str = aStr!.toPhoneNumber()
            self.lblPickContactnumber.text = str
            
            self.lblDropContactName.text = response.dropContactName
            
            var aStr1 = response.dropContactNumber?.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: "-", with: "")
            if (aStr1!.count) >= 10
            {
                aStr1 = aStr1!.substring(start: 0, end: 10)
            }
            let str1 = aStr1!.toPhoneNumber()
            self.lblDropContactNumber.text = str1
            
            self.lblPickSize.text = "\(response.size ?? ""): \(response.sizeInLbs ?? "")"
            self.lblEstimatedAmpount.text = "$\(GlobalUtility.shared.roundOffTextTwoDigit(response.estimatedAmount ?? "0.00"))"
            
            lblPickDate.text = GlobalUtility.shared.getFormattedDate(date: response.pickUpAt ?? "0000-00-00 00:00:00")
            lblDropDate.text = GlobalUtility.shared.getFormattedDate(date: response.pickUpAt ?? "0000-00-00 00:00:00")
            self.lblNeedCleaner.text = (response.helper_required ?? "").uppercased()
            if (response.helper_required ?? "") == "Yes" {
            
                self.lblNeedCleaner.textColor = UIColor(named: "AppGreenColor")
            }else {
                self.lblNeedCleaner.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }
            lblDriverNaME.text = response.driverName
            self.lblOfferAmount.text = "$\(GlobalUtility.shared.roundOffTextTwoDigit(response.offerAmount ?? "0.00"))"
            self.imgDriverProfile.setImage(with: response.driverProfile, placeHolder: #imageLiteral(resourceName: "sign_up_user"), completed: nil)
            self.driverId = response.driverId ?? ""
            self.imgPickedUp.setImage(with: response.pickedupPhoto, placeHolder: #imageLiteral(resourceName: "no_img"))
            self.pickedUpPhoto = response.pickedupPhoto ?? ""
            if details?.pickUpStatus != (ProgressState.OfferAccepted.rawValue) {
                self.viewPickedImages.isHidden = false
            } else {
                self.viewPickedImages.isHidden = true
            }
            
            if self.type == "pending" {
                self.viewDriverDetail.isHidden = true
                self.imgLast.isHidden = true
                self.viewOfferAmount.isHidden = true
            } else if type == "ongoing" {
                self.viewDriverDetail.isHidden = false
                self.imgLast.isHidden = false
                self.viewOfferAmount.isHidden = false
            } else {
                self.viewDriverDetail.isHidden = false
                self.imgLast.isHidden = false
                self.viewOfferAmount.isHidden = false
            }
        }
    }
    
    @IBAction func btnPickUpMapAction(_ sender: Any) {
          GlobalUtility.shared.showMapOption(latitude:self.details?.pickUpLatitude ?? "", longitude:self.details?.pickUpLongitude ?? "", address:self.lblPickDetailLocation.text ?? "",target: self)
     }
     
     @IBAction func btnDropOffMapAction(_ sender: Any) {
            GlobalUtility.shared.showMapOption(latitude:self.details?.dropOffLatitude ?? "", longitude:self.details?.dropOffLongitude ?? "", address:self.details?.dropOffLocation ?? "",target: self)
     }
     
    
    @IBAction func btnPickedUpImageTap(_ sender: UIButton) {
        if self.pickedUpPhoto != "" {
            self.showImageDetailView(arrImage: [self.pickedUpPhoto])
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addAnayltics(analyticsParameterItemID: "id-ongoingdeliverydetailscreen", analyticsParameterItemName: "view_ongoingdeliverydetailscreen", analyticsParameterContentType: "view_ongoingdeliverydetailscreen")
        
        parentVC.currentIndex = 0
        parentVC.checkStatus(index: 0)
        let request = PickUpDetail.Request(pickUpId: self.details?.pickupId ?? "")
        self.interactor?.pickUpDetail(request: request, showLoader: true)
    }
    
    /// View Driver Profile tap action
    ///
    /// - Parameter sender: UIButton
    @IBAction func btnDriverTapped(_ sender: UIButton) {
        if self.driverTappedCallBack != nil {
            self.driverTappedCallBack!(self.driverId)
        }
    }
    
    /// Call drop contact person tap action
    ///
    /// - Parameter sender: UIButton
    @IBAction func btnDropContactNumber(_ sender: UIButton) {
            guard let number = URL(string: "tel://" + (self.details?.dropContactNumber ?? "")) else { return }
            UIApplication.shared.open(number)
    }
    
    /// Call Pick up contact person tap action
    ///
    /// - Parameter sender: UIButton
    @IBAction func btnPickupPhone(_ sender: UIButton) {
            guard let number = URL(string: "tel://" + (self.details?.pickUpContactNumber ?? "")) else { return }
            UIApplication.shared.open(number)
    }
    
    /// Cancel Pickup tap action
    ///
    /// - Parameter sender: UIButton
    @IBAction func btnCancelPickupTapped(_ sender: UIButton) {
        if let cancelVc = CancelPickupViewController.instance() {
            cancelVc.pickupId = self.details?.pickupId ?? ""
            cancelVc.isAccepted = true
            cancelVc.completion = {SuccessReponse in
                if SuccessReponse == "success" {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            self.present(cancelVc, animated: true, completion: nil)
        }
    }
}

extension OngoingDetailsViewController: OngoingDetailsDisplayLogic {
    func didReceiveDetails(response: PickUpDetail.ViewModel?, message: String, success: String) {
        if success == "1" {
            if let response = response {
                self.details = response
                self.parentVC.details = response
                self.setData()
            }
        } else {
            AppConstants.appDelegate.showTopMessage(message: message, type: .Error)
        }
    }
}

extension OngoingDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.cellId, for: indexPath) as! ImageCell
        cell.imgView.setImage(with: self.imageArray[indexPath.row],placeHolder:#imageLiteral(resourceName: "no_img"))
        cell.buttonTapped = {index in
            self.showImageDetailView(arrImage: [self.imageArray[indexPath.row]])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 120)
    }
}
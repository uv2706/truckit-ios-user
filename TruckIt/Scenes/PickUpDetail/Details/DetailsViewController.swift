//
//  DetailsViewController.swift
//  PickUpUser
//
//  Created by hb on 17/06/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import SKPhotoBrowser

protocol DetailsDisplayLogic: class {
    func didReceiveDetails(response: PickUpDetail.ViewModel?, message: String, success: String)
}

class DetailsViewController: UIViewController, DetailsDisplayLogic {
    
    @IBOutlet weak var lblCleanerHelp: UILabel!
    
    
    @IBOutlet weak var imgLast: UIImageView!
    @IBOutlet weak var cv: UICollectionView!
    
    @IBOutlet weak var lblDriverNaME: UILabel!
    @IBOutlet weak var imgDriverProfile: UIImageView!
    @IBOutlet weak var viewDriverDetail: UIView!
    var interactor: DetailsBusinessLogic?
    var router: (NSObjectProtocol & DetailsRoutingLogic & DetailsDataPassing)?
    
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
    @IBOutlet weak var btnCancelPickUp: UIButton!

    var driverTappedCallBack: ((String)->())?
    
    var parentVC : PickUpDetailViewController!
    
    var imageArray = [String]()
    var type = "pending"
    var details: PickUpDetail.ViewModel?
    
    var driverId = ""
    
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
    /// - Returns: DetailsViewController
    class func instance() -> DetailsViewController? {
        return StoryBoard.PickUpDetail.board.instantiateViewController(withIdentifier: AppClass.DetailsVc.rawValue) as? DetailsViewController
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = DetailsInteractor()
        let presenter = DetailsPresenter()
        let router = DetailsRouter()
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
    
    /// Set Pick up detail and UI
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
            lblDropDate.text = GlobalUtility.shared.getFormattedDate(date: response.dropOffAt ?? "0000-00-00 00:00:00")
            
            lblDriverNaME.text = response.driverName
            self.lblOfferAmount.text = "$\(GlobalUtility.shared.roundOffTextTwoDigit(response.offerAmount ?? "0.00"))"
            self.imgDriverProfile.setImage(with: response.driverProfile,placeHolder:#imageLiteral(resourceName: "sign_up_user"))
            self.driverId = response.driverId ?? ""
            
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
            
            self.lblCleanerHelp.text = (response.helper_required ?? "").uppercased()
            if response.helper_required ?? "" == "Yes" {
                self.lblCleanerHelp.textColor = UIColor(named: "AppGreenColor")
            }else {
                self.lblCleanerHelp.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addAnayltics(analyticsParameterItemID: "id-pendingdeliverydetailscreen", analyticsParameterItemName: "view_pendingdeliverydetailscreen", analyticsParameterContentType: "view_pendingdeliverydetailscreen")
        
        parentVC.currentIndex = 0
        parentVC.checkStatus(index: 0)
        let request = PickUpDetail.Request(pickUpId: self.details?.pickupId ?? "")
        self.interactor?.pickUpDetail(request: request, showLoader : true)
    }
    
    /// View driver profile tap action with callback to superclass
    ///
    /// - Parameter sender: UIButton
    @IBAction func btnDriverTapped(_ sender: UIButton) {
        if self.driverTappedCallBack != nil {
            self.driverTappedCallBack!(self.driverId)
        }
    }
    
    @IBAction func btnPickUpMapAction(_ sender: Any) {
         GlobalUtility.shared.showMapOption(latitude:self.details?.pickUpLatitude ?? "", longitude:self.details?.pickUpLongitude ?? "", address:self.lblPickDetailLocation.text ?? "",target: self)
    }
    
    @IBAction func btnDropOffMapAction(_ sender: Any) {
           GlobalUtility.shared.showMapOption(latitude:self.details?.dropOffLatitude ?? "", longitude:self.details?.dropOffLongitude ?? "", address:self.details?.dropOffLocation ?? "",target: self)
    }
    @IBAction func btnCancelPickUpAction(_ sender: Any) {
        //   let request = PickUpDetail.Request(pickUpId: self.details?.pickupId ?? "")
        //     self.interactor?.pickUpCancel(request: request, showLoader: true)
        
        if let cancelVc = CancelPickupViewController.instance() {
            cancelVc.pickupId = self.details?.pickupId ?? ""
            cancelVc.isAccepted = false
            cancelVc.completion = {successReponse in
                if successReponse == "success" {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            cancelVc.modalPresentationStyle = .overCurrentContext
            self.present(cancelVc, animated: true, completion: nil)
        }
        
    }
    
    
    func didReceiveDetails(response: PickUpDetail.ViewModel?, message: String, success: String) {
        if success == "1" {
            if let response = response {
                self.details = response
                setData()
                self.parentVC.details = response
            }
        } else {
            AppConstants.appDelegate.showTopMessage(message: message, type: .Error)
        }
    }
}

extension DetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.cellId, for: indexPath) as! ImageCell
        cell.imgView.setImage(with: self.imageArray[indexPath.row], placeHolder:#imageLiteral(resourceName: "no_img"))
        cell.buttonTapped = {index in
            self.showImageDetailView(arrImage: [self.imageArray[indexPath.row]])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 120)
    }
}
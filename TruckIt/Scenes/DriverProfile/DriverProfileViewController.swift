//
//  DriverProfileViewController.swift
//  PickUpUser
//
//  Created by hb on 20/06/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol DriverProfileDisplayLogic: class {
    func didReceiveDriverDetail(response: DriverProfile.ViewModel?, message: String, success: String)
}

class DriverProfileViewController: UIViewController {

    @IBOutlet weak var lblNoRatings: UILabel!
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var btnChat: UIButton!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var btnReviewRatingDriver: UIButton!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var viewStar: SwiftyStarRatingView!
    @IBOutlet weak var lblSuccessfullRides: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblDriverName: UILabel!
    
    var type = "pending"
    var interactor: DriverProfileBusinessLogic?
    var router: (NSObjectProtocol & DriverProfileRoutingLogic & DriverProfileDataPassing)?
    var driverId = ""
    var pickUpId = ""
    var driverDetail: DriverProfile.ViewModel.DriverDetail?
    var review = [DriverProfile.ViewModel.DriverReview]()
    
    /// Insatance
    ///
    /// - Returns: DriverProfileViewController
    class func instance() -> DriverProfileViewController? {
        return StoryBoard.DriverProfile.board.instantiateViewController(withIdentifier: AppClass.DriverProfileVc.rawValue) as? DriverProfileViewController
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
        let interactor = DriverProfileInteractor()
        let presenter = DriverProfilePresenter()
        let router = DriverProfileRouter()
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
        self.navigationItem.title = "View Driver Details"
        self.navigationItem.rightBarButtonItem = self.getOtherButton(image:#imageLiteral(resourceName: "error_btn"), selected_image: #imageLiteral(resourceName: "error_btn"), action: #selector(btnReportTapped), target: self)
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.viewBG.layer.cornerRadius = 5
        self.viewBG.layer.borderColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        self.viewBG.layer.borderWidth = 0.5
        if !(NetworkManager.shared.reachabilityManager?.isReachable)! {
            AppConstants.appDelegate.showTopMessage(message: AlertMessage.networkConnection, type: .Error)
        } else {
            let req = DriverProfile.Request(driverId: self.driverId)
            self.interactor?.driverDetail(request: req)
        }
    }
    
    /// Report user tap action
    @objc func btnReportTapped() {
        if let reportVc = ReportUserViewController.instance() {
            reportVc.driverId = self.driverId
            reportVc.completion = {
                let req = DriverProfile.Request(driverId: self.driverId)
                self.interactor?.driverDetail(request: req)
            }
            reportVc.modalPresentationStyle = .overCurrentContext
            self.present(reportVc, animated: true, completion: nil)
        }
    }
    
    /// Set up driverData
    func setDriverData() {
        if let driver = self.driverDetail {
            self.imgViewProfile.setImage(with: driver.driverProfile,placeHolder:#imageLiteral(resourceName: "sign_up_user"))
            self.lblDriverName.text = driver.name
            self.lblLocation.text = driver.bio
            
            self.lblLocation.layoutIfNeeded()
            
            self.lblSuccessfullRides.text = "Successfull Deliveries #\(driver.successfullDeliveries ?? "0")"
            if let ratings = driver.avgRating, ratings != "", ratings != "0", ratings != "0.00", ratings != "0.0" {
                self.viewStar.isHidden = false
                self.lblNoRatings.isHidden = true
                self.viewStar.value = CGFloat(Float(ratings) ?? 0)
            } else {
                self.viewStar.isHidden = true
                self.lblNoRatings.isHidden = false
            }
        }
        self.tblView.tableHeaderView = viewBG
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Set up Table header view height
        let h = self.lblLocation.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        var lblFrame = self.lblLocation.frame
        lblFrame.size.height = h
        self.lblLocation.frame = lblFrame
        self.lblLocation.layoutIfNeeded()
        if let headerView = tblView.tableHeaderView {
            
            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var headerFrame = headerView.frame
            
            //Comparison necessary to avoid infinite loop
            if height != headerFrame.size.height {
                headerFrame.size.height = height
                headerView.frame = headerFrame
                tblView.tableHeaderView = headerView
            }
            
            tblView.layoutIfNeeded()
        }
    }    
}

extension DriverProfileViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.review.count > 0 ? self.review.count:1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.review.count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: DriverRatingCell.cellId, for: indexPath) as! DriverRatingCell
            cell.setData(data: self.review[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: NoRecordCell.cellId, for: indexPath) as! NoRecordCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let aView = UIView(frame: CGRect(x: 0, y: 0, width: tblView.frame.width, height: 40))
        aView.backgroundColor = UIColor.clear
        let aLabel = UILabel(frame: CGRect(x: 10, y: 5, width: aView.frame.width, height: 30))
        aLabel.text = "Reviews"
        aLabel.textColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        aLabel.font = UIFont(name: "Montserrat-Semibold", size: 16)
        aView.addSubview(aLabel)
        
        return aView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

extension DriverProfileViewController: DriverProfileDisplayLogic {
    func didReceiveDriverDetail(response: DriverProfile.ViewModel?, message: String, success: String) {
        if success == "1" {
            if let response = response {
                if let detail = response.driverDetail, detail.count > 0 {
                    self.driverDetail = detail.first
                    self.setDriverData()
                }
                if let review = response.driverReview {
                     self.review = review
                }
                self.tblView.reloadData()
            }
        } else {
            AppConstants.appDelegate.showTopMessage(message: message, type: .Error)
        }
    }
}

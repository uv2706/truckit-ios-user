//
//  PastViewController.swift
//  PickUpUser
//
//  Created by hb on 14/06/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import CRRefresh

protocol PastDisplayLogic: class {
     func didReceivePastDeliveries(response: [Deliveries.ViewModel]?, message: String, success: String)
}

class PastViewController: UIViewController {
    var interactor: PastBusinessLogic?
    var router: (NSObjectProtocol & PastRoutingLogic & PastDataPassing)?
    
    var tapHandler: ((Deliveries.ViewModel)->())?
     @IBOutlet weak var viewNoRecord: UIView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblNoRecord: UILabel!
    var pastDeliveries = [Deliveries.ViewModel]()
    
    var parentVC : DeliveriesViewController!
    // MARK: Object lifecycle
    
    /// Insatance
    ///
    /// - Returns: OngoingViewController
    class func instance() -> PastViewController? {
        return StoryBoard.Deliveries.board.instantiateViewController(withIdentifier: AppClass.PastVc.rawValue) as? PastViewController
    }
    
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
        let interactor = PastInteractor()
        let presenter = PastPresenter()
        let router = PastRouter()
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
        setupLayput()
    }
    
    /// Setup UI
    func setupLayput() {
        self.tblView.delegate = self
        self.tblView.dataSource = self
        
        tblView.cr.addHeadRefresh(animator:FastAnimator(frame: tblView.frame, color: UIColor.white, arrowColor: AppConstants.appColor, lineWidth: 1.5)) { [weak self] in
            let req = Deliveries.Request(type: "Past")
            self?.interactor?.pastRequest(request: req, showLoader: false)
        }
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addAnayltics(analyticsParameterItemID: "id-mydeliverypastscreen", analyticsParameterItemName: "view_mydeliverypastscreen", analyticsParameterContentType: "view_mydeliverypastscreen")
        parentVC.currentIndex = 0
        parentVC.checkStatus(index: 0)
        
        if !(NetworkManager.shared.reachabilityManager?.isReachable)! {
            lblNoRecord.text = AlertMessage.networkConnection
            viewNoRecord.isHidden = false
        } else {
            let req = Deliveries.Request(type: "Past")
            self.interactor?.pastRequest(request: req, showLoader: true)
        }
    }
}

extension PastViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pastDeliveries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let aModel = pastDeliveries[indexPath.row]
        
        if aModel.driverName?.count ?? 0 > 0 && aModel.driverId?.count ?? 0 > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: PastCell.cellId, for: indexPath) as! PastCell
            cell.setUpData(data: pastDeliveries[indexPath.row])
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: PastCell.cellCancelId, for: indexPath) as! PastCell
            cell.setUpData(data: pastDeliveries[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.tapHandler != nil {
            self.tapHandler!(pastDeliveries[indexPath.row])
        }
    }
}

extension PastViewController: PastDisplayLogic {
    func didReceivePastDeliveries(response: [Deliveries.ViewModel]?, message: String, success: String) {
        if success == "1" {
            self.tblView.cr.endHeaderRefresh()
            if let response = response {
                self.viewNoRecord.isHidden = true
                self.pastDeliveries = response
                self.tblView.reloadData()
            }
        } else {
            self.tblView.cr.endHeaderRefresh()
            self.viewNoRecord.isHidden = false
            self.lblNoRecord.text = message
            self.pastDeliveries.removeAll()
            self.tblView.reloadData()
        }
    }
}
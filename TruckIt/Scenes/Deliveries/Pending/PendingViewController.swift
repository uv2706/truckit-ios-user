//
//  PendingViewController.swift
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

protocol PendingDisplayLogic: class {
    func didReceivePendingDeliveries(response: [Deliveries.ViewModel]?, message: String, success: String)
}

class PendingViewController: UIViewController {
    var interactor: PendingBusinessLogic?
    var router: (NSObjectProtocol & PendingRoutingLogic & PendingDataPassing)?
    
    var tapHandler: ((Deliveries.ViewModel)->())?
    
    @IBOutlet weak var viewNoRecord: UIView!
    @IBOutlet weak var lblNoRecord: UILabel!
    @IBOutlet weak var tblView: UITableView!
    var parentVC : DeliveriesViewController!
    var pendingDeliveries = [Deliveries.ViewModel]()
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
    /// - Returns: PendingViewController
    class func instance() -> PendingViewController? {
        return StoryBoard.Deliveries.board.instantiateViewController(withIdentifier: AppClass.PendingVc.rawValue) as? PendingViewController
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = PendingInteractor()
        let presenter = PendingPresenter()
        let router = PendingRouter()
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
    
    /// Set up UI
    func setupLayout() {
        self.tblView.delegate = self
        self.tblView.dataSource = self
        
        tblView.cr.addHeadRefresh(animator:FastAnimator(frame: tblView.frame, color: UIColor.white, arrowColor: AppConstants.appColor, lineWidth: 1.5))  { [weak self] in
            let req = Deliveries.Request(type: "Pending")
            self?.interactor?.pendingRequest(request: req, showLoader: false)
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addAnayltics(analyticsParameterItemID: "id-mydeliverypendingscreen", analyticsParameterItemName: "view_mydeliverypendingscreen", analyticsParameterContentType: "view_mydeliverypendingscreen")
        
        let req = Deliveries.Request(type: "Pending")
        self.interactor?.pendingRequest(request: req, showLoader: false)
        parentVC.currentIndex = 2
        parentVC.checkStatus(index: 2)
        
        if !(NetworkManager.shared.reachabilityManager?.isReachable)! {
            lblNoRecord.text = AlertMessage.networkConnection
            viewNoRecord.isHidden = false
        } else {
            let req = Deliveries.Request(type: "Pending")
            self.interactor?.pendingRequest(request: req, showLoader: true)
        }
    }
}

extension PendingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pendingDeliveries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PendingCell.cellId, for: indexPath) as! PendingCell
        cell.setUpData(data: pendingDeliveries[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.tapHandler != nil {
            self.tapHandler!(pendingDeliveries[indexPath.row])
        }
    }
}

extension PendingViewController: PendingDisplayLogic {
    func didReceivePendingDeliveries(response: [Deliveries.ViewModel]?, message: String, success: String) {
        if success == "1" {
            self.tblView.cr.endHeaderRefresh()
            if let response = response {
                self.viewNoRecord.isHidden = true
                self.pendingDeliveries = response
                self.tblView.reloadData()
            }
        } else {
            self.tblView.cr.endHeaderRefresh()
            self.viewNoRecord.isHidden = false
            self.lblNoRecord.text = message
            self.pendingDeliveries.removeAll()
            self.tblView.reloadData()
        }
    }
}

//
//  OngoingViewController.swift
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

protocol OngoingDisplayLogic: class {
     func didReceiveOngoingDeliveries(response: [Deliveries.ViewModel]?, message: String, success: String)
}

class OngoingViewController: UIViewController {
    var interactor: OngoingBusinessLogic?
    var router: (NSObjectProtocol & OngoingRoutingLogic & OngoingDataPassing)?
    
    var tapHandler: ((Deliveries.ViewModel)->())?
    var parentVC : DeliveriesViewController!

    @IBOutlet weak var viewNoRecord: UIView!
    @IBOutlet weak var lblNoRecord: UILabel!
    @IBOutlet weak var tblView: UITableView!
    var ongoingDeliveries = [Deliveries.ViewModel]()
    // MARK: Object lifecycle
    
    /// Insatance
    ///
    /// - Returns: OngoingViewController
    class func instance() -> OngoingViewController? {
        return StoryBoard.Deliveries.board.instantiateViewController(withIdentifier: AppClass.OngoingVc.rawValue) as? OngoingViewController
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
        let interactor = OngoingInteractor()
        let presenter = OngoingPresenter()
        let router = OngoingRouter()
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
    
    /// Setup UI
    func setupLayout() {
        self.tblView.delegate = self
        self.tblView.dataSource = self
        
        tblView.cr.addHeadRefresh(animator:FastAnimator(frame: tblView.frame, color: UIColor.white, arrowColor: AppConstants.appColor, lineWidth: 1.5)) { [weak self] in
            let req = Deliveries.Request(type: "Ongoing")
            self?.interactor?.ongoingRequest(request: req, showLoader: false)
        }
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addAnayltics(analyticsParameterItemID: "id-mydeliveryongoingscreen", analyticsParameterItemName: "view_mydeliveryongoingscreen", analyticsParameterContentType: "view_mydeliveryongoingscreen")
        
        if !(NetworkManager.shared.reachabilityManager?.isReachable)! {
            lblNoRecord.text = AlertMessage.networkConnection
            viewNoRecord.isHidden = false
        } else {
            let req = Deliveries.Request(type: "Ongoing")
            self.interactor?.ongoingRequest(request: req, showLoader: true)
        }
        
        parentVC.currentIndex = 1
        parentVC.checkStatus(index: 1)
    }
    
  
}

extension OngoingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ongoingDeliveries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OngoingCell.cellId, for: indexPath) as! OngoingCell
        cell.setUpData(data: ongoingDeliveries[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.tapHandler != nil {
            self.tapHandler!(ongoingDeliveries[indexPath.row])
        }
    }
}

extension OngoingViewController: OngoingDisplayLogic {
    func didReceiveOngoingDeliveries(response: [Deliveries.ViewModel]?, message: String, success: String) {
        if success == "1" {
            self.tblView.cr.endHeaderRefresh()
            if let response = response {
                self.viewNoRecord.isHidden = true
                self.ongoingDeliveries = response
                self.tblView.reloadData()
            }
        } else {
            self.tblView.cr.endHeaderRefresh()
            self.viewNoRecord.isHidden = false
            self.lblNoRecord.text = message
            self.ongoingDeliveries.removeAll()
            self.tblView.reloadData()
        }
    }
}

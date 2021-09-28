//
//  PickUpDetailViewController.swift
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

protocol PickUpDetailDisplayLogic: class {
    func didReceiveDetails(response: PickUpDetail.ViewModel?, message: String, success: String)
}

class PickUpDetailViewController: UIViewController {
    
    @IBOutlet weak var imgProgress: UIImageView!
    @IBOutlet weak var imgOffer: UIImageView!
    @IBOutlet weak var imgDetail: UIImageView!
    @IBOutlet weak var btnOffers: UIButton!
    @IBOutlet weak var btnProgress: UIButton!
    @IBOutlet weak var btnDetails: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    var interactor: PickUpDetailBusinessLogic?
    var router: (NSObjectProtocol & PickUpDetailRoutingLogic & PickUpDetailDataPassing)?
    
    var type = "pending"
    var forOffer = false
    var userPhone = ""
    var pickUpId = ""
    var isUnreadClear = false
    var pageController : UIPageViewController!
    var currentIndex = 0
    var processVc : ProcessViewController!
    var offerVc : OffersViewController!
    var detailVc : DetailsViewController!
    var arrVC = [UIViewController]()
    
    var details: PickUpDetail.ViewModel?
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
    /// - Returns: PickUpDetailViewController
    class func instance() -> PickUpDetailViewController? {
        return StoryBoard.PickUpDetail.board.instantiateViewController(withIdentifier: AppClass.PickUpDetailVc.rawValue) as? PickUpDetailViewController
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = PickUpDetailInteractor()
        let presenter = PickUpDetailPresenter()
        let router = PickUpDetailRouter()
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isUnreadClear {
            self.navigationItem.rightBarButtonItems = [self.getOtherButton(image: #imageLiteral(resourceName: "speech-bubble-couple-of-black-rectangular-shapes"), selected_image: #imageLiteral(resourceName: "speech-bubble-couple-of-black-rectangular-shapes"), action: #selector(btnChatTapped), target: self), self.getOtherButton(image: #imageLiteral(resourceName: "telephone"), selected_image: #imageLiteral(resourceName: "telephone"), action: #selector(btnCallTapped), target: self)]
        }
    }
    
    /// Initialize Detail, offer, process viewController
    func initializeControllers() {
        if pageController == nil {
            processVc =  ProcessViewController.instance()
            offerVc =  OffersViewController.instance()
            detailVc =  DetailsViewController.instance()
            
            weak var weakSelf = self
            processVc.parentVC = weakSelf
            offerVc.parentVC = weakSelf
            detailVc.parentVC = weakSelf
            
            offerVc.pickUpId = self.pickUpId
            
            if self.details != nil {
                self.detailVc.details = self.details
                self.processVc.details = self.details
                self.offerVc.pickDetail = self.details
            }
            
            detailVc.type = self.type
            detailVc.driverTappedCallBack = {id in
                if let driverDetail = DriverProfileViewController.instance() {
                    driverDetail.type = self.type
                    driverDetail.driverId = id
                    driverDetail.pickUpId = self.pickUpId
                    self.navigationController?.pushViewController(driverDetail, animated: true)
                }
                
            }
            
            pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
            pageController.isPagingEnabled = true
            pageController.dataSource  = self
            pageController.delegate  = self
            arrVC = [detailVc,offerVc,processVc]
            
            
            pageController.setViewControllers([detailVc], direction: .reverse, animated: false, completion: nil)
            
            self.addChild(pageController)
            containerView.addSubview(pageController.view)
            pageController.view.frame = containerView.bounds
        }
    }
    
    /// Set default offer tab
    func setOfferTab() {
        if self.pageController.viewControllers?.last is ProcessViewController {
            self.pageController.setViewControllers([(self.offerVc)!], direction: .reverse, animated: true, completion: { (finished) in
                let aVC = self.pageController
                DispatchQueue.main.async {
                    
                    aVC?.setViewControllers([(self.offerVc)!], direction: .forward, animated:true, completion: nil)
                }
            })
        } else {
            self.pageController.setViewControllers([(self.offerVc)!], direction: .forward, animated: true, completion: { (finished) in
                let aVC = self.pageController
                DispatchQueue.main.async {
                    
                    aVC?.setViewControllers([(self.offerVc)!], direction: .reverse, animated:true, completion: nil)
                }
            })
        }
        self.currentIndex = 1
        self.checkStatus(index: 1)
    }
    
    /// Call button tap action
    @objc func btnCallTapped() {
        if self.userPhone != "" {
            guard let number = URL(string: "tel://" + self.userPhone) else { return }
            UIApplication.shared.open(number)
        } else {
            AppConstants.appDelegate.showTopMessage(message: AlertMessage.phoneNotAvailable, type: .Error)
        }
    }
    
    /// Setup Textfield and UI
    func setupLayout() {
        self.navigationItem.title = "Details"
        
        if !(NetworkManager.shared.reachabilityManager?.isReachable)! {
            initializeControllers()
            AppConstants.appDelegate.showTopMessage(message: AlertMessage.networkConnection, type: .Error)
        } else {
            let request = PickUpDetail.Request(pickUpId: self.pickUpId)
            self.interactor?.pickUpDetail(request: request)
        }
        
        if type == "pending" {
            btnDetails.isHidden = false
            btnOffers.isHidden = false
            btnProgress.isHidden = false
        } else if type == "ongoing" {
            btnDetails.isHidden = false
            btnOffers.isHidden = true
            btnProgress.isHidden = false
            
        } else {
            btnDetails.isHidden = false
            btnOffers.isHidden = true
            btnProgress.isHidden = true
        }
    }
    
    /// Button chat message tap action
    @objc func btnChatTapped() {
        if let message = MessageViewController.instance() {
            message.isOngoing = true
            message.pickUpId = self.pickUpId
            message.driverId = self.details?.driverId ?? ""
            self.isUnreadClear = true
            self.navigationController?.pushViewController(message, animated: true)
        }
    }
    
    /// Button Action for Detail,Offers,Progress
    ///
    /// - Parameter sender: UIButton
    @IBAction func btnOptionTapped(_ sender: UIButton) {
        switch sender {
        case btnDetails:
            self.pageController.setViewControllers([(self.detailVc)!], direction: .reverse, animated: true, completion: { (finished) in
                let aVC = self.pageController
                DispatchQueue.main.async {
                    aVC?.setViewControllers([(self.detailVc)!], direction: .forward, animated:true, completion: nil)
                }
            })
            self.checkStatus(index: 0)
        case btnOffers:
            setOfferTab()
        case btnProgress:
            self.pageController.setViewControllers([(self.processVc)!], direction: .forward, animated: true, completion: { (finished) in
                let aVC = self.pageController
                DispatchQueue.main.async {
                    aVC?.setViewControllers([(self.processVc)!], direction: .reverse, animated:true, completion: nil)
                }
            })
            self.checkStatus(index: 2)
        default:
            self.pageController.setViewControllers([(self.detailVc)!], direction: .forward, animated: true, completion: { (finished) in
                let aVC = self.pageController
                DispatchQueue.main.async {
                    aVC?.setViewControllers([(self.detailVc)!], direction: .forward, animated:true, completion: nil)
                }
            })
            self.checkStatus(index: 0)
        }
    }
    
    /// check selected viewController Status
    ///
    /// - Parameter index: current index
    func checkStatus(index:Int) {
        switch index {
        case 0:
            btnDetails.isSelected = true
            btnOffers.isSelected = false
            btnProgress.isSelected = false
            
            imgDetail.isHidden = false
            imgOffer.isHidden = true
            imgProgress.isHidden = true
            
        case 1:
            btnDetails.isSelected = false
            btnOffers.isSelected = true
            btnProgress.isSelected = false
            
            imgDetail.isHidden = true
            imgOffer.isHidden = false
            imgProgress.isHidden = true
        case 2:
            btnDetails.isSelected = false
            btnOffers.isSelected = false
            btnProgress.isSelected = true
            
            imgDetail.isHidden = true
            imgOffer.isHidden = true
            imgProgress.isHidden = false
        default:
            btnDetails.isSelected = true
            btnOffers.isSelected = false
            btnProgress.isSelected = false
            
            imgDetail.isHidden = false
            imgOffer.isHidden = true
            imgProgress.isHidden = true
        }
    }
    
}

extension PickUpDetailViewController : UIPageViewControllerDelegate,UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if !completed { return }
        
        guard let viewController = previousViewControllers.last else {
            return
        }
        
        self.currentIndex =  (viewController is DetailsViewController) ? 0 : ((viewController is OffersViewController) ? 1:2)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        var index =  (viewController is DetailsViewController) ? 0 : ((viewController is OffersViewController) ? 1:2)
        
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index -= 1
        
        return viewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        var index =  (viewController is DetailsViewController) ? 0 : ((viewController is OffersViewController) ? 1:2)
        
        if index == NSNotFound {
            return nil
        }
        
        index += 1
        if (index == self.arrVC.count) {
            return nil
        }
        
        return viewControllerAtIndex(index: index)
    }
    
    func viewControllerAtIndex(index: Int) -> UIViewController? {
        if self.arrVC.count == 0 || index >= self.arrVC.count {
            return nil
        }
        
        if index == 0 {
            return detailVc
        } else if index == 1 {
            return offerVc
        } else {
            return processVc
        }
    }
}

extension PickUpDetailViewController: PickUpDetailDisplayLogic {
    func didReceiveDetails(response: PickUpDetail.ViewModel?, message: String, success: String) {
        if success == "1" {
            if let response = response {
                self.details = response
                self.userPhone = response.driverPhone ?? ""
                initializeControllers()
                if forOffer {
                    setOfferTab()
                }
            }
        } else {
            AppConstants.appDelegate.showTopMessage(message: message, type: .Error)
        }
    }
}

//
//  ReviewAndRattingsViewController.swift
//  PickUpDriver
//
//  Created by hb on 02/07/19.


import UIKit
import SideMenu
import CRRefresh

protocol ReviewAndRattingsDisplayLogic: class {
    func didReceiveRatings(response: [ReviewAndRattings.ViewModel]?, message: String?, success: String)
}

class ReviewAndRattingsViewController: UIViewController {
    
    @IBOutlet weak var viewNoRecord: UIView!
    @IBOutlet weak var lblNoRecord: UILabel!
    @IBOutlet weak var tblView: UITableView!
    var interactor: ReviewAndRattingsBusinessLogic?
    var router: (NSObjectProtocol & ReviewAndRattingsRoutingLogic & ReviewAndRattingsDataPassing)?
    
    var reviews = [ReviewAndRattings.ViewModel]()
    
    class func instance() -> ReviewAndRattingsViewController? {
        return StoryBoard.ReviewAndRattings.board.instantiateViewController(withIdentifier: AppClass.ReviewAndRattingsVC.rawValue) as? ReviewAndRattingsViewController
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
        let interactor = ReviewAndRattingsInteractor()
        let presenter = ReviewAndRattingsPresenter()
        let router = ReviewAndRattingsRouter()
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
        self.navigationItem.title = "Review & Ratings"
        self.navigationItem.leftBarButtonItem = self.getButton(image: UIImage(named: "menu") ?? UIImage(), selected_image:  UIImage(named: "menu") ?? UIImage(), action: #selector(btnBackTapped), target: self)
        
        tblView.cr.addHeadRefresh(animator:FastAnimator(frame: tblView.frame, color: UIColor.lightGray, arrowColor: AppConstants.appColor, lineWidth: 1.5)) { [weak self] in
            self?.interactor?.getRatings(indicator: false)
        }
        if !(NetworkManager.shared.reachabilityManager?.isReachable)! {
            lblNoRecord.text = AlertMessage.networkConnection
            viewNoRecord.isHidden = false
        } else {
            self.interactor?.getRatings(indicator: true)
        }
        
    }
    
    /// Menu tap action
    @objc func btnBackTapped() {
        self.present(SideMenuManager.default.leftMenuNavigationController!, animated: true, completion: nil)
    }
    
}

extension ReviewAndRattingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rattingCell", for: indexPath) as! ReviewRattingTableViewCell
        cell.setData(data: reviews[indexPath.row])
        return cell
    }
}

extension ReviewAndRattingsViewController: ReviewAndRattingsDisplayLogic {
    func didReceiveRatings(response: [ReviewAndRattings.ViewModel]?, message: String?, success: String) {
        if success == "1" {
            self.tblView.cr.endHeaderRefresh()
            self.viewNoRecord.isHidden = true
            if let response = response {
                self.reviews = response
                self.tblView.reloadData()
            }
        } else {
            self.viewNoRecord.isHidden = false
            self.lblNoRecord.text = message
            self.reviews.removeAll()
            self.tblView.reloadData()
            self.tblView.cr.endHeaderRefresh()
        }
    }
}

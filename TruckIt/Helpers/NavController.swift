//
//  NavController.swift
//  FoodHub
//
//  Created by hb on 24/10/18.
//  Copyright © 2018 hb. All rights reserved.
//

import UIKit

final class NavController: UINavigationController {
    // MARK: - Lifecycle
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     if #available(iOS 13.0, *) {
          overrideUserInterfaceStyle = .light
     } else {
          // Fallback on earlier versions
     }
        
        weak var weakSelf  = self
        weakSelf?.delegate = weakSelf
        
        self.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationBar.isTranslucent = false
        interactivePopGestureRecognizer?.delegate = self
        self.navigationBar.titleTextAttributes =   [NSAttributedString.Key.foregroundColor :  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) ,NSAttributedString.Key.font : UIFont(name: "Montserrat-Medium", size: 18)!]
        self.navigationItem.hidesBackButton = false
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "top_bg").gradientImageWithBounds(bounds: CGRect(x: 0, y: 0, width: Int(AppConstants.screenWidth), height: AppConstants.NavHeight), colors: [AppConstants.appColor.cgColor,AppConstants.appColor.cgColor]), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
        
        
        UINavigationBar.appearance(whenContainedInInstancesOf: [NavController.self]).tintColor = .white
        
    }
    
    deinit {
        delegate = nil
        interactivePopGestureRecognizer?.delegate = nil
    }
    
    // MARK: - Overrides
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        duringPushAnimation = true
        super.pushViewController(viewController, animated: animated)
    }
    
    // MARK: - Private Properties
    
    fileprivate var duringPushAnimation = false
}
// MARK: - UINavigationControllerDelegate
extension NavController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController, animated: Bool) {
        /** It'll hide the Title with back button only,
         ** we'll still get the back arrow image and default functionality.
         */
        
//        let item = UIBarButtonItem(title: "", style: .plain, target: nil,
//                                   action: nil)
//        viewController.navigationItem.backBarButtonItem = item
//                let backImage = UIImage(named: "back")?.withRenderingMode(.alwaysOriginal)
//                self.navigationBar.backIndicatorImage = backImage
//                self.navigationBar.backIndicatorTransitionMaskImage = backImage
        
        
        
        let backImage = UIImage(named: "back")?.withAlignmentRectInsets(UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))

        let item = UIBarButtonItem(title: " ", style: .plain, target: nil,
                                   action: nil)
        item.image = backImage
        item.tintColor = .white
        item.imageInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        viewController.navigationItem.backBarButtonItem = item
        self.navigationBar.backIndicatorImage = backImage
        self.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationItem.leftBarButtonItem?.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0);

    }
    
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let swipeNavigationController = navigationController as? NavController else { return }
        swipeNavigationController.duringPushAnimation = false
    }
}
// MARK: - UIGestureRecognizerDelegate
extension NavController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == interactivePopGestureRecognizer else {
            return true // default value
        }
        
        // Disable pop gesture in two situations:
        // 1) when the pop animation is in progress
        // 2) when user swipes quickly a couple of times and animations don't have time to be performed
        return viewControllers.count > 1 && duringPushAnimation == false
    }
}

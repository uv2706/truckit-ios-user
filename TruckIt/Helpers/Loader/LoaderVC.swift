//
//  LoaderVC.swift
//  LISTENIN
//
//  Created by hb on 28/04/17.
//
//

import UIKit

/// Loader View controller to be added when webservice call is made
class LoaderVC:  UIViewController {

    @IBOutlet weak var viewLoader: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
     if #available(iOS 13.0, *) {
          overrideUserInterfaceStyle = .light
     } else {
          // Fallback on earlier versions
     }
      //  addAnimation()
        doInitialSettings()
      //  self.doInitialSettings()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      //  animationView.play()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
       // animationView.pause()
    }
    
    // MARK: - Class Methods
    
    /// Do Initial Settins for the loader
    func doInitialSettings()  {
        
        NVActivityIndicatorAnimationBallScaleRippleMultiple.setUpAnimation(in:self.viewLoader.layer, size: CGSize(width: 40, height: 40),color:#colorLiteral(red: 0.03921568627, green: 0.09411764706, blue: 0.3450980392, alpha: 1))
    }
    


    

}

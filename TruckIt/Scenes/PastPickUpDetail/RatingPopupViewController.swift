//
//  RatingPopupViewController.swift
//  PickUpDriver
//
//  Created by hb on 11/07/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit

class RatingPopupViewController: UIViewController {

    @IBOutlet weak var viewRating: SwiftyStarRatingView!
    @IBOutlet weak var textview: UITextView!
    
    var data: (String,String)?
    /// Insatance
    ///
    /// - Returns: RatingPopupViewController
    class func instance() -> RatingPopupViewController? {
        return StoryBoard.PastPickUpDetail.board.instantiateViewController(withIdentifier: AppClass.RatingPopupVc.rawValue) as? RatingPopupViewController
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setdata()
    }
    
    /// Set ratings data
    func setdata() {
        if data != nil {
            self.viewRating.value = CGFloat(Float(data?.0 ?? "0.0") ?? 0.0)
            self.textview.text = data?.1
        }
    }
    
    @IBAction func btndismissTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

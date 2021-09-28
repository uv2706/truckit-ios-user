//
//  YoutubeVideoPlayer.swift
//  FanFair
//
//  Created by hb on 25/08/17.
//  Copyright © 2017 hb. All rights reserved.
//

import UIKit
//import youtube_ios_player_helper
import YoutubePlayer_in_WKWebView
import AVKit

extension Notification.Name {
    static let playVideo = Notification.Name("playVideo")
}

class YoutubeVideoPlayer: UIViewController,WKYTPlayerViewDelegate {
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var youtubePlayerView: WKYTPlayerView!
    @IBOutlet weak var btnBack: UIButton!
    var strVideoID : String = ""
    var strTitle = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.youtubePlayerView.delegate = self
       // self.youtubePlayerView.load(withVideoId: strVideoID)
        youtubePlayerView.load(withVideoId:strVideoID , playerVars: ["playsinline": "1","controls": "1","showinfo": "1"])
        self.youtubePlayerView.playVideo()
     
     //   self.changeButtonImageColor(image: UIImage(named: "close")!, button: btnBack)
        
        do {
           try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: .default, options: .mixWithOthers)
        } catch {
            //print("error")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationTap), name: NSNotification.Name.init("addRemoveData"), object: nil)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lblTitle.text = self.strTitle
    }
    @objc func notificationTap() {
       self.youtubePlayerView.stopVideo()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func changeButtonImageColor(image: UIImage, button: UIButton) {
        let image = image.withRenderingMode(.alwaysTemplate)
        button.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        button.setImage(image, for: .normal)
    }
    
    
    @objc func videoDidEnterFullScreen()
    {
       // print("Did Enter")
    }
    
    @objc func videoDidExitFullScreen()
    {
        //print("Did Exit")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnDoneAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dimissVC()  {
        
        self.dismiss(animated: false, completion: nil)
    }
    
    
    // MARK :- Youtube Delegate Methods
    
    func playerViewDidBecomeReady(_ playerView: WKYTPlayerView) {
        
        self.youtubePlayerView.playVideo()
    }
    
    func playerView(_ playerView: WKYTPlayerView, didChangeTo state: WKYTPlayerState) {
        if state == .ended
        {
            self.dismiss(animated: true, completion:nil)
        }
    }
    
    
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .playVideo , object: nil)
    }
}

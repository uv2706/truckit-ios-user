//
//  StaticPageViewController.swift
//  Udecide
//
//  Created by hb on 15/04/19.
//  Copyright (c) 2019 hb. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import WebKit

protocol StaticPageDisplayLogic: class {
    func didReceiveStaticPageResponse(response: StaticPage.ViewModel?, message: String, success: String)
}

class StaticPageViewController: UIViewController {
    
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var viewMain: UIView!
    
    var interactor: StaticPageBusinessLogic?
    var router: (NSObjectProtocol & StaticPageRoutingLogic & StaticPageDataPassing)?
    
    var wkWebView: WKWebView!
    
    
    /// Insatance
    ///
    /// - Returns: StaticPageViewController
    class func instance() -> StaticPageViewController? {
        return StoryBoard.StaticPage.board.instantiateViewController(withIdentifier: AppClass.staticPageVc.rawValue) as? StaticPageViewController
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
        let interactor = StaticPageInteractor()
        let presenter = StaticPagePresenter()
        let router = StaticPageRouter()
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
        if !(NetworkManager.shared.reachabilityManager?.isReachable)! {
            txtView.text = AlertMessage.networkConnection
            self.txtView.backgroundColor = .white
            self.txtView.textColor = UIColor.black
            self.txtView.layer.cornerRadius = 5
        } else {
            let request = StaticPage.Request(pageCode: self.router?.dataStore?.pageCode ?? "")
            self.interactor?.staticPage(request: request)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLayout()
    }
    
    /// Setup Textfield and UI
    func setupLayout() {
        self.navigationItem.title = ""
        self.viewMain.layer.cornerRadius = 10
    }
    
    /// Set UpWebview
    ///
    /// - Parameter strHtml: String
    func setUpWebView(_ strHtml:String) {
     //   let aDescrip =  "<font face='Montserrat-Regular'; size='5' color='#000000'>" + strHtml
        
        
        let postFont = UIFont(name: "Montserrat-Regular", size: 16.0)
        let postWithFont = strHtml + (String(format: "<style>body{font-family: '%@'; font-size:%fpx;}i{font-family: '%@'; font-size:%fpx;}</style>", postFont?.fontName ?? "", postFont?.pointSize ?? 0.0, postFont?.fontName ?? "" + ("-Regular"), postFont?.pointSize ?? 0.0))
        
        let myParagraphStyle = NSMutableParagraphStyle()
        myParagraphStyle.alignment = .center // center the text
        myParagraphStyle.lineSpacing = 1//Change spacing between lines
        myParagraphStyle.paragraphSpacing = 5 //Change space between paragraphs
        
        let attrStr = try! NSAttributedString(
            data: postWithFont.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
            options:[NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,], documentAttributes: nil)
        // attrStr.attributes(at: [.paragraphStyle: myParagraphStyle], effectiveRange: NSRange(location: 0, length: attrStr.length))
        
        self.txtView.attributedText = attrStr
        
        if strHtml != "" {
            self.txtView.backgroundColor = .white
        }
        
        self.txtView.layer.cornerRadius = 5
        self.txtView.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
}

extension StaticPageViewController : WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView?
    {
        if navigationAction.targetFrame == nil {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            webView.load(navigationAction.request)
        }
        return nil
    }
}

extension StaticPageViewController : WKNavigationDelegate {
    func webView( _ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!)
    {
        print("StartURL: (String(describing: webView.url?.absoluteString))")
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    func webView( _ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error)
    {
        print("DIDFail: (String(describing: webView.url?.absoluteString))")
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func webView( _ webView: WKWebView, didFinish navigation: WKNavigation!)
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible  = false
        print("DIDFinish: (String(describing: webView.url?.absoluteString))")
    }
    
    func webView( _ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void)
    {
        if navigationAction.targetFrame == nil {
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            webView.load(navigationAction.request)
        }
        decisionHandler(.allow)
    }
}

extension StaticPageViewController: StaticPageDisplayLogic {
    func didReceiveStaticPageResponse(response: StaticPage.ViewModel?, message: String, success: String) {
        if success == "1" {
            if let response = response {
                self.navigationItem.title = response.pageTitle
                if let string = response.pageContent {
                    self.setUpWebView(string)
                }
            }
        } 
    }
}


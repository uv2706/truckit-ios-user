//
//  ChatBottomView.swift
//  ChatApplication
//
//  Created by Dimple Panchal on 17/05/17.
//  Copyright © 2017 CA. All rights reserved.
//

import UIKit


class ChatTextView : UITextView{
    
    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        if  action == #selector(paste(_:)) || action == #selector(cut(_:)) || action == #selector(select(_:)) || action == #selector(cut(_:)) {
            return true
        }
        return false
    }
    
}

class ChatBottomView: UIView, UITextViewDelegate {
    /// Text view to enter message
    @IBOutlet weak var textView     : UITextView!
    /// Button for send message
    @IBOutlet weak var btnSend      :   UIButton!
    /// Label for message text count
    @IBOutlet weak var lblCount: UILabel!
    var placeholderLabel : UILabel!
    
    /// Height of the keyboard
    var keyboardHeight              :   CGFloat                 = 0
    /// Max Height of Bottom View
    var maxHeight                                               = 120
    /// Min Height of Bottom View
    var minHeight                                               = 60
    /// Bool for keyboard hidden or not
    var keyboardHasBeenShown        :   Bool                    = false
    /// Update table view insets
    var updateTableViewEdgeInsets   :   ((UIEdgeInsets) -> ())?
    /// Scroll to botton of the table
    var scrollTableToBottom   :   (() -> ())?
    /// Dispose Bag to Flush all observers
    /// Max lenght of message
    let maxCount = 250
    
    var sendChatText : ((String) -> ())?
    
    /// Required to make any UI changes
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textView.backgroundColor = UIColor.white
        textView.layer.borderColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = 5
        
        textView.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Type your Messages..."
        placeholderLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        placeholderLabel.font = textView.font
        placeholderLabel.sizeToFit()
        textView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (textView.font?.pointSize)! / 2)
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        inputAccessoryView?.autoresizingMask = .flexibleBottomMargin
        
        autoresizingMask = [.flexibleBottomMargin, .flexibleHeight]
        
        self.setUpNotifications()
        self.handleSendButton()
        
        //        self.btnSend.rx.tap.subscribe({ [weak self] _ in
        //            self?.sendText()
        //        }).disposed(by: disposebag)
        
        //        self.textView.rx.didChange.asObservable().subscribe(onNext: { [weak self] in
        //            self?.handleSendButton()
        //            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        //
        //
        //        self.textView.rx.didChange.asObservable().subscribe(onNext: {[weak self] in
        //
        //            if (self?.textView.text.count)! >= (self?.maxCount)!
        //            {
        //                self?.textView.text = self?.textView.text.substring(start: 0, end: (self?.maxCount)!)
        //            }
        //            let aValue = (self?.maxCount)! - (self?.textView.text.count)!
        //            self?.lblCount.text = String(aValue)
        //
        //        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidChangeNotification), name: UITextView.textDidChangeNotification , object: self.textView)
        
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if #available(iOS 11.0, *) {
            if let window = window {
                bottomAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: window.safeAreaLayoutGuide.bottomAnchor, multiplier: 1.0).isActive = true
            }
        }
    }
    
    /// Setup notification observers
    func setUpNotifications(){
        NotificationCenter.default.addObserver(self,selector: #selector(self.keyboardWillShow(notification:)),name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.keyboardWillHide(notification:)),name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    /// Methode to change the content size of table view
    override var intrinsicContentSize: CGSize {
        let textSize = textView.sizeThatFits(CGSize(width: textView.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        return CGSize(width: bounds.width, height: CGFloat(min(maxHeight, max(Int(textSize.height + 17), minHeight ))))
        
        //        if textView.text.isEmpty
        //        {
        //            return CGSize(width: bounds.width, height: CGFloat(min(maxHeight, minHeight)))
        //        }
        //        else
        //        {
        //        }
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        return true
    }
    
    /// Enable/Disable send button
    func handleSendButton(){
        
        let trimmedString = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedString.count > 0 {
            btnSend.isEnabled = true
            btnSend.alpha = 1.0
        }
        else{
            btnSend.isEnabled = false
            btnSend.alpha = 0.5
        }
        invalidateIntrinsicContentSize()
    }
    @objc  func keyboardWillShow(notification: NSNotification) {
        let canScroll = keyboardHasBeenShown
        
        keyboardHasBeenShown = true
        guard let userInfo = (notification as Notification).userInfo else {return}
        guard let endKeyBoardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else {return}
        if self.updateTableViewEdgeInsets != nil{
            self.updateTableViewEdgeInsets!(UIEdgeInsets(top: 0, left: 0, bottom: endKeyBoardFrame - 20, right: 0))
        }
        if(canScroll){
            if let _ = self.scrollTableToBottom
            {
                self.scrollTableToBottom!()
            }
        }
        //        tableView.contentInset = UIEdgeInsetsMake(0, 0, endKeyBoardFrame - 40 , 0)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if (keyboardHasBeenShown) { // Only on the simulator (keyboard will be hidden)
            //            tableView.contentInset = UIEdgeInsetsMake(0, 0, 0 , 0)
            self.updateTableViewEdgeInsets!(UIEdgeInsets(top: 0, left: 0, bottom: 0 , right: 0))
            keyboardHasBeenShown = false
        }
    }
    
    
    /// Mthode to clear the text
    
    func sendText(){
        if(self.textView.text.count>0){
            
            //Send Message
            sendChatText?(self.textView.text)
            self.textView.text = ""
            self.textView.resignFirstResponder()
            placeholderLabel.isHidden = !textView.text.isEmpty
            // self.lblCount.text = "\(maxCount)"
            self.handleSendButton()
            invalidateIntrinsicContentSize()
        }
        
    }
    
    @IBAction func btnSendAction(_ sender: Any) {
        
        sendText()
        
    }
    @objc private func textViewDidChangeNotification(_ notif: Notification) {
        //        guard self == notif.object as? UITextView else {
        //            return
        //        }
        
        let aStr = self.textView.text
        
        if aStr!.count > 0
        {
            //self.lblPlaceholder.text = ""
        }
        
        self.handleSendButton()
        
    }
    
    
    
}

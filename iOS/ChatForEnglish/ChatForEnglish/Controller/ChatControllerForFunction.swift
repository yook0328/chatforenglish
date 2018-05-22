//
//  ChatControllerForFunction.swift
//  ChatForEnglish
//
//  Created by ARam on 2018. 1. 11..
//  Copyright © 2018년 aram. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

extension ChatController {
    @objc func handleSendText(){
        let messageRef = Database.database().reference().child("messages").childByAutoId()
        let timestamp = ServerValue.timestamp()
        let roomId : String = (self.selectedChatRoom?.id)!
        let toId : String = (selectedChatRoom?.mentor?.id)!
        let fromId : String = (Auth.auth().currentUser?.uid)!
        let text : String = (self.chatInputBar?.inputTextField?.text)!
        let type = 0
        
        var values : [String : AnyObject] = ["text": text as AnyObject, "timestamp": timestamp as AnyObject, "toId": toId as AnyObject, "fromId": fromId as AnyObject, "type": type as AnyObject]
        
        messageRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            
            self.chatInputBar?.inputTextField?.text = nil
            
            Database.database().reference().child("user-messages").child(toId).child(roomId).child(messageRef.key).updateChildValues([
                "read" : 1, "timestamp" : timestamp
                ], withCompletionBlock: { (error, newRef) in
                    
                    Database.database().reference().child("user-messages").child(fromId).child(roomId).child(messageRef.key).updateChildValues([
                        "read" : 1, "timestamp" : timestamp
                        ], withCompletionBlock: { (error, nextRef) in
                            
                    })
                    
                    
            })
        }
    }
    func setupKeyboardSetting(){
        hideKeyboard()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func handleKeyboardWillShow(_ notification: Notification) {
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        chatInputBarBottom?.constant = -keyboardFrame!.height
        
        UIView.animate(withDuration: keyboardDuration!, animations: {
            self.view.layoutIfNeeded()
            DispatchQueue.main.async(execute: {
                let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
            })
        })
        print(self.collectionView?.frame)
        isKeyboard = true
    }
    
    @objc func handleKeyboardWillHide(_ notification: Notification) {
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        chatInputBarBottom?.constant = 0
        UIView.animate(withDuration: keyboardDuration!, animations: {
            self.view.layoutIfNeeded()
            DispatchQueue.main.async(execute: {
                let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
            })
        })
        print(self.collectionView?.frame)
        isKeyboard = false
    }
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:    #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        collectionView?.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {

        if isKeyboard {
            view.endEditing(true)
        }
        
    }
}

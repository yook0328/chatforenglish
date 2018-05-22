//
//  ChatControllerCollectionViewController.swift
//  ChatForEnglish
//
//  Created by ARam on 2018. 1. 11..
//  Copyright © 2018년 aram. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

private let reuseIdentifier = "Cell"

class ChatController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    
    var chatInputBar : ChatTextInputBar?
//    var selectedMentor : Mentor? {
//        didSet {
//            observeChatLog()
//        }
//    }
    var selectedChatRoom : ChatRoom? {
        didSet {
            observeChatLog()
        }
    }
    var isActive = true
    var isKeyboard = false
    var messages = [Message]()
    var collectionViewBottmConstraint : NSLayoutConstraint?
    func observeChatLog(){
        guard let uid = Auth.auth().currentUser?.uid, let toId = selectedChatRoom?.mentor?.id, let roomId = selectedChatRoom?.id else {
            return
        }
        
        let userMessageRef = Database.database().reference().child("user-messages").child(uid).child(roomId)
        userMessageRef.observe(DataEventType.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            let messageRef = Database.database().reference().child("messages").child(messageId)
            messageRef.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let values = snapshot.value as? [String: AnyObject] else {
                    return
                }

                var tmp = [String : AnyObject]()
                for (key, value) in values {
                    tmp.updateValue(value, forKey: key)
                }
                
                tmp.updateValue(messageId as AnyObject, forKey: "id")

                self.messages.append(Message(values: tmp))
                
                DispatchQueue.main.async(execute: {
                    self.collectionView?.reloadData()
                    let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                    self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
                })
            }, withCancel: { (error) in
                
            })
            
        }) { (error) in
            
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.register(ChatCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.keyboardDismissMode = .interactive
        collectionView?.contentInset = UIEdgeInsets.zero
        collectionView?.layoutMargins = UIEdgeInsets.zero
        setupInputBar()
        
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        collectionView?.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        collectionView?.bottomAnchor.constraint(equalTo: (self.chatInputBar?.topAnchor)!).isActive = true
        collectionView?.backgroundColor = Colors.chat_room_background_color
            
        setupKeyboardSetting()

    }
    var chatInputBarBottom : NSLayoutConstraint?
    func setupInputBar() {
        chatInputBar = ChatTextInputBar(frame: CGRect.zero)
        chatInputBar?.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(chatInputBar!)
        
        chatInputBar?.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        chatInputBar?.heightAnchor.constraint(equalToConstant: (isActive ? 50 : 0)).isActive = true
        if isActive == false {
            chatInputBar?.sendButton?.isEnabled = false
            chatInputBar?.inputTextField?.isEnabled = false
        }
        
        chatInputBarBottom = chatInputBar?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        chatInputBarBottom?.isActive = true
        chatInputBar?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        chatInputBar?.parrentController = self
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        chatInputBar?.layoutIfNeeded()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let text = messages[indexPath.item].text
        let rect = Utils.estimateTextWidth(text: messages[indexPath.item].text!, font: UIFont.systemFont(ofSize: 16))
        
//        switch  Int(truncatingIfNeeded: messages[indexPath.item].type!) {
//        case 0:
//            break
//        default:
//            return CGSize(width: 0, height: 0)
//        }
        if messages[indexPath.item].type == 2 {
            let originalText = messages[indexPath.item].original_text
            
            if rect.width > self.view.frame.width * 0.55 {
                let imageSize = 20
                let height = Utils.estimateFrameForText(messages[indexPath.item].text!,width: self.view.frame.width * 0.55, font: UIFont.systemFont(ofSize: 16)).height + Utils.estimateFrameForText(originalText!, width: self.view.frame.width * 0.55, font: UIFont.systemFont(ofSize: 16)).height + CGFloat(imageSize) + CGFloat(50)
                
                return CGSize(width: self.view.frame.width, height: height)
            }
            else{
                let imageSize = 20
                let height = rect.height + Utils.estimateTextWidth(text: originalText!, font: UIFont.systemFont(ofSize: 16)).height + CGFloat(imageSize) + CGFloat(50)
                return CGSize(width: self.view.frame.width, height: height)
            }
        }
        
        
        
        //let rect = estimateFrameForText(messages[indexPath.item].text!, font: UIFont.systemFont(ofSize: 16))
        if rect.width > self.view.frame.width * 0.55 {
            return CGSize(width: self.view.frame.width, height: Utils.estimateFrameForText(messages[indexPath.item].text!,width: self.view.frame.width * 0.55, font: UIFont.systemFont(ofSize: 16)).height + 20)
        }else {
            return CGSize(width: self.view.frame.width, height: rect.height + 20)
        }
        
        
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return messages.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ChatCollectionViewCell
        
        cell.textView?.font = UIFont.systemFont(ofSize: 16)
        
        
        if messages[indexPath.item].type == 2 {
            
            cell.bubbleView?.backgroundColor = Colors.edit_chat_bubble_color
            cell.editTextView?.font = UIFont.systemFont(ofSize: 16)
            
            cell.bubbleViewXPosConstraint?.isActive = false
            cell.bubbleViewXPosConstraint = cell.bubbleView?.centerXAnchor.constraint(equalTo: cell.centerXAnchor)
            cell.bubbleViewXPosConstraint?.isActive = true
            
            
            let editTextRect = Utils.estimateTextWidth(text: messages[indexPath.item].text!, font: (cell.textView?.font)!)
            let originalTextRect = Utils.estimateTextWidth(text: messages[indexPath.item].original_text!, font: (cell.textView?.font)!)
            if editTextRect.width > self.view.frame.width * 0.55 || originalTextRect.width > self.view.frame.width * 0.55 {
                let editTextHeight = (editTextRect.width > self.view.frame.width * 0.55) ? Utils.estimateFrameForText(messages[indexPath.item].text!, width: self.view.frame.width * 0.55,font: (cell.textView?.font)!).height : editTextRect.height
                let originalTextHeight = (originalTextRect.width > self.view.frame.width * 0.55) ? Utils.estimateFrameForText(messages[indexPath.item].original_text!, width: self.view.frame.width * 0.55, font: (cell.textView?.font)!).height : originalTextRect.height
                cell.setEditTextChatCell(editText: messages[indexPath.item].text!, originalText: messages[indexPath.item].original_text!, bubbleWidth: self.view.frame.width * 0.55 + CGFloat(25), editTextHeight: editTextHeight + CGFloat(5), originalTextHeight:  originalTextHeight + CGFloat(5))
                
            }else{
                cell.setEditTextChatCell(editText: messages[indexPath.item].text!, originalText: messages[indexPath.item].original_text!, bubbleWidth: editTextRect.width + CGFloat(25), editTextHeight: editTextRect.height + CGFloat(5), originalTextHeight: originalTextRect.height + CGFloat(5))
            }
            
            return cell
        }
        
        cell.textView?.text = messages[indexPath.item].text
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        switch Int(truncatingIfNeeded: messages[indexPath.item].type!) {
            case 0:
                if appDelegate.user?.id != messages[indexPath.item].fromId {
                    cell.bubbleView?.backgroundColor = UIColor.white
                    cell.bubbleViewXPosConstraint?.isActive = false
                    cell.bubbleViewXPosConstraint = cell.bubbleView?.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 8)
                    cell.bubbleViewXPosConstraint?.isActive = true
                    
                }else {
                    cell.bubbleView?.backgroundColor = Colors.my_chat_bubble_color
                    cell.bubbleViewXPosConstraint?.isActive = false
                    cell.bubbleViewXPosConstraint = cell.bubbleView?.rightAnchor.constraint(equalTo: cell.rightAnchor, constant: -8)
                    cell.bubbleViewXPosConstraint?.isActive = true
                }
                break
            case 1:
                cell.bubbleView?.backgroundColor = UIColor.white
                cell.bubbleViewXPosConstraint?.isActive = false
                cell.bubbleViewXPosConstraint = cell.bubbleView?.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 8)
                cell.bubbleViewXPosConstraint?.isActive = true
                break
            case 3:
                cell.bubbleView?.backgroundColor = Colors.edit_chat_bubble_color
                cell.bubbleViewXPosConstraint?.isActive = false
                cell.bubbleViewXPosConstraint = cell.bubbleView?.centerXAnchor.constraint(equalTo: cell.centerXAnchor)
                cell.bubbleViewXPosConstraint?.isActive = true
                break
            default:
                break
            
        }        
        
        // Configure the cell

        let rect = Utils.estimateTextWidth(text: messages[indexPath.item].text!, font: (cell.textView?.font)!)
        
        if rect.width > self.view.frame.width * 0.55 {
            
            cell.setTextChatCell(text: messages[indexPath.item].text!, bubbleWidth: self.view.frame.width * 0.55 + CGFloat(25))
            //cell.bubbleViewWidthConstraint?.constant = self.view.frame.width * 0.55 + CGFloat(25)
        }else {
            cell.setTextChatCell(text: messages[indexPath.item].text!, bubbleWidth: rect.width + CGFloat(25))
//            cell.bubbleViewWidthConstraint?.constant = rect.width + CGFloat(25)
        }
        
        
        
        return cell
    }
    
    

}

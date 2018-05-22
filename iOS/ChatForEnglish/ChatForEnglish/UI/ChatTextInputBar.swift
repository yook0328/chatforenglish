//
//  ChatTextInputBar.swift
//  ChatForEnglish
//
//  Created by ARam on 2018. 1. 11..
//  Copyright © 2018년 aram. All rights reserved.
//

import UIKit

class ChatTextInputBar: UIView, UITextFieldDelegate {
    
    var inputTextField: UITextField?
    var sendButton : UIButton?
    var separator: UIView?
    var parrentController : ChatController? {
        didSet{
            sendButton?.addTarget(parrentController, action: #selector(parrentController?.handleSendText), for: UIControlEvents.touchUpInside)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.lightGray
        inputTextField = UITextField()
        inputTextField?.delegate = self
        
        inputTextField?.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(inputTextField!)
        inputTextField?.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        inputTextField?.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        inputTextField?.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8).isActive = true
        inputTextField?.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
        inputTextField?.backgroundColor = UIColor.white
        inputTextField?.layer.cornerRadius = 5
        
        sendButton = UIButton(type: .system)
        sendButton?.setTitle("Send", for: .normal)
        sendButton?.backgroundColor = Colors.primary_light_color
        sendButton?.setTitleColor(UIColor.white, for: .normal)
        sendButton?.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(sendButton!)
        
        sendButton?.leftAnchor.constraint(equalTo: (inputTextField?.rightAnchor)!, constant: 8).isActive = true
        sendButton?.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -3).isActive = true
        sendButton?.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        sendButton?.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8).isActive = true
        sendButton?.layer.cornerRadius = 5
        
        separator = UIView()
        self.addSubview(separator!)
        separator?.backgroundColor = Colors.hint_color
        separator?.translatesAutoresizingMaskIntoConstraints = false
        separator?.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        separator?.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        separator?.heightAnchor.constraint(equalToConstant: 2).isActive = true
        separator?.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

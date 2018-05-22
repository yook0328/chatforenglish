//
//  ChatResultController.swift
//  ChatForEnglish
//
//  Created by ARam on 2018. 2. 6..
//  Copyright © 2018년 aram. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ChatResultController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    let cellId = "cellId"
    let assessmentCellId = "assessmentCellId"
    var containerView : UITableView?
    var messages = [Message]()
    var selectedChatRoom : ChatRoom?{
        didSet {
            if self.selectedChatRoom?.messages.count == 0 {
                observeMessages()
            }else{
                for var message in (self.selectedChatRoom?.messages)!{
                    if message.type == 2 {
                        messages.append(message)
                        self.containerView?.reloadData()
                    }
                }
            }
            
        }
    }
    
    func observeMessages(){
        if let uid = Auth.auth().currentUser?.uid {
            let query = Database.database().reference().child("user-messages").child(uid).child((selectedChatRoom?.id)!)
            query.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in

                for childSnapshot in snapshot.children {
                    let child = (childSnapshot as! DataSnapshot)
                    Database.database().reference().child("messages").child(child.key)
                        .observeSingleEvent(of: .value, with: { (snapshot) in
                            guard let values = snapshot.value as? [String: AnyObject] else {
                                return
                            }
                            
                            var tmp = [String : AnyObject]()
                            for (key, value) in values {
                                tmp.updateValue(value, forKey: key)
                            }
                            
                            tmp.updateValue(snapshot.key as AnyObject, forKey: "id")
                            let element = Message(values: tmp)
                            self.selectedChatRoom?.messages.append(element)
                            if tmp["type"] as? Int64 == 2 {

                                self.messages.append(element)
                                self.containerView?.reloadData()
                            }
                        })
                    
                }
            })
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func setupUI(){

        containerView = UITableView()
        containerView?.contentInset = UIEdgeInsets.zero
        containerView?.layoutMargins = UIEdgeInsets.zero
        containerView?.separatorInset = UIEdgeInsets.zero
        containerView?.allowsSelection = false
        
        self.view.addSubview(containerView!)
        containerView?.translatesAutoresizingMaskIntoConstraints = false

        containerView?.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        containerView?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        containerView?.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        containerView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        containerView?.tableFooterView = UIView()
        containerView?.delegate = self
        containerView?.dataSource = self
        
        containerView?.register(ChatResultCell.self, forCellReuseIdentifier: cellId)
        containerView?.register(ChatResultAssessmentCell.self, forCellReuseIdentifier: assessmentCellId)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ( indexPath.item < messages.count ) ? estimateCellHeight(indexPath.item) : estimateChatResultAssessmentCellHeight()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count + ((selectedChatRoom!.description!.count != 0) ? 1 : 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.item < messages.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatResultCell
            
            cell.original?.text = "원문 : \((messages[indexPath.item].original_text)!)"
            cell.edit?.text = "수정 : \((messages[indexPath.item].text)!)"
            
            cell.originalTextViewHeightConstraint?.constant = Utils.estimateFrameForText((cell.original?.text)!, width: cell.frame.width * 0.9, font: (cell.original?.font)!).height
            cell.editTextViewHeightConstraint?.constant = Utils.estimateFrameForText((cell.edit?.text)!, width: cell.frame.width * 0.9, font: (cell.edit?.font)!).height
           
            cell.options = messages[indexPath.item].options?.components(separatedBy: "%*$")
            cell.descriptionText = messages[indexPath.item].description

            return cell
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: assessmentCellId, for: indexPath) as! ChatResultAssessmentCell
            cell.descriptionView?.text = "총평 : \((selectedChatRoom?.description)!)"
            return cell
        }
    }
    func estimateCellHeight(_ index : Int) -> CGFloat{
        let space : CGFloat = 7.0
        let fontSize : CGFloat = 12.0
        var spaceNum = 1
        let message = self.messages[index]
        var result : CGFloat = 0.0
        let width = self.view.frame.width * 0.9
        let font = UIFont.systemFont(ofSize: fontSize)
        result += Utils.estimateFrameForText("원문 : \((message.original_text)!)", width: width, font: font).height
        spaceNum += 1
        
        result += Utils.estimateFrameForText("수정 : \((message.text)!)", width: width, font: font).height
        spaceNum += 1
        
        if message.options?.count != 0 {
            let options = message.options?.components(separatedBy: "%*$")
            for option in options! {
                result += Utils.estimateFrameForText(option, width: width, font: font).height
                spaceNum += 1
            }
        }
        
        if message.description?.count != 0 {
            result += Utils.estimateFrameForText(message.description!, width: width, font: font).height
            spaceNum += 1
        }
        
        result += CGFloat(spaceNum) * space
        
        return result
        
    }
    
    func estimateChatResultAssessmentCellHeight() -> CGFloat{
        var result : CGFloat = 0
        let space : CGFloat = 7.0
        let width = self.view.frame.width * 0.9
        let fontSize : CGFloat = 12.0
        let font = UIFont.systemFont(ofSize: fontSize)
        result += Utils.estimateFrameForText("총평 : \((selectedChatRoom?.description)!)", width: width, font: font).height
        
        return result + (2 * space)
    }
}
class ChatResultAssessmentCell : UITableViewCell {
    
    var descriptionView : UITextView?
    let space : CGFloat = 7
    var descriptionViewHeightConstraint : NSLayoutConstraint?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        descriptionView = UITextView()
        self.addSubview(descriptionView!)
        descriptionView?.backgroundColor = .clear
        descriptionView?.textContainerInset = .zero
        descriptionView?.isScrollEnabled = false
        descriptionView?.isEditable = false
        
        descriptionView?.translatesAutoresizingMaskIntoConstraints = false
        descriptionView?.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        descriptionView?.topAnchor.constraint(equalTo: self.topAnchor, constant: space).isActive = true
        descriptionView?.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9).isActive = true
        descriptionViewHeightConstraint = descriptionView?.heightAnchor.constraint(equalToConstant: 15)
        descriptionViewHeightConstraint?.isActive = true
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class ChatResultCell : UITableViewCell{
    
    var original : UITextView?
    var edit : UITextView?
    var descriptionText : String? {
        didSet {
            setupDescription()
            
        }
    }
    var options : [String]? {
        didSet {
            lastOptionView = nil
            setupOption()
        }
    }
    
    
    let space : CGFloat = 7
    var lastOptionView : UITextView?
    var editTextViewHeightConstraint : NSLayoutConstraint?
    var originalTextViewHeightConstraint : NSLayoutConstraint?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        original = UITextView()
        self.addSubview(original!)
        original?.translatesAutoresizingMaskIntoConstraints = false
        original?.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        original?.topAnchor.constraint(equalTo: self.topAnchor, constant: space).isActive = true
        original?.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9).isActive = true
        originalTextViewHeightConstraint = original?.heightAnchor.constraint(equalToConstant: 15)
        originalTextViewHeightConstraint?.isActive = true
        
        original?.backgroundColor = .clear
        original?.textContainerInset = .zero
        original?.isScrollEnabled = false
        original?.isEditable = false
        
        
        edit = UITextView()
        self.addSubview(edit!)
        edit?.translatesAutoresizingMaskIntoConstraints = false
        edit?.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        edit?.topAnchor.constraint(equalTo: (original?.bottomAnchor)!, constant: space).isActive = true
        edit?.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9).isActive = true
        editTextViewHeightConstraint = edit?.heightAnchor.constraint(equalToConstant: 15)
        editTextViewHeightConstraint?.isActive = true
        edit?.backgroundColor = .clear
        edit?.textContainerInset = .zero
        edit?.isScrollEnabled = false
        edit?.isEditable = false
        
    }
    func setupOption(){
        
        for view in self.subviews{
            if view.tag == 2{
                view.removeFromSuperview()
            }
        }
        if options!.count == 1 && options![0].count == 0 {
            return
        }
        
        for (index, option) in options!.enumerated() {
            let view = UITextView()
            view.tag = 2
            self.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
            if index == 0
            {
                view.topAnchor.constraint(equalTo: (edit?.bottomAnchor)!, constant: space).isActive = true
            }else{
                view.topAnchor.constraint(equalTo: (lastOptionView?.bottomAnchor)!, constant: space).isActive = true
            }
            
            view.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9).isActive = true
            view.heightAnchor.constraint(equalToConstant: 15).isActive = true
            
            view.backgroundColor = .clear
            view.textContainerInset = .zero
            view.isScrollEnabled = false
            view.isEditable = false
            view.text = "- \(option)"
            lastOptionView = view
        }
        
    }
    func setupDescription(){
        
        for view in self.subviews{
            if view.tag == 3{
                view.removeFromSuperview()
                break
            }
        }
        
        if descriptionText?.count == 0 {
            return
        }
        
        let view = UITextView()
        
        view.tag = 3
        view.text = "부가 설명 : \(descriptionText!)"
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.textContainerInset = .zero
        view.isScrollEnabled = false
        view.isEditable = false
        view.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        view.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9).isActive = true
        view.heightAnchor.constraint(equalToConstant: Utils.estimateFrameForText(view.text, width: self.frame.width * 0.9, font: view.font!).height)
        
        if options?.count == 0 {
            view.topAnchor.constraint(equalTo: (edit?.bottomAnchor)!, constant: space).isActive = true
        }else{
            view.topAnchor.constraint(equalTo: (lastOptionView?.bottomAnchor)!, constant: space).isActive = true
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

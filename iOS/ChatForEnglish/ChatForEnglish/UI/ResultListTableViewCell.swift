//
//  ResultListTableViewCell.swift
//  ChatForEnglish
//
//  Created by ARam on 2018. 2. 3..
//  Copyright © 2018년 aram. All rights reserved.
//

import UIKit

class ResultListTableViewCell : UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    var tableView : UITableView?
    let cellId = "cellId"
    var parentController : MainController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupTableView()
    }
    
    func setupTableView(){
        tableView = UITableView()
        
        self.addSubview(tableView!)
        
        tableView?.translatesAutoresizingMaskIntoConstraints = false
        
        tableView?.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        tableView?.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        tableView?.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        tableView?.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true

        
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.contentInset = UIEdgeInsets.zero
        tableView?.layoutMargins = UIEdgeInsets.zero
        tableView?.separatorInset = UIEdgeInsets.zero
        tableView?.allowsSelection = false
        
//        tableView?.rowHeight = UITableViewAutomaticDimension
//        tableView?.estimatedRowHeight = 60
        
        tableView?.register(ResultListCell.self, forCellReuseIdentifier: cellId)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print(UITableViewAutomaticDimension)
//        return UITableViewAutomaticDimension
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let count = parentController?.resultChatRooms.count {
            return count
        }else {
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ResultListCell
        
        
        print("////////")
        print(cell.frame)
        print(cell.contentView.frame)
        
        cell.layoutIfNeeded()
        
        print("////// gg")
        print(cell.frame)
        print(cell.contentView.frame)
        print(cell.systemLayoutSizeFitting(UILayoutFittingExpandedSize))
        print(cell.systemLayoutSizeFitting(UILayoutFittingCompressedSize))
        
        let dicIndex = parentController?.resultChatRooms.index((parentController?.resultChatRooms.startIndex)!, offsetBy: indexPath.item)
        let key = parentController?.resultChatRooms.keys[dicIndex!]
        
        let data = parentController?.resultChatRooms[key!]
        cell.userName?.text = data?.mentor?.username
        cell.profileImage?.image = UIImage(named: "default_avatar")
        cell.profileImage?.contentMode = .scaleAspectFill
        cell.profileImage?.layer.cornerRadius = (cell.profileImage?.frame.width)! * 0.5
        cell.profileImage?.clipsToBounds = true
        cell.date?.text = Utils.convertTimestampForString((data?.timestamp)!)//data?.
        cell.date?.font = UIFont.systemFont(ofSize: 10)
        cell.sizeToFit()
        
        //self sizing 을 향후 연구해볼것
        cell.resultLogBtn?.tag = indexPath.item
        cell.resultLogBtn?.addTarget(self, action: #selector(onClickResultLogBtn), for: .touchUpInside)
        cell.chatLogBtn?.tag = indexPath.item
        cell.chatLogBtn?.addTarget(self, action: #selector(onClickChatLogBtn), for: .touchUpInside)
        
        
        
        return cell
    }
    @objc func onClickResultLogBtn(sender: UIButton){
        print("click result")
        let resultController = ChatResultController()
        let dicIndex = parentController?.resultChatRooms.index((parentController?.resultChatRooms.startIndex)!, offsetBy: sender.tag)
        let key = parentController?.resultChatRooms.keys[dicIndex!]
        
        let data = parentController?.resultChatRooms[key!]
        resultController.selectedChatRoom = data
        //chatController.selectedChatRoom = parentController?.activeChatRooms[key!]
        self.parentController?.navigationController?.pushViewController(resultController, animated: false)
    }
    @objc func onClickChatLogBtn(sender: UIButton){
        print("click chat")

        let dicIndex = parentController?.resultChatRooms.index((parentController?.resultChatRooms.startIndex)!, offsetBy: sender.tag)
        let key = parentController?.resultChatRooms.keys[dicIndex!]
        
        let data = parentController?.resultChatRooms[key!]

        
        let chatController = ChatController(collectionViewLayout: UICollectionViewFlowLayout())
        chatController.selectedChatRoom = data
        chatController.isActive = false
        //chatController.selectedChatRoom = parentController?.activeChatRooms[key!]
        self.parentController?.navigationController?.pushViewController(chatController, animated: false)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ResultListCell : UITableViewCell{
    
    var profileImage : UIImageView?
    var userName : UILabel?
    
    var date : UILabel?
    var chatLogBtn: UIButton?
    var resultLogBtn: UIButton?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        profileImage = UIImageView()
        profileImage?.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(profileImage!)
        
        profileImage?.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImage?.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImage?.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImage?.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        userName = UILabel()
        userName?.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(userName!)
        
        userName?.leftAnchor.constraint(equalTo: (profileImage?.rightAnchor)!, constant: 8).isActive = true
        userName?.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        userName?.heightAnchor.constraint(equalToConstant: 20).isActive = true
        userName?.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        
        date = UILabel()
        date?.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(date!)
        
        date?.leftAnchor.constraint(equalTo: (userName?.leftAnchor)!, constant: -8).isActive = true
        date?.heightAnchor.constraint(equalToConstant: 15).isActive = true
        date?.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4).isActive = true
        date?.topAnchor.constraint(equalTo: (userName?.bottomAnchor)!, constant: 8).isActive = true
        
        resultLogBtn = UIButton()
        resultLogBtn?.setTitle("내용 정리", for: .normal)
        resultLogBtn?.setTitleColor(UIColor.white, for: .normal)
        resultLogBtn?.backgroundColor = Colors.edit_chat_bubble_color
        resultLogBtn?.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(resultLogBtn!)
        resultLogBtn?.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        resultLogBtn?.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        resultLogBtn?.widthAnchor.constraint(equalToConstant: 50).isActive = true
        resultLogBtn?.heightAnchor.constraint(equalToConstant: 40).isActive = true
        resultLogBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        
        chatLogBtn = UIButton()
        chatLogBtn?.translatesAutoresizingMaskIntoConstraints = false
        chatLogBtn?.setTitle("지난 대화 보기", for: .normal)
        chatLogBtn?.setTitleColor(UIColor.white, for: .normal)
        chatLogBtn?.backgroundColor = Colors.primary_dark_color
        chatLogBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        
        self.addSubview(chatLogBtn!)
        chatLogBtn?.rightAnchor.constraint(equalTo: (resultLogBtn?.leftAnchor)!, constant: -8).isActive = true
        chatLogBtn?.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        chatLogBtn?.widthAnchor.constraint(equalToConstant: 60).isActive = true
        chatLogBtn?.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

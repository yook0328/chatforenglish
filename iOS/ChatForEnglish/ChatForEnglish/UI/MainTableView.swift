//
//  MentoListTableView.swift
//  ChatForEnglish
//
//  Created by ARam on 2018. 1. 8..
//  Copyright © 2018년 aram. All rights reserved.
//

import UIKit

class MainTableView: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    var tableView : UITableView?
    let cellId = "cellId"
    var profileContainer : UIView?
    var profileImageView : UIImageView?
    var usernameLabel : UILabel?
    
    var mentors : [Mentor]? {
        didSet {

            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }

        }
    }
    var chatRooms : [String:ChatRoom]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
    }
    
    var parentController : MainController?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let parent = parentController as? MainController else {
            return 0
        }

        return parent.activeChatRooms.count//(parentController?.mentors.count)!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MentorCell
        //cell.backgroundColor = Colors.hint_color
        
        let dicIndex = parentController?.activeChatRooms.index((parentController?.activeChatRooms.startIndex)!, offsetBy: indexPath.item)
        let key = parentController?.activeChatRooms.keys[dicIndex!]
        let room = parentController?.activeChatRooms[key!]
        let data = room?.mentor
        cell.userName?.text = data?.username
        cell.profileImage?.image = UIImage(named: "default_avatar")
        cell.profileImage?.contentMode = .scaleAspectFit

        cell.profileImage?.layer.cornerRadius = (cell.frame.height - 12) * 0.5
        cell.profileImage?.clipsToBounds = true
        
        cell.msg?.text = room?.lastMsg
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let dicIndex = parentController?.activeChatRooms.index((parentController?.activeChatRooms.startIndex)!, offsetBy: indexPath.item)
        let key = parentController?.activeChatRooms.keys[dicIndex!]
        
        let chatController = ChatController(collectionViewLayout: UICollectionViewFlowLayout())
        chatController.selectedChatRoom = parentController?.activeChatRooms[key!]
        self.parentController?.navigationController?.pushViewController(chatController, animated: false)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupProfile()
        
        tableView = UITableView()
        self.addSubview(tableView!)
        
        tableView?.translatesAutoresizingMaskIntoConstraints = false
        tableView?.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        tableView?.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        tableView?.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5).isActive = true
        tableView?.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.register(MentorCell.self, forCellReuseIdentifier: cellId)
        
        tableView?.contentInset = UIEdgeInsets.zero
        tableView?.layoutMargins = UIEdgeInsets.zero
        tableView?.separatorInset = UIEdgeInsets.zero
        
    }
    func setupProfile() {
        profileContainer = UIView()
        self.addSubview(profileContainer!)
        profileContainer?.translatesAutoresizingMaskIntoConstraints = false
        profileContainer?.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        profileContainer?.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        profileContainer?.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5).isActive = true
        profileContainer?.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        profileImageView = UIImageView()
        profileContainer?.addSubview(profileImageView!)
        profileImageView?.translatesAutoresizingMaskIntoConstraints = false
        profileImageView?.centerXAnchor.constraint(equalTo: (profileContainer?.centerXAnchor)!).isActive = true
        profileImageView?.centerYAnchor.constraint(equalTo: (profileContainer?.centerYAnchor)!).isActive = true
        profileImageView?.heightAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView?.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView?.image = UIImage(named: "default_avatar")
        profileImageView?.layer.cornerRadius = 50
        profileImageView?.clipsToBounds = true
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let username = appDelegate.user?.username
        
        usernameLabel = UILabel()
        usernameLabel?.translatesAutoresizingMaskIntoConstraints = false
        profileContainer?.addSubview(usernameLabel!)
        usernameLabel?.textAlignment = .center
        usernameLabel?.text = username
        usernameLabel?.centerXAnchor.constraint(equalTo: (profileContainer?.centerXAnchor)!).isActive = true
        usernameLabel?.widthAnchor.constraint(equalTo: (profileContainer?.widthAnchor)!).isActive = true
        usernameLabel?.topAnchor.constraint(equalTo: (profileImageView?.bottomAnchor)!, constant: -10).isActive = true
        usernameLabel?.bottomAnchor.constraint(equalTo: (profileContainer?.bottomAnchor)!, constant: -10).isActive = true
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

class MentorCell : UITableViewCell{
    
    var profileImage : UIImageView?
    var userName : UILabel?
    var msg : UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        profileImage = UIImageView()
        profileImage?.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(profileImage!)
        
        profileImage?.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImage?.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImage?.widthAnchor.constraint(equalTo: self.heightAnchor, constant: -12).isActive = true
        profileImage?.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -12).isActive = true
        
        
        userName = UILabel()
        userName?.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(userName!)
        
        userName?.leftAnchor.constraint(equalTo: (profileImage?.rightAnchor)!, constant: 8).isActive = true
        userName?.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        userName?.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.85).isActive = true
        userName?.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        msg = UILabel()
        msg?.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(msg!)
        
        msg?.leftAnchor.constraint(equalTo: (userName?.rightAnchor)!, constant: 8).isActive = true
        msg?.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        msg?.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.85).isActive = true
        msg?.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 8).isActive = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//
//  SettingTableView.swift
//  ChatForEnglish
//
//  Created by ARam on 2018. 4. 1..
//  Copyright © 2018년 aram. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingTableViewCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    var tableView : UITableView?
    let cellId = "cellId"
    
    var parentController : MainController?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        setupTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        tableView?.backgroundColor = UIColor.darkGray
        //        tableView?.rowHeight = UITableViewAutomaticDimension
        //        tableView?.estimatedRowHeight = 60
        
        tableView?.register(SettingCell.self, forCellReuseIdentifier: cellId)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print(UITableViewAutomaticDimension)
        //        return UITableViewAutomaticDimension
        return 70
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SettingCell
        cell.email?.text = Auth.auth().currentUser?.email
        cell.logout?.setTitle("Logout", for: .normal)
        cell.logout?.addTarget(self, action: #selector(onLogoutBtn), for: .touchUpInside)
        
        return cell
    }
    @objc func onLogoutBtn(sender: UIButton){
        
        
        self.parentController?.signoutUser()
    }
}

class SettingCell : UITableViewCell{
    
    var email : UILabel?
    var logout : UIButton?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        email = UILabel()
        self.addSubview(email!)
        email?.translatesAutoresizingMaskIntoConstraints = false
        
        email?.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        email?.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        email?.heightAnchor.constraint(equalToConstant: 25).isActive = true
        email?.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -16).isActive = true
        
        logout = UIButton()
        self.addSubview(logout!)
        logout?.translatesAutoresizingMaskIntoConstraints = false
        
        logout?.topAnchor.constraint(equalTo: (email?.bottomAnchor)!, constant: 8).isActive = true
        logout?.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        logout?.widthAnchor.constraint(equalToConstant: 80).isActive = true
        logout?.heightAnchor.constraint(equalToConstant: 15).isActive = true
        logout?.setTitleColor(Colors.primary_light_color, for: .normal)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


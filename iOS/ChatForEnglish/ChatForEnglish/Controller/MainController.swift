//
//  MainController.swift
//  ChatForEnglish
//
//  Created by ARam on 2018. 1. 7..
//  Copyright © 2018년 aram. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class MainController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    let settingCellId = "settingCellId"
    let mentorCellId = "mentorCellId"
    let resultCellId = "resultCellId"
    var viewContainer : UICollectionView?
    var mentors = [Mentor]()
    var mentorIds = [String]()
    var activeChatRoomTableView : UITableView?
    var user : UserProfile?
    var activeChatRooms = [String:ChatRoom]()
    var resultChatRooms = [String:ChatRoom]()
    var resultChatRoomTableView : UITableView?
    var settingTableView : UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.black
        topMargin = UIApplication.shared.statusBarFrame.size.height + menuBarHeight + (self.navigationController != nil ? (self.navigationController?.navigationBar.frame.height)!: 0)
//        setupStatusbar()
        
        
        setupCollectionView()
        setupMenuBar()
        
        objerveMentorList()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        user = appDelegate.user
        appDelegate.registerForNotification(application: UIApplication.shared)
        
        observeActiveChatRoom()
        observeResultChatRoom()
        observeFinishiedChatRoom()
    }
    
    
    var menuBarHeight : CGFloat {
        return CGFloat(50)
    }
    var menuBar : MenuBar?
    var topMargin : CGFloat = 0.0

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let path = NSIndexPath(row: 0, section: 0)
        menuBar?.collectionView.selectItem(at: path as IndexPath, animated: false, scrollPosition: UICollectionViewScrollPosition())
    }
    func setupCollectionView(){
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        viewContainer = UICollectionView(frame: .zero, collectionViewLayout: layout)

        
        viewContainer?.backgroundColor = UIColor.white
        viewContainer?.register(SettingTableViewCell.self, forCellWithReuseIdentifier: settingCellId)
        viewContainer?.register(MainTableView.self, forCellWithReuseIdentifier: mentorCellId)
        viewContainer?.register(ResultListTableViewCell.self, forCellWithReuseIdentifier: resultCellId)
        viewContainer?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        viewContainer?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        viewContainer?.isPagingEnabled = true
        
        viewContainer?.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(viewContainer!)
        viewContainer?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        viewContainer?.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        viewContainer?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        viewContainer?.heightAnchor.constraint(equalTo: self.view.heightAnchor, constant: -topMargin ).isActive = true
        
        viewContainer?.delegate = self
        viewContainer?.dataSource = self
    }
    
    func setupMenuBar(){
        menuBar = MenuBar(frame: .zero)
        menuBar?.translatesAutoresizingMaskIntoConstraints = false
        menuBar?.mainController = self
        self.view.addSubview(menuBar!)
        
        menuBar?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        menuBar?.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        menuBar?.heightAnchor.constraint(equalToConstant: menuBarHeight).isActive = true
        menuBar?.topAnchor.constraint(equalTo: self.view.topAnchor, constant: (topMargin - menuBarHeight)).isActive = true
        

    }
    
    func scrollToMenu(index : Int){
        
        viewContainer?.scrollToItem(at: IndexPath(item: index, section: 0), at: UICollectionViewScrollPosition(), animated: true)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items

        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.item {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mentorCellId, for: indexPath) as! MainTableView
            cell.tableView?.tableFooterView = UIView()
            cell.parentController = self
            activeChatRoomTableView = cell.tableView
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: resultCellId, for: indexPath) as! ResultListTableViewCell
            cell.tableView?.tableFooterView = UIView()
            cell.parentController = self
            resultChatRoomTableView = cell.tableView
            
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: settingCellId, for: indexPath) as! SettingTableViewCell
//            let colors = [UIColor.orange, UIColor.red, UIColor.blue]
//            cell.backgroundColor = colors[indexPath.item]
            cell.tableView?.tableFooterView = UIView()
            cell.parentController = self
            settingTableView = cell.tableView
            return cell
        }
    }
    public func signoutUser(){
        do{
            try Auth.auth().signOut()
            self.present(LoginRegisterController(), animated: false, completion: {
                
            })
        }
        catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar?.indicatorLeftAnchor?.constant = scrollView.contentOffset.x / CGFloat((menuBar?.menuCount)!)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.move().x / view.frame.width
        
        menuBar?.collectionView.selectItem(at: IndexPath(item: Int(index), section: 0), animated: true, scrollPosition: UICollectionViewScrollPosition())
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - topMargin)
    }
    func observeFinishiedChatRoom(){
        let chatRef = Database.database().reference().child("user-rooms").child((user?.id)!)
        
        chatRef.observe(.childChanged) { (snapshot) in
            guard let values = snapshot.value as? [String: AnyObject] else {
                return
            }
            if values["isFinish"] as! Bool == true{
                self.activeChatRooms.removeValue(forKey: snapshot.key)
                self.activeChatRoomTableView?.reloadData()
            }
        }
    }
    func observeActiveChatRoomLastMsg(_ room : ChatRoom){
        let userRef = Database.database().reference().child("user-messages").child((user?.id)!).child(room.id!).queryLimited(toLast: 1)
        userRef.keepSynced(true)
        userRef.observe(.childAdded) { (snapshot) in
            Database.database().reference().child("messages").child(snapshot.key).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let values = snapshot.value as? [String: AnyObject] else {
                    return
                }
                
                room.lastMsg = values["text"] as! String

                self.activeChatRooms[room.id!] = room
                
                
                self.activeChatRoomTableView?.reloadData()
            })
        }
    }
    
    func observeActiveChatRoom(){
        if let userId = user?.id {
            let query = Database.database().reference().child("user-rooms").child(userId).queryOrdered(byChild: "isFinish").queryEqual(toValue: false)
            
            query.observe(.value, with: { (snapshot) in
                for childSnapshot in snapshot.children {
                    let child = (childSnapshot as! DataSnapshot)
                    guard let data = child.value as? [String: AnyObject ] else {continue}
                    
                    if let check = self.activeChatRooms[child.key] {
                        continue
                    }
                    let room = ChatRoom(id: child.key, timestamp: data["timestamp"] as! Int64)
                    let mentorId = data["mentor"] as! String
                    
                    Database.database().reference().child("Users").child(mentorId).observeSingleEvent(of: .value, with: { (mentorSnapshot) in
                        let values = mentorSnapshot.value as? NSDictionary
                        room.mentor = Mentor(values: values as! [String : AnyObject])
                        
                        self.observeActiveChatRoomLastMsg(room)
                        
                        
                        
                    }, withCancel: { (error) in
                        print("error")
                    })                    
                }
                
            }, withCancel: { (error) in
                print(error)
            })
            
        }
        
    }
    func observeResultChatRoom(){
        if let userId = user?.id {
            let query = Database.database().reference().child("user-rooms").child(userId).queryOrdered(byChild: "isFinish").queryEqual(toValue: true)
            
            query.observe(.value, with: { (snapshot) in
                for childSnapshot in snapshot.children {
                    let child = (childSnapshot as! DataSnapshot)
                    guard let data = child.value as? [String: AnyObject ] else {continue}
                    
                    if let check = self.resultChatRooms[child.key] {
                        continue
                    }
                    var room : ChatRoom
                    if let description = data["description"] {
                        room = ChatRoom(id: child.key, timestamp: data["timestamp"] as! Int64,
                                        description: data["description"] as! String)
                    }else{
                        room = ChatRoom(id: child.key, timestamp: data["timestamp"] as! Int64)
                    }
                    
                    let mentorId = data["mentor"] as! String
                    
                    Database.database().reference().child("Users").child(mentorId).observeSingleEvent(of: .value, with: { (mentorSnapshot) in
                        let values = mentorSnapshot.value as? NSDictionary
                        room.mentor = Mentor(values: values as! [String : AnyObject])
                        
                        self.resultChatRooms[child.key] = room
                        
                        self.resultChatRoomTableView?.reloadData()
                        
                    }, withCancel: { (error) in
                        print("error")
                    })
                }
                
            }, withCancel: { (error) in
                print(error)
            })
            
        }
    }
    func objerveMentorList(){
        
        let ref = Database.database().reference().child("Users")
        
        let query = ref.queryOrdered(byChild: "type").queryEqual(toValue: "Mentor")
        
        query.observe(.value, with: { (snapshot) in
            for childSnapshot in snapshot.children {
                let child = (childSnapshot as! DataSnapshot)
                guard let data = child.value as? [String: AnyObject ] else {continue}
                if !self.mentorIds.contains((data["id"] as? String)!) {
                    self.mentors.append(Mentor(values: data))
                    self.mentorIds.append((data["id"] as? String)!)
                }
                //if self.mentorIds
               

            }

            self.activeChatRoomTableView?.reloadData()
        }) { (error) in
            print("error")
        }
    }

}

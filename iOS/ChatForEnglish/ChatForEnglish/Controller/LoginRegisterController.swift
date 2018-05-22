//
//  LoginRegisterController.swift
//  ChatForEnglish
//
//  Created by ARam on 2018. 1. 7..
//  Copyright © 2018년 aram. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginRegisterController: UIViewController {

    var mLoginRegisterSegmentedControl : UISegmentedControl?
    var mFormContainer : UIView?
    var mEmailTxt : UITextField?
    var mEmailTxtUnderline : UIView?
    var mUsernameTxt : UITextField?
    var mUsernameTxtUnderline : UIView?
    var mPwTxt : UITextField?
    var mSubmitBtn : UIButton?
    
    var mProgressIndicator : UIActivityIndicatorView?
    
    //////// constraint
    var mFormContainerHeight : NSLayoutConstraint?
    var mEmailTxtHeight : NSLayoutConstraint?
    var mUsernameTxtHeight : NSLayoutConstraint?
    var mPwTxtHeight : NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 2/255, green: 119/255, blue: 189/255, alpha: 1.0)
        
//        let ls = UserDefaults.standard
//        if Auth.auth().currentUser != nil, let usernameTxt = ls.string(forKey: LocalKey.username),
//            let emailTxt = ls.string(forKey: LocalKey.email), let type = ls.string(forKey: LocalKey.type), let profileImageUrl = ls.string(forKey: LocalKey.profileImageUrl){
//            print("herere??????")
//            let values = ["username": usernameTxt, "email": emailTxt, "profileImageUrl": profileImageUrl, "type":type, "id": Auth.auth().currentUser?.uid] as [String : Any]
//            
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.user = UserProfile(values: values as [String : AnyObject])
//            
//            DispatchQueue.main.async(execute: {
//                self.present(UINavigationController(rootViewController: MainController()), animated: true, completion: {
//                    
//                })
//            })
//            
//            
//            //
//            //
//            //            do {
//            //
//            //                try Auth.auth().signOut()
//            //                if UIApplication.shared.isRegisteredForRemoteNotifications {
//            //
//            //                    DispatchQueue.main.async(execute: {
//            //                        UIApplication.shared.unregisterForRemoteNotifications()
//            //                    })
//            //                }
//            //
//            //            } catch let signOutError as NSError {
//            //                print ("Error signing out: %@", signOutError)
//            //            }
//        }else{
//            if UIApplication.shared.isRegisteredForRemoteNotifications {
//                DispatchQueue.main.async(execute: {
//                    UIApplication.shared.unregisterForRemoteNotifications()
//                })
//            }
//            
//        }
        
        initSetupUI()
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    func initSetupUI(){
        setupStatusbar()
        setupSegment()
        setupForm()
        setupProgressIndicator()
        handleLoginRegisterSegment()
        
        hideKeyboard()
    }
    
    func setupStatusbar(){
        let statusbar = UIView()
        statusbar.backgroundColor = Colors.primary_dark_color
        statusbar.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(statusbar)
        statusbar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        statusbar.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        statusbar.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        statusbar.heightAnchor.constraint(equalToConstant: UIApplication.shared.statusBarFrame.size.height).isActive = true
    }
    
    func setupProgressIndicator(){
        mProgressIndicator = UIActivityIndicatorView()
        mProgressIndicator?.hidesWhenStopped = true
        mProgressIndicator?.frame = CGRect(x: 0, y: 0, width: view.frame.width , height: view.frame.height)
        mProgressIndicator?.backgroundColor = UIColor(red: 65/255, green: 65/255, blue: 65/255, alpha: 0.3)
        mProgressIndicator?.center = CGPoint(x: view.frame.width/2, y: view.frame.height/2)
        mProgressIndicator?.activityIndicatorViewStyle = .whiteLarge
        view.addSubview(mProgressIndicator!)
        
    }
    
    func setupSegment(){
        mLoginRegisterSegmentedControl = UISegmentedControl(items: ["Login", "Register"])
        mLoginRegisterSegmentedControl?.translatesAutoresizingMaskIntoConstraints = false
        mLoginRegisterSegmentedControl?.tintColor = UIColor.white
        mLoginRegisterSegmentedControl?.selectedSegmentIndex = 0
        mLoginRegisterSegmentedControl?.addTarget(self, action: #selector(handleLoginRegisterSegment), for: .valueChanged)
        view.addSubview(mLoginRegisterSegmentedControl!)
        
        mLoginRegisterSegmentedControl?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mLoginRegisterSegmentedControl?.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -8).isActive = true
        mLoginRegisterSegmentedControl?.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        mLoginRegisterSegmentedControl?.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        
    }
    func setupForm(){
        mFormContainer = UIView()
        view.addSubview(mFormContainer!)
        
        mFormContainer?.backgroundColor = UIColor.white
        mFormContainer?.layer.cornerRadius = 5
        mFormContainer?.translatesAutoresizingMaskIntoConstraints = false
        
        mFormContainer?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mFormContainer?.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -8).isActive = true
        mFormContainer?.topAnchor.constraint(equalTo: (mLoginRegisterSegmentedControl?.bottomAnchor)!, constant: 8).isActive = true
        mFormContainerHeight = mFormContainer?.heightAnchor.constraint(equalToConstant: 150)
        mFormContainerHeight?.isActive = true
        
        
        ///// Email Text
        mEmailTxt = UITextField()
        mEmailTxt?.autocorrectionType = .no
        mEmailTxt?.keyboardType = .emailAddress
        mEmailTxt?.placeholder = "Email"
        mFormContainer?.addSubview(mEmailTxt!)
        mEmailTxt?.translatesAutoresizingMaskIntoConstraints = false
        
        mEmailTxt?.centerXAnchor.constraint(equalTo: (mFormContainer?.centerXAnchor)!).isActive = true
        mEmailTxt?.widthAnchor.constraint(equalTo: (mFormContainer?.widthAnchor)!, constant: -16).isActive = true
        mEmailTxt?.topAnchor.constraint(equalTo: (mFormContainer?.topAnchor)!).isActive = true
        mEmailTxtHeight = mEmailTxt?.heightAnchor.constraint(equalTo: (mFormContainer?.heightAnchor)!, multiplier: 1/3)
        mEmailTxtHeight?.isActive = true
        
        ///// Email Text Underline
        mEmailTxtUnderline = UIView()
        mFormContainer?.addSubview(mEmailTxtUnderline!)
        mEmailTxtUnderline?.translatesAutoresizingMaskIntoConstraints = false
        mEmailTxtUnderline?.backgroundColor = Colors.placeholder_color
        mEmailTxtUnderline?.centerXAnchor.constraint(equalTo: (mFormContainer?.centerXAnchor)!).isActive = true
        mEmailTxtUnderline?.widthAnchor.constraint(equalTo: (mFormContainer?.widthAnchor)!).isActive = true
        mEmailTxtUnderline?.topAnchor.constraint(equalTo: (mEmailTxt?.bottomAnchor)!).isActive = true
        mEmailTxtUnderline?.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        ///// Username Text
        mUsernameTxt = UITextField()
        mUsernameTxt?.autocorrectionType = .no
        
        mUsernameTxt?.keyboardType = .default
        mUsernameTxt?.placeholder = "Username"
        mFormContainer?.addSubview(mUsernameTxt!)
        mUsernameTxt?.translatesAutoresizingMaskIntoConstraints = false
        
        mUsernameTxt?.centerXAnchor.constraint(equalTo: (mFormContainer?.centerXAnchor)!).isActive = true
        mUsernameTxt?.widthAnchor.constraint(equalTo: (mFormContainer?.widthAnchor)!, constant: -16).isActive = true
        mUsernameTxt?.topAnchor.constraint(equalTo: (mEmailTxt?.bottomAnchor)!).isActive = true
        mUsernameTxtHeight = mUsernameTxt?.heightAnchor.constraint(equalTo: (mFormContainer?.heightAnchor)!, multiplier: 1/3)
        mUsernameTxtHeight?.isActive = true
        
        ///// Username Text Underline
        mUsernameTxtUnderline = UIView()
        mFormContainer?.addSubview(mUsernameTxtUnderline!)
        mUsernameTxtUnderline?.translatesAutoresizingMaskIntoConstraints = false
        mUsernameTxtUnderline?.backgroundColor = Colors.placeholder_color
        mUsernameTxtUnderline?.centerXAnchor.constraint(equalTo: (mFormContainer?.centerXAnchor)!).isActive = true
        mUsernameTxtUnderline?.widthAnchor.constraint(equalTo: (mFormContainer?.widthAnchor)!).isActive = true
        mUsernameTxtUnderline?.topAnchor.constraint(equalTo: (mUsernameTxt?.bottomAnchor)!).isActive = true
        mUsernameTxtUnderline?.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        ///// Password Text
        mPwTxt = UITextField()
        mPwTxt?.isSecureTextEntry = true
        mPwTxt?.placeholder = "Password"
        mFormContainer?.addSubview(mPwTxt!)
        mPwTxt?.translatesAutoresizingMaskIntoConstraints = false
        
        mPwTxt?.centerXAnchor.constraint(equalTo: (mFormContainer?.centerXAnchor)!).isActive = true
        mPwTxt?.widthAnchor.constraint(equalTo: (mFormContainer?.widthAnchor)!, constant: -16).isActive = true
        mPwTxt?.topAnchor.constraint(equalTo: (mUsernameTxt?.bottomAnchor)!).isActive = true
        mPwTxtHeight = mPwTxt?.heightAnchor.constraint(equalTo: (mFormContainer?.heightAnchor)!, multiplier: 1/3)
        mPwTxtHeight?.isActive = true
        
        
        ///////  Submit Button
        mSubmitBtn = UIButton()
        view.addSubview(mSubmitBtn!)
        mSubmitBtn?.setTitle("Login", for: .normal)
        mSubmitBtn?.backgroundColor = Colors.primary_light_color
        mSubmitBtn?.layer.cornerRadius = 5
        mSubmitBtn?.translatesAutoresizingMaskIntoConstraints = false
        
        mSubmitBtn?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mSubmitBtn?.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -8).isActive = true
        mSubmitBtn?.topAnchor.constraint(equalTo: (mFormContainer?.bottomAnchor)!, constant: 8).isActive = true
        mSubmitBtn?.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        mSubmitBtn?.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        
        
        let ls = UserDefaults.standard
        if let emailTx = ls.string(forKey: LocalKey.email){
            mEmailTxt?.text = emailTx
            
        }
    }
    
    @objc func handleLoginRegisterSegment(){
        let index = mLoginRegisterSegmentedControl?.selectedSegmentIndex
        mSubmitBtn?.setTitle(index == 0 ? "Login": "Register" , for: .normal)
        
        mFormContainerHeight?.constant = index == 0 ? 100 : 150
        
        mUsernameTxtHeight?.isActive = false
        mUsernameTxtHeight = mUsernameTxt?.heightAnchor.constraint(equalTo: (mFormContainer?.heightAnchor)!, multiplier: index == 0 ? 0 : 1/3)
        mUsernameTxtHeight?.isActive = true
        
        mEmailTxtHeight?.isActive = false
        mEmailTxtHeight = mEmailTxt?.heightAnchor.constraint(equalTo: (mFormContainer?.heightAnchor)!, multiplier: index == 0 ? 1/2 : 1/3)
        mEmailTxtHeight?.isActive = true
        
        mPwTxtHeight?.isActive = false
        mPwTxtHeight = mPwTxt?.heightAnchor.constraint(equalTo: (mFormContainer?.heightAnchor)!, multiplier: index == 0 ? 1/2 : 1/3)
        mPwTxtHeight?.isActive = true
    }
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:    #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

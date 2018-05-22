//
//  LoginRegisterControllerForFunc.swift
//  ChatForEnglish
//
//  Created by ARam on 2018. 1. 7..
//  Copyright © 2018년 aram. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseMessaging
import UserNotifications

extension LoginRegisterController {

    @objc func handleSubmit(){
        switch (mLoginRegisterSegmentedControl?.selectedSegmentIndex)! {
        case 0:
            handleLogin()
            
            
            break
            
        case 1:
            handleRegister()
            break
        default:
          break
        }
    }
    
    func handleLogin(){

        guard let email = mEmailTxt?.text, let pw = mPwTxt?.text else{
            print("Form is not valid")
            return
        }
        mProgressIndicator?.startAnimating()
        Auth.auth().signIn(withEmail: email, password: pw, completion: { (user, error) in
            if error != nil {
                print(error)
                self.mProgressIndicator?.stopAnimating()
                return
            }
            guard let uid = user?.uid else{
                self.mProgressIndicator?.stopAnimating()
                return
            }
            
            let ref = Database.database().reference()
            let userReference = ref.child("Users").child(uid)
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            userReference.updateChildValues(["deviceToken": appDelegate.deviceToken!, "platform" : "iOS"], withCompletionBlock: { (error, snapshot) in
                print(snapshot.key)
                snapshot.observeSingleEvent(of: DataEventType.value, with: { (_snapshot) in
                    
                    let values = _snapshot.value as? NSDictionary
                    
                    appDelegate.user = UserProfile(values: values as! [String : AnyObject])
                    
                    self.mProgressIndicator?.stopAnimating()
                    let ls = UserDefaults.standard
                    
                    
                    let username = values!["username"] as? String
                    let profileImageUrl = values!["profileImageUrl"] as? String
                    let type = values!["type"] as? String
                    
                    ls.set(email, forKey: LocalKey.email)
                    ls.set(username, forKey: LocalKey.username)
                    ls.set(profileImageUrl, forKey: LocalKey.profileImageUrl)
                    ls.set(type, forKey: LocalKey.type)
                    
                    
                    self.present(UINavigationController(rootViewController: MainController()), animated: true, completion: {
                        
                    })
                    
                })

            })
            
        })
    }
    
    func handleRegister(){
        guard let email = mEmailTxt?.text, let pw = mPwTxt?.text, let username = mUsernameTxt?.text else{
            print("Form is not valid")
            return
        }
        
        mProgressIndicator?.startAnimating()
        Auth.auth().createUser(withEmail: email, password: pw, completion: { (user, error) in
            if error != nil {
                print(error)
                self.mProgressIndicator?.stopAnimating()
                return
            }
            guard let uid = user?.uid else{
                self.mProgressIndicator?.stopAnimating()
                return
            }
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let values = ["username": username, "email": email, "profileImageUrl": "default", "type":"student", "id": uid, "deviceToken": appDelegate.deviceToken!, "platform" : "iOS"] as [String : Any]
            
            let ref = Database.database().reference()
            let userReference = ref.child("Users").child(uid)
            
            userReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
                if error != nil {
                    print(error)
                    return
                }
                self.mProgressIndicator?.stopAnimating()
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.user = UserProfile(values: values as [String : AnyObject])
                
                let ls = UserDefaults.standard
                
                let username = values["username"] as? String
                let profileImageUrl = values["profileImageUrl"] as? String
                let type = values["type"] as? String
                
                ls.set(email, forKey: LocalKey.email)
                ls.set(username, forKey: LocalKey.username)
                ls.set(profileImageUrl, forKey: LocalKey.profileImageUrl)
                ls.set(type, forKey: LocalKey.type)
                
                self.present(UINavigationController(rootViewController: MainController()), animated: true, completion: {
                    
                })
            })
        })
        
        
    }

}

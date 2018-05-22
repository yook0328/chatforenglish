//
//  UserProfile.swift
//  ChatForEnglish
//
//  Created by ARam on 2018. 1. 7..
//  Copyright © 2018년 aram. All rights reserved.
//

class UserProfile{
    var id : String?
    var email : String?
    var username : String?
    var profileImageUrl : String?
    var type : String?
    
    init(values: [String : AnyObject]){

        id = values["id"] as? String
        email = values["email"] as? String
        username = values["username"] as? String
        profileImageUrl = values["profileImageUrl"] as? String
        type = values["type"] as? String
    }
}

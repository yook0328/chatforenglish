//
//  Mentor.swift
//  ChatForEnglish
//
//  Created by ARam on 2018. 1. 11..
//  Copyright © 2018년 aram. All rights reserved.
//

class Mentor{
    var id : String?
    var username : String?
    var profileImageUrl : String?
    
    init(values: [String : AnyObject]){
        
        id = values["id"] as? String
        username = values["username"] as? String
        profileImageUrl = values["profileImageUrl"] as? String
    }
}

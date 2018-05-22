//
//  ChatRoom.swift
//  ChatForEnglish
//
//  Created by ARam on 2018. 1. 28..
//  Copyright © 2018년 aram. All rights reserved.
//

class ChatRoom{
    var id : String?
    var mentor : Mentor?
    var messages : [Message] = [Message]()
    var timestamp : Int64?
    
    var description : String?
    var lastMsg : String?
    init(id: String, timestamp: Int64, description: String = ""){
        
        self.id = id
        self.timestamp = timestamp
        self.description = description
    }
    
    func setDescription(_ description: String){
        self.description = description
    }
    
    func setMentor(mentor : Mentor){
        self.mentor = mentor
    }
}

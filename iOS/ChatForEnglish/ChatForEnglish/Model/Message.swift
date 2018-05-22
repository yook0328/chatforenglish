//
//  Message.swift
//  ChatForEnglish
//
//  Created by ARam on 2018. 1. 11..
//  Copyright © 2018년 aram. All rights reserved.
//

class Message {
    var id : String?
    var toId : String?
    var fromId : String?
    var timestamp : Int64?
    var text : String?
    var type : Int64?
    var original_text : String?
    var options : String?
    var description: String?
    
    init(values: [String : AnyObject]){
        
        id = values["id"] as? String
        toId = values["toId"] as? String
        fromId = values["fromId"] as? String
        timestamp = values["timestamp"] as? Int64
        text = values["text"] as? String
        type = values["type"] as? Int64
        
        if type == 2 {
            original_text = values["original_text"] as? String
            options = values["options"] as? String
            description = values["description"] as? String
            
        }
        

    }
    
}

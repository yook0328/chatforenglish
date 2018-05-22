package com.aram.chatproto.Model;

import com.google.firebase.database.DataSnapshot;

/**
 * Created by Aram on 2018. 1. 25..
 */

public class Message {
    String fromId;
    String original_text;
    String text;
    String toId;
    int type;
    String timestamp;
    String id;

    public String getOptions() {
        return options != null ? options : "";
    }

    public String getDescription() {
        return description != null ? description : "";
    }

    String options;
    String description;
    public String getFromId() {
        return fromId;
    }

    public String getOriginal_text() {
        return original_text;
    }

    public String getText() {
        return text;
    }

    public String getToId() {
        return toId;
    }

    public int getType() {
        return type;
    }

    public String getTimestamp() {
        return timestamp;
    }

    public String getId() {
        return id;
    }

    public Message(DataSnapshot dataSnapshot) {
        id = dataSnapshot.getKey();
        fromId = dataSnapshot.child("fromId").getValue().toString();
        toId = dataSnapshot.child("toId").getValue().toString();
        text = dataSnapshot.child("text").getValue().toString();
        type = Integer.valueOf(dataSnapshot.child("type").getValue().toString());
        timestamp = dataSnapshot.child("timestamp").getValue().toString();
        if(type == 2){
            description = dataSnapshot.child("description").getValue().toString();
            options = dataSnapshot.child("options").getValue().toString();
        }
        if(dataSnapshot.hasChild("original_text")){
            original_text = dataSnapshot.child("original_text").getValue().toString();
        }
    }
}

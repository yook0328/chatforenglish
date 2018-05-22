package com.aram.chatproto.Model;

import com.google.firebase.database.DataSnapshot;

import java.util.HashMap;

/**
 * Created by Aram on 2018. 1. 9..
 */

public class User {

    String email;
    String username;
    String type;
    String id;
    String profileImageUrl;
    public User(){

    }
    public User(String email, String id, String profileImageUrl, String type, String username){
        this.email = email;
        this.username = username;
        this.type = type;
        this.id = id;
        this.profileImageUrl = profileImageUrl;
    }
    public User(HashMap<String,String> user){
        this.username = user.get("username");
        this.email = user.get("email");
        this.type = user.get("type");
        this.id = user.get("id");
        this.profileImageUrl = user.get("profileImageUrl");
    }
    public User(DataSnapshot dataSnapshot){
        this.username = dataSnapshot.child("username").getValue().toString();
        this.email = dataSnapshot.child("email").getValue().toString();
        this.profileImageUrl = dataSnapshot.child("profileImageUrl").getValue().toString();
        this.type = dataSnapshot.child("type").getValue().toString();
        this.id = dataSnapshot.child("id").getValue().toString();
    }

    public String getEmail(){ return email; }
    public void setEmail(String email){this.email = email;}
    public String getUsername(){ return username; }
    public void setUsername(String username){this.username = username;}
    public String getType(){ return type; }
    public void setType(String type){this.type = type;}
    public String getId(){ return id; }
    public void setId(String id){this.id = id;}
    public String getProfileImageUrl(){ return profileImageUrl; }
    public void setProfileImageUrl(String profileImageUrl){this.profileImageUrl = profileImageUrl;}
}

package com.aram.chatproto.Model;

import com.aram.chatproto.Events.MyMsgArrayList;
import com.google.firebase.database.DataSnapshot;

/**
 * Created by Aram on 2018. 3. 5..
 */

public class ChatRoom {
    String id;
    User mentor;
    long timestamp;
    MyMsgArrayList<Message> messages = new MyMsgArrayList<>();
    String description;
    String lastMsg;
    boolean isFinish;

    public String getId() {
        return id;
    }

    public User getMentor() {
        return mentor;
    }

    public long getTimestamp() {
        return timestamp;
    }

    public MyMsgArrayList<Message> getMessages() {
        return messages;
    }

    public void setMessages(MyMsgArrayList<Message> messages) {
        this.messages = messages;
    }

    public String getDescription() {

        return description != null ? description : "";
    }

    public boolean isFinish() {
        return isFinish;
    }

    public ChatRoom(DataSnapshot dataSnapshot){

        id = dataSnapshot.getKey();

        isFinish = (boolean)dataSnapshot.child("isFinish").getValue();
        timestamp = (long)dataSnapshot.child("timestamp").getValue();

        if(dataSnapshot.hasChild("description")){
            description = (String)dataSnapshot.child("description").getValue();
        }
    }

    public ChatRoom(String id, long timestamp, boolean isFinish,String description) {
        this.id = id;
        this.timestamp = timestamp;
        this.description = description;
        this.isFinish = isFinish;
    }

    public ChatRoom(String id, boolean isFinish, long timestamp) {
        this.id = id;
        this.timestamp = timestamp;
        this.isFinish = isFinish;
    }

    public void setMentor(User mentor){
        this.mentor = mentor;
    }

    public void addMessages(DataSnapshot dataSnapshot){
        this.messages.add(new Message(dataSnapshot));
    }

}

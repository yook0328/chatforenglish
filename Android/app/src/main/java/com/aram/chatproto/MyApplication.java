package com.aram.chatproto;

import android.app.Application;

import com.aram.chatproto.Events.MyDictionary;
import com.aram.chatproto.Model.ChatRoom;
import com.aram.chatproto.Model.User;
import com.google.firebase.database.ChildEventListener;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

/**
 * Created by Aram on 2018. 1. 28..
 */

public class MyApplication extends Application {
    User user;

    MyDictionary<String, ChatRoom> chatRooms = new MyDictionary<>();


    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public void observeRooms(){
        /////// User 정보가 있는 것을 바탕으로 시작한다
        DatabaseReference database = FirebaseDatabase.getInstance().getReference();
        database.child("user-rooms").child(user.getId()).addChildEventListener(new ChildEventListener() {
            @Override
            public void onChildAdded(DataSnapshot dataSnapshot, String s) {
                observeMentor(dataSnapshot, new ChatRoom(dataSnapshot));
            }

            @Override
            public void onChildChanged(DataSnapshot dataSnapshot, String s) {
                ChatRoom chatRoom = new ChatRoom(dataSnapshot);
                ChatRoom tmp = chatRooms.get(dataSnapshot.getKey());
                chatRoom.setMentor(tmp.getMentor());
                chatRoom.setMessages(tmp.getMessages());

                chatRooms.put(chatRoom.getId(), chatRoom);
            }

            @Override
            public void onChildRemoved(DataSnapshot dataSnapshot) {

            }

            @Override
            public void onChildMoved(DataSnapshot dataSnapshot, String s) {

            }

            @Override
            public void onCancelled(DatabaseError databaseError) {

            }
        });
    }

    void observeMentor(DataSnapshot dataSnapshot, final ChatRoom chatRoom){
        DatabaseReference database = FirebaseDatabase.getInstance().getReference();
        database.child("Users").child((String)dataSnapshot.child("mentor").getValue()).addListenerForSingleValueEvent(new ValueEventListener() {
            @Override
            public void onDataChange(DataSnapshot _dataSnapshot) {
                chatRoom.setMentor(new User(_dataSnapshot));
                chatRooms.put(chatRoom.getId(), chatRoom);

                observeMessages(chatRoom);

            }

            @Override
            public void onCancelled(DatabaseError _databaseError) {

            }
        });
    }

    void observeMessages(final ChatRoom chatRoom){
        final DatabaseReference database = FirebaseDatabase.getInstance().getReference();
        database.child("user-messages").child(user.getId()).child(chatRoom.getId()).addChildEventListener(new ChildEventListener() {
            @Override
            public void onChildAdded(DataSnapshot dataSnapshot, String s) {
                database.child("messages").child(dataSnapshot.getKey()).addListenerForSingleValueEvent(new ValueEventListener() {
                    @Override
                    public void onDataChange(DataSnapshot dataSnapshot) {
                        chatRoom.addMessages(dataSnapshot);
                    }

                    @Override
                    public void onCancelled(DatabaseError databaseError) {

                    }
                });
            }

            @Override
            public void onChildChanged(DataSnapshot dataSnapshot, String s) {

            }

            @Override
            public void onChildRemoved(DataSnapshot dataSnapshot) {

            }

            @Override
            public void onChildMoved(DataSnapshot dataSnapshot, String s) {

            }

            @Override
            public void onCancelled(DatabaseError databaseError) {

            }
        });
    }

}
